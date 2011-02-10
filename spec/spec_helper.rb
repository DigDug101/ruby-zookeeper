$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../ext', __FILE__))
$LOAD_PATH.uniq!

require 'rubygems'

gem 'flexmock', '~> 0.8.11'

require 'flexmock'
require 'zookeeper'

Zookeeper.logger = Logger.new(File.expand_path('../../test.log', __FILE__)).tap do |log|
  log.level = Logger::DEBUG
end


RSpec.configure do |config|
  config.mock_with :flexmock

  config.before(:all) do
    @zk = Zookeeper.new('localhost:2181')

    # uncomment for driver debugging output
    #@zk.set_debug_level(Zookeeper::ZOO_LOG_LEVEL_DEBUG) unless defined?(::JRUBY_VERSION)
  end

  config.after(:all) do
    @zk.close
  end
end


# method to wait until block passed returns true or timeout (default is 10 seconds) is reached 
def wait_until(timeout=10, &block)
  time_to_stop = Time.now + timeout
  until yield do 
    break if Time.now > time_to_stop
    sleep 0.3
  end
end


