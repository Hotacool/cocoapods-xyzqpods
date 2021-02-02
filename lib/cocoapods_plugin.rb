require 'cocoapods-xyzqpods/hooks'
require 'cocoapods-xyzqpods/command'

module CocoapodsXYZQ
    Pod::HooksManager.register('cocoapods-xyzqpods', :post_install) do |context|
        Pod::Hooks::InitHooks.new().init_xyzq()
    end
end