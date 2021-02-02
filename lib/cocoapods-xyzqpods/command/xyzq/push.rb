require 'cocoapods'
require 'cocoapods-xyzqpods/config/config'

module Pod
  class Command
    class Xyzq < Command
        class Push < Xyzq
            self.summary = 'Push new specifications to the spec-repo'

            self.arguments = [
                CLAide::Argument.new('REPO', true, false),
            ]

            def self.options
                [
                    ['--mode=[loose|strict]', 'Use one of the available mode, default is loose(--allow-warnings)'],
                    ['--silent', 'Show nothing'],
                ].concat(super).uniq
            end

            def validate!
                super
                help! 'config未设置默认repo_name，必须指定私有源名称' unless @repo
              end

            def initialize(argv)
                @repo = argv.shift_argument
                if @repo.nil?
                    @repo = XYZQ.config.load_config['repo_name']
                end
                @mode = argv.option('mode') || 'loose'
                @silent = argv.flag?('silent')
                super
            end

            def run
                argvs = []
                argvs << @repo if @repo
                if @mode == 'loose'
                    argvs << '--allow-warnings'
                    argvs << '--use-libraries'
                    argvs << '--use-modular-headers'
                    argvs << '--skip-import-validation'
                end

                if @silent
                    argvs << '--silent'
                else
                    argvs << '--verbose'
                end
                
                repo_url = XYZQ.config.load_config['repo_url']
                if !repo_url.nil?
                    sources = '--sources=' + repo_url
                    if XYZQ.config.load_config['use_public_repo'] == "true"
                        sources << ',' + XYZQ.config.public_repo_url
                    end
                    argvs << sources 
                end
                
                Pod::UI.puts "push..."
                Pod::UI.puts "#{argvs}"
                lint = Pod::Command::Repo::Push.new(CLAide::ARGV.new(argvs))
                lint.validate!
                lint.run
              end
        end
    end
  end
end
