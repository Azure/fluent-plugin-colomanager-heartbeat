require 'fluent/test'
require 'fluent/test/driver/input'
require 'fluent/plugin/in_heartbeat'

class HeartbeatTest < Test::Unit::TestCase
    def setup
        Fluent::Test.setup
    end

    QUEUE_CONFIG = %[
        tag heartbeat
        interval 10
        coloId 12345678-1234-1234-abcd-abcd-123456789012
      ]

    MDSD_CONFIG = %[
        tag heartbeat
        interval 10
        coloId 12345678-1234-1234-abcd-abcd-123456789012
        mdsd true
        coloRegion SJC2
        serviceBuild master_22
      ]

    def create_driver(conf)
        Fluent::Test::Driver::Input.new(Fluent::Plugin::Heartbeat).configure(conf)
    end

    def test_queue_configure
        d = create_driver(QUEUE_CONFIG)
        assert_equal 'heartbeat', d.instance.tag
        assert_equal 10, d.instance.interval
        assert_equal '12345678-1234-1234-abcd-abcd-123456789012', d.instance.coloId
        assert_equal false, d.instance.mdsd
        assert_equal '', d.instance.coloRegion
        assert_equal '', d.instance.serviceBuild
    end

    def test_mdsd_configure
        d = create_driver(MDSD_CONFIG)
        assert_equal 'heartbeat', d.instance.tag
        assert_equal 10, d.instance.interval
        assert_equal '12345678-1234-1234-abcd-abcd-123456789012', d.instance.coloId
        assert_equal true, d.instance.mdsd
        assert_equal 'SJC2', d.instance.coloRegion
        assert_equal 'master_22', d.instance.serviceBuild
    end

    def test_queue_run
        d = create_driver(QUEUE_CONFIG)

        d.run(expect_emits: 4, timeout: 25)

        events = d.events
        assert_equal 'heartbeat', events[0][0]
        assert_true events[0][2]['message'].include? 'heartbeat'
        assert_true events[0][2]['message'].include? '12345678-1234-1234-abcd-abcd-123456789012'
        assert_equal 2, events.length
    end

    def test_mdsd_run
        d = create_driver(MDSD_CONFIG)

        d.run(expect_emits: 4, timeout: 25)

        events = d.events
        assert_equal 'heartbeat', events[0][0]
        assert_true events[0][2]['message'].include? "HEARTBEAT from a SJC2 fluentd at"
        assert_equal '12345678-1234-1234-abcd-abcd-123456789012', events[0][2]['servicedeploymentinstance']
        assert_equal 'json', events[0][2]['format']
        assert_equal 'info', events[0][2]['level']
        assert_equal 'master_22', events[0][2]['serviceBuild']
        assert_equal 2, events.length
    end
end