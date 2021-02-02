require 'yaml'
require 'cocoapods'

module XYZQ
  class Config
    def config_file
      config_file_with_configuration_env(configuration_env)
    end

    def template_hash
      {
          'configuration_env' => { description: '编译环境', default: 'dev', selection: %w[dev debug_iphoneos release_iphoneos] },
          'repo_name' => { description: '默认私有源名称(若同时开发多个repo，可置空，运行时指定)', default: 'ylbrepo' },
          'repo_url' => { description: '私有源地址', default: 'ssh://git@192.25.103.82:22019/ylb_modulization_ios/ylbrepo.git' },
          'use_public_repo' => { description: '是否使用公有源', default: 'true' }
      }
    end

    def config_file_with_configuration_env(configuration_env)
      file = config_dev_file
      if configuration_env == "release_iphoneos"
        file = config_release_iphoneos_file
      elsif configuration_env == "debug_iphoneos"
        file = config_debug_iphoneos_file
      elsif configuration_env == "dev"
      else
        raise "\n=====  #{configuration_env} 参数有误，请检查%w[dev debug_iphoneos release_iphoneos]===="
      end

      File.expand_path("#{Pod::Config.instance.home_dir}/#{file}")
    end

    def configuration_env
      #如果是dev 再去 podfile的配置文件中获取，确保是正确的， pod update时会用到
      if @configuration_env == "dev" || @configuration_env == nil
        if Pod::Config.instance.podfile
          configuration_env ||= Pod::Config.instance.podfile.configuration_env
        end
        configuration_env ||= "dev"
        @configuration_env = configuration_env
      end
      @configuration_env
    end

    #上传的url
    def binary_upload_url
      cut_string = "/%s/%s/zip"
      binary_download_url[0,binary_download_url.length - cut_string.length]
    end

    def set_configuration_env(env)
      @configuration_env = env
    end

    #包含arm64  armv7架构，xcodebuild 是Debug模式
    def config_debug_iphoneos_file
      "bin_debug_iphoneos.yml"
    end
    #包含arm64  armv7架构，xcodebuild 是Release模式
    def config_release_iphoneos_file
      "bin_release_iphoneos.yml"
    end
    #包含x86 arm64  armv7架构，xcodebuild 是Release模式
    def config_dev_file
      "xyzqpods_dev.yml"
    end

    def sync_config(config)
      File.open(config_file_with_configuration_env(config['configuration_env']), 'w+') do |f|
        f.write(config.to_yaml)
      end
    end

    def default_config
      @default_config ||= Hash[template_hash.map { |k, v| [k, v[:default]] }]
    end

    def load_config
      if File.exist?(config_file)
        YAML.load_file(config_file)
      else
        default_config
      end
    end

    def public_repo_url
      'https://github.com/CocoaPods/Specs.git'
    end

    private
    
    def config
      @config ||= begin
                    @config = OpenStruct.new load_config
        validate!
        @config
      end
    end

    def validate!
      template_hash.each do |k, v|
        selection = v[:selection]
        next if !selection || selection.empty?

        config_value = @config.send(k)
        next unless config_value
        unless selection.include?(config_value)
          raise Pod::Informative, "#{k} 字段的值必须限定在可选值 [ #{selection.join(' / ')} ] 内".red
        end
      end
    end

    def respond_to_missing?(method, include_private = false)
      config.respond_to?(method) || super
    end

    def method_missing(method, *args, &block)
      if config.respond_to?(method)
        config.send(method, *args)
      elsif template_hash.keys.include?(method.to_s)
        raise Pod::Informative, "#{method} 字段必须在配置文件 #{config_file} 中设置, 请执行 init 命令配置或手动修改配置文件".red
      else
        super
      end
    end
  end

  def self.config
    @config ||= Config.new
  end


end
