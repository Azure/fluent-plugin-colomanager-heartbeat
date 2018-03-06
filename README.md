# Source plugin for sending heartbeats in colomanager message format for [Fluentd](http://fluentd.org)

## Requirements

| fluent-plugin-record-modifier  | fluentd | ruby |
|--------------------------------|---------|------|
| >= 1.0.0 | >= v0.14.0 | >= 2.1 |
|  < 1.0.0 | >= v0.12.0 | >= 1.9 |

## Configuration

    <source>
        @type heartbeat
        tag heartbeat
        interval 10
        coloId SJC2
    </source>

Will send colomanager heartbeat message every 10 seconds with the coloId of SJC2

## Message format

    {
        "timestamp": 1518222029,
        "event": "heartbeat",
        "data": {
            "coloManagerId": "SJC2"
        }
    }

