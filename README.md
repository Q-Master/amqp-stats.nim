# Pure Nim interface for getting various statsistics via RabbitMQ Management plugin

This library is created to make a possibility to read various statistics from RabbitMQ management plugin API. It can be used either in syncronous, or asyncronous code.

More about management plugin and it's API:
- https://www.rabbitmq.com/management.html
- https://rawcdn.githack.com/rabbitmq/rabbitmq-server/v3.12.12/deps/rabbitmq_management/priv/www/api/index.html

## Requirements

To use this library you will need the running RabbitMQ instance with installed management plugin.

## Installation

    nimble install amqpstats

## Usage

Simple examples.
For complete info see library API or [test.nim](tests/test.nim)

### Sync:
```nim
import amqpstats
let statsM = newAMQPStats(url = "http://localhost:15672", user = "guest", passwd = "guest")
let overview = statsM.overview()
```

### Async
```nim
import amqpstats
let statsM = newAMQPStats(url = "http://localhost:15672", user = "guest", passwd = "guest")
let overview = await statsM.overview()
```

## Testing

To start tests you should clone this repository and either:
### 1
Run `nimble test` inside the repo directory. 
This will attempt to connecto to working RabbitMQ instance using `HOST`, `USER` and `PASSWD` variables defined in test.nim.

### 2
Run `nimble test -DlocalTest`.
This will switch the logic of testing and just read the predefined json files in tests directory which you should provide.