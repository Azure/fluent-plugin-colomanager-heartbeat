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

## Trademarks 

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft's Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
