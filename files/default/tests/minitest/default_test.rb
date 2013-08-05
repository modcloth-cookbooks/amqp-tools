require 'minitest/spec'

describe 'amqp-tools::default' do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  %w(
    amqp-consume-cat
    amqp-publish-files
  ).each do |exe|
    it "builds and installs #{exe} via the amqp-tools Makefile" do
      assert_sh "#{exe} -version | grep -v '<unknown>'"
      assert_sh "#{exe} -rev | grep -v '<unknown>'"
    end
  end
end
