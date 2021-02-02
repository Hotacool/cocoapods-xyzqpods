require 'yaml'
require 'cocoapods-xyzqpods/config/config'

module XYZQ
  class Config
    class Asker
      def show_prompt
        print ' >>> '.red
      end

      def ask_with_answer(question, pre_answer, selection)
        print "\n#{question}\n"

        print_selection_info = lambda {
          print "可选值：[ #{selection.join(' / ')} ]\n" if selection
        }
        print_selection_info.call
        print "旧值：#{pre_answer}\n" unless pre_answer.nil?

        answer = ''
        loop do
          show_prompt
          answer = STDIN.gets.chomp.strip

          if answer == '' && !pre_answer.nil?
            answer = pre_answer
            print answer.yellow
            print "\n"
          end

          next if answer.empty?
          break if !selection || selection.include?(answer)

          print_selection_info.call
        end

        answer
      end

      def wellcome_message
        print <<~EOF
          XYZQ Modulization ━(*｀∀´*)ノ亻!
          *******************************************************
          *开始进行XYZQ组件化基础信息配置.                          
          *所有的信息都会保存在 #{XYZQ.config.config_file} 文件中.  
          *你可以在对应目录下手动添加编辑该文件.                      
          *******************************************************
          默认配置信息样式如下：

          #{XYZQ.config.default_config.to_yaml}
        EOF
      end

      def done_message
        print "\n设置完成.\n".green
        puts <<~EOF
          *******************************************************                    
          *所有的信息都会保存在 #{XYZQ.config.config_file} 文件中.  
          *你可以在对应目录下手动添加编辑该文件.                      
          *******************************************************
        EOF
      end
    end
  end
end
