require 'cocoapods-xyzqpods/command/xyzq/init'
require 'cocoapods-xyzqpods/command/xyzq/lint'
require 'cocoapods-xyzqpods/command/xyzq/config'
require 'cocoapods-xyzqpods/command/xyzq/push'

module Pod
  class Command
    # This is an example of a cocoapods plugin adding a top-level subcommand
    # to the 'pod' command.
    #
    # You can also create subcommands of existing or new commands. Say you
    # wanted to add a subcommand to `list` to show newly deprecated pods,
    # (e.g. `pod list deprecated`), there are a few things that would need
    # to change.
    #
    # - move this file to `lib/pod/command/list/deprecated.rb` and update
    #   the class to exist in the the Pod::Command::List namespace
    # - change this class to extend from `List` instead of `Command`. This
    #   tells the plugin system that it is a subcommand of `list`.
    # - edit `lib/cocoapods_plugins.rb` to require this file
    #
    # @todo Create a PR to add your plugin to CocoaPods/cocoapods.org
    #       in the `plugins.json` file, once your plugin is released.
    #
    class Xyzq < Command
      self.summary = 'cocoapods plugins for xyzq.'
      self.abstract_command = true
      # self.default_subcommand = 'init'

      self.description = <<-DESC
        tools for xyzq moduliazation repos management.
      DESC

      def initialize(argv)
        @help = argv.flag?('help')
        Pod::UI.puts "xyzq running >>"
        super
      end

      def validate!
        super
        banner! if @help
      end

    end
  end
end
