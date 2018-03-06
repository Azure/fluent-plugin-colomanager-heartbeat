require 'fluent/test'
require 'fluent/test/driver/input'
require 'fluent/plugin/in_heartbeat'

class HeartbeatTest < Test::Unit::TestCase
    def setup
        Fluent::Test.setup
    end

    CONFIG = %[
        tag heartbeat
        interval 10
        coloId SJC2
      ]

    def create_driver(conf = CONFIG)
        Fluent::Test::Driver::Input.new(Fluent::Plugin::Heartbeat).configure(conf)
    end

    def test_configure
        d = create_driver
        assert_equal 'heartbeat', d.instance.tag
        assert_equal 10, d.instance.interval
        assert_equal 'SJC2', d.instance.coloId
    end

    def test_run
        d = create_driver

        d.run(expect_emits: 4, timeout: 25)

        events = d.events
        assert_equal 'heartbeat', events[0][0]
        assert_true events[0][2]['message'].include? 'heartbeat'
        assert_true events[0][2]['message'].include? 'SJC2'
        assert_equal 2, events.length
    end
end