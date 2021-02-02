require 'cocoapods'
require 'cocoapods-xyzqpods/config/config'

module Pod
  class Command
    class Xyzq < Command
        class Lint < Xyzq
            self.summary = 'lint podspec.'

            def self.options
                [
                    ['--mode=[loose|strict]', 'Use one of the available mode, default is loose(--allow-warnings)'],
                    ['--no-clean', 'inspect any issue'],
                    ['--silent', 'Show nothing'],
                ].concat(super).uniq
            end

            def initialize(argv)
                @mode = argv.option('mode') || 'loose'
                @clean = argv.flag?('clean', true)
                @silent = argv.flag?('silent')
                super
            end

            def run
                argvs = []
                if @mode == 'loose'
                    argvs << '--allow-warnings'
                    argvs << '--skip-import-validation'
                end

                unless @clean
                    argvs << '--no-clean'
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
                
                Pod::UI.puts "lint..."
                Pod::UI.puts "#{argvs}"
                lint = Pod::Command::Lib::Lint.new(CLAide::ARGV.new(argvs))
                lint.validate!
                lint.run
              end
        end
    end
  end
end
