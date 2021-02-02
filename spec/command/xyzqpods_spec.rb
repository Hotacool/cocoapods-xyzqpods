require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Xyzqpods do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ xyzq }).should.be.instance_of Command::Xyzq
      end
    end
  end
end

