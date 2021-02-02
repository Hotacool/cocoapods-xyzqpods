require 'cocoapods'
require 'cocoapods-xyzqpods/config/config_asker'

module Pod
  class Command
    class Xyzq < Command
        class Config < Xyzq
            self.summary = 'config xyzq.'

            def self.options
                [
                    ['--templateUrl', '远程模板url'],
                    ['--env', "环境 %w[dev debug_iphoneos release_iphoneos]"]
                ].concat(super).uniq
            end

            def initialize(argv)
                @templateUrl = argv.option('templateUrl')
                super
            end

            def run
                if @templateUrl.nil?
                    config_with_asker
                else
                    config_with_url(@templateUrl)
                end
            end

            def config_with_url(url)
                require 'open-uri'
      
                UI.puts "开始下载配置文件...\n"
                file = open(url)
                contents = YAML.safe_load(file.read)
      
                UI.puts "开始同步配置文件...\n"
                XYZQ.config.sync_config(contents.to_hash)
                UI.puts "设置完成.\n".green
              rescue Errno::ENOENT => e
                raise Informative, "配置文件路径 #{url} 无效，请确认后重试."
            end
      
            def config_with_asker
                asker = XYZQ::Config::Asker.new
                asker.wellcome_message
      
                config = {}
                template_hash = XYZQ.config.template_hash
                template_hash.each do |k, v|
                  default = begin
                              XYZQ.config.send(k)
                            rescue StandardError
                              nil
                            end
                  config[k] = asker.ask_with_answer(v[:description], default, v[:selection])
                end
      
                XYZQ.config.sync_config(config)
                asker.done_message
            end
        end
    end
  end
end
