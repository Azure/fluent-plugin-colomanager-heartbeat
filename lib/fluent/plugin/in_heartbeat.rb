require 'fluent/plugin/input'

module Fluent::Plugin
  class Heartbeat < Input
    Fluent::Plugin.register_input('heartbeat', self)

    config_param :coloId, :string
    config_param :interval, :integer
    config_param :tag, :string

    helpers :timer

    def start
      super

      timer_execute(:heartbeat_timer, interval) {
        time = Fluent::Engine.now
        record = {"message"=>"{\"timestamp\":#{time.to_s}, \"event\":\"heartbeat\", \"data\":{\"coloManagerId\":\"#{coloId}\"}}"}
        router.emit(tag, time, record)
      }
    end
  end
end
