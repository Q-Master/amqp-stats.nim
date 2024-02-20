import std/[unittest, json]
import amqpstats

const HOST = "http://localhost:15672"
const USER = "guest"
const PASSWD = "guest"

when defined(localTest):
  import amqpstats/types
  proc loadJS(fname: string): string =
    let f = open(fname, fmRead)
    defer: f.close()
    result = f.readAll()

suite "AMQP stats":
  setup:
    let statsM = newAMQPStats(url = HOST, user = USER, passwd = PASSWD)

  test "test overview":
    when defined(localTest):
      let js {.used.} = Overview.loads(loadJS("tests/overview.json"))
    else:
      let js {.used.} = statsM.overview()

  test "cluster-name":
    when not defined(localTest):
      let js {.used.} = statsM.clusterName()
    else:
      discard

  test "nodes":
    when defined(localTest):
      let js {.used.} = seq[Node].loads(loadJS("tests/nodes.json"))
    else:
      let js {.used.} = statsM.nodes()

  test "extensions":
    when not defined(localTest):
      let js {.used.} = statsM.extensions()
    else:
      discard

  test "definitions":
    when defined(localTest):
      let js {.used.} = Definitions.loads(loadJS("tests/definitions.json"))
    else:
      let js {.used.} = statsM.definitions()

  test "connections":
    when defined(localTest):
      let js {.used.} = seq[Connection].loads(loadJS("tests/connections.json"))
    else:
      let js {.used.} = statsM.connections()

  test "channels":
    when defined(localTest):
      let js = seq[RMQChannel].loads(loadJS("tests/channels.json"))
    else:
      let js {.used.} = statsM.channels()

  test "consumers":
    when defined(localTest):
      let js {.used.} = seq[Consumer].loads(loadJS("tests/consumers.json"))
    else:
      let js {.used.}= statsM.consumers()

  test "exchanges":
    when defined(localTest):
      let js {.used.} = seq[Exchange].loads(loadJS("tests/exchanges.json"))
    else:
      let js {.used.} = statsM.exchanges()

  test "queues":
    when defined(localTest):
      let js {.used.} = seq[Queue].loads(loadJS("tests/queues.json"))
    else:
      let js {.used.}= statsM.queues()

  test "bindings":
    when defined(localTest):
      let js {.used.} = seq[Binding].loads(loadJS("tests/bindings.json"))
    else:
      let js {.used.} = statsM.bindings()

  test "vhosts":
    when defined(localTest):
      let js {.used.} = seq[VHost].loads(loadJS("tests/vhosts.json"))
    else:
      let js {.used.} = statsM.vhosts()

  test "users":
    when defined(localTest):
      let js {.used.} = seq[User].loads(loadJS("tests/users.json"))
    else:
      let js {.used.} = statsM.users()

  test "permissions":
    when defined(localTest):
      let js {.used.} = seq[Permission].loads(loadJS("tests/permissions.json"))
    else:
      let js {.used.} = statsM.permissions()
