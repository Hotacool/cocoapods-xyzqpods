require 'cocoapods'

module Pod
  class Command
    class Xyzq < Command
        class Init < Xyzq
            self.summary = 'init Podfil for xyzq.'

            def self.options
                [
                    ['--remoteUrl', '远程模板url'],
                    ['--env', "环境 %w[dev debug_iphoneos release_iphoneos]"]
                ].concat(super).uniq
              end

            def run
                Pod::UI.puts "未实现"
              end
        end
    end
  end
end
