import std/[unittest]
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
      for node in statsM.nodesIt:
        let x {.used.} = node.name
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
      for conn in statsM.connectionsIt:
        let x {.used.} = conn.host
      let js {.used.} = statsM.connections()

  test "channels":
    when defined(localTest):
      let js = seq[RMQChannel].loads(loadJS("tests/channels.json"))
    else:
      for chan in statsM.channelsIt:
        let x {.used.} = chan.name
      let js {.used.} = statsM.channels()

  test "consumers":
    when defined(localTest):
      let js {.used.} = seq[Consumer].loads(loadJS("tests/consumers.json"))
    else:
      for cons in statsM.consumersIt:
        let x {.used.} = cons.consumerTag
      let js {.used.}= statsM.consumers()

  test "exchanges":
    when defined(localTest):
      let js {.used.} = seq[Exchange].loads(loadJS("tests/exchanges.json"))
    else:
      for exch in statsM.exchangesIt:
        let x {.used.} = exch.name
      let js {.used.} = statsM.exchanges()

  test "queues":
    when defined(localTest):
      let js {.used.} = seq[Queue].loads(loadJS("tests/queues.json"))
    else:
      for queue in statsM.queuesIt:
        let x {.used.} = queue.node
      let js {.used.}= statsM.queues()

  test "bindings":
    when defined(localTest):
      let js {.used.} = seq[Binding].loads(loadJS("tests/bindings.json"))
    else:
      for bndng in statsM.bindingsIt:
        let x {.used.} = bndng.source
      let js {.used.} = statsM.bindings()

  test "vhosts":
    when defined(localTest):
      let js {.used.} = seq[VHost].loads(loadJS("tests/vhosts.json"))
    else:
      for vh in statsM.vhostsIt:
        let x {.used.} = vh.name
      let js {.used.} = statsM.vhosts()

  test "users":
    when defined(localTest):
      let js {.used.} = seq[User].loads(loadJS("tests/users.json"))
    else:
      for user in statsM.usersIt:
        let x {.used.} = user.name
      let js {.used.} = statsM.users()

  test "permissions":
    when defined(localTest):
      let js {.used.} = seq[Permission].loads(loadJS("tests/permissions.json"))
    else:
      for perm in statsM.permissionsIt:
        let x {.used.} = perm.user
      let js {.used.} = statsM.permissions()
