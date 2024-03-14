import std/[httpclient, asyncdispatch, json, uri, base64, strutils]
import amqpstats/types
export packets, serialization

type
  AMQPStats* = ref AMQPStatsObj
  AMQPStatsAsync* = ref AMQPStatsAsyncObj

  AMQPBase {.inheritable.} = object
    url: string
    basicAuth: string
  
  AMQPStatsObj = object of AMQPBase
    client: HttpClient

  AMQPStatsAsyncObj = object of AMQPBase
    client: AsyncHttpClient


proc initUrl(self: AMQPStats | AMQPStatsAsync, url, user, passwd: string) =
  if url.endsWith("api"):
    self.url = url & "/"
  elif url.endsWith("api/"):
    self.url = url
  else:
    self.url = url & "/api/"
  self.basicAuth = "Basic " & base64.encode(user & ":" & passwd)

proc callString(self: AMQPStats | AMQPStatsAsync, path: string): Future[string] {.multisync.} =
  self.client.headers["Authorization"] = self.basicAuth
  let resp = await self.client.request(self.url & path, HttpGet)
  if int(resp.code) > 200:
    raise newException(IOError, "Status code " & resp.status)
  let data = await resp.body
  if data == "Not found.":
    raise newException(IOError, "Not found")
  result = data

proc call(self: AMQPStats | AMQPStatsAsync, path: string): Future[JsonNode] {.multisync.} =
  let data = await self.callString(path)
  result = parseJson(data)
  

proc newAMQPStats*(url = "http://localhost:15672", user="guest", passwd="guest"): AMQPStats =
  result.new
  result.initUrl(url, user, passwd)
  result.client = newHttpClient()


proc newAMQPStatsAsync*(url = "http://localhost:15672", user="guest", passwd="guest"): AMQPStatsAsync =
  result.new
  result.initUrl(url, user, passwd)
  result.client = newAsyncHttpClient()

# Overview

proc overview*(self: AMQPStats | AMQPStatsAsync): Future[Overview] {.multisync.} =
  ## Retrieves various random bits of information that describe the whole system.
  let js = await self.callString("overview")
  result = Overview.loads(js)

# Cluster info

proc clusterName*(self: AMQPStats | AMQPStatsAsync): Future[string] {.multisync.} =
  ## Retrieves name identifying this RabbitMQ cluster.
  let js = await self.call("cluster-name")
  result = js["name"].str

# Nodes

proc nodes*(self: AMQPStats | AMQPStatsAsync): Future[seq[Node]] {.multisync.} =
  ## Retrieves a list of nodes in the RabbitMQ cluster.
  let js = await self.callString("nodes")
  result = seq[Node].loads(js)

proc getNode*(self: AMQPStats | AMQPStatsAsync, name: string): Future[Node] {.multisync.} =
  ## Retrieves an individual node in the RabbitMQ cluster. 
  let js = await self.callString("nodes/" & encodeUrl(name))
  result = Node.loads(js)

# Extensions

proc extensions*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of extensions to the management plugin.
  result = await self.call("extensions")

# Definitions

proc definitions*(self: AMQPStats | AMQPStatsAsync): Future[Definitions] {.multisync.} =
  ## Retrieves the server definitions - exchanges, queues, bindings, users, virtual hosts, permissions, topic permissions, and parameters. 
  ## Everything apart from messages.
  let js = await self.callString("definitions")
  result = Definitions.loads(js)

proc vhostDefinitions*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[Definitions] {.multisync.} =
  ## Retrieves the server definitions for a given virtual host - exchanges, queues, bindings and policies. 
  let js = await self.callString("definitions/" & encodeUrl(vhost))
  result = Definitions.loads(js)

# Connections

proc connections*(self: AMQPStats | AMQPStatsAsync): Future[seq[Connection]] {.multisync.} =
  ## Retrieves a list of all open connections.
  let js = await self.callString("connections")
  result = seq[Connection].loads(js)

proc connection*(self: AMQPStats | AMQPStatsAsync, name: string): Future[Connection] {.multisync.} =
  ## Retrieves an individual connection.
  let js = await self.callString("connections/" & encodeUrl(name))
  result = Connection.loads(js)

proc connectionForUser*(self: AMQPStats | AMQPStatsAsync, username: string): Future[Connection] {.multisync.} =
  ## Retrieves a list of all open connections for a specific username.
  let js = await self.callString("connections/username/" & encodeUrl(username))
  result = Connection.loads(js)

proc connectionChannels*(self: AMQPStats | AMQPStatsAsync, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all channels for a given connection. 
  result = await self.call("connections/" & encodeUrl(name) & "/channels")

# Channels

proc channels*(self: AMQPStats | AMQPStatsAsync): Future[seq[RMQChannel]] {.multisync.} =
  ## Retrieves a list of all open channels.
  let js = await self.callString("channels")
  result = seq[RMQChannel].loads(js)

proc channel*(self: AMQPStats | AMQPStatsAsync, name: string): Future[RMQChannel] {.multisync.} =
  ## Retrieves details about an individual channel.
  let js = await self.callString("channels/" & encodeUrl(name))
  result = RMQChannel.loads(js)

# Consumers

proc consumers*(self: AMQPStats | AMQPStatsAsync): Future[seq[Consumer]] {.multisync.} =
  ## Retrieves a list of all consumers.
  let js = await self.callString("consumers")
  result = seq[Consumer].loads(js)

proc vhostConsumers*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[seq[Consumer]] {.multisync.} =
  ## Retrieves a list of all open connections in a specific virtual host.
  let js = await self.callString("consumers/" & encodeUrl(vhost))
  result = seq[Consumer].loads(js)

# Exchanges

proc exchanges*(self: AMQPStats | AMQPStatsAsync): Future[seq[Exchange]] {.multisync.} =
  ## Retrieves a list of all exchanges.
  let js = await self.callString("exchanges")
  result = seq[Exchange].loads(js)

proc vhostExchanges*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[seq[Exchange]] {.multisync.} =
  ## Retrieves a list of all exchanges in a given virtual host.
  let js = await self.callString("exchanges/" & encodeUrl(vhost))
  result = seq[Exchange].loads(js)

proc exchange*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[Exchange] {.multisync.} =
  ## Retrieves details about an individual exchange.
  let js = await self.callString("exchanges/" & encodeUrl(vhost) & "/" & encodeUrl(name))
  result = Exchange.loads(js)

proc exchangeBindingsAsSource*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all bindings in which a given exchange is the source.
  result = await self.call("exchanges/" & encodeUrl(vhost) & "/" & encodeUrl(name) & "/bindings/source")

proc exchangeBindingsAsDestination*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all bindings in which a given exchange is the destination.
  result = await self.call("exchanges/" & encodeUrl(vhost) & "/" & encodeUrl(name) & "/bindings/destination")

# Queues

proc queues*(self: AMQPStats | AMQPStatsAsync): Future[seq[Queue]] {.multisync.} =
  ## Retrieves a list of all queues.
  let js = await self.callString("queues")
  result = seq[Queue].loads(js)

proc vhostQueues*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[seq[Queue]] {.multisync.} =
  ## Retrieves a list of all queues in a given virtual host.
  let js = await self.callString("queues/" & encodeUrl(vhost))
  result = seq[Queue].loads(js)

proc queue*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[Queue] {.multisync.} =
  ## Retrieves details about an individual queue.
  let js = await self.callString("queues/" & encodeUrl(vhost) & "/" & encodeUrl(name))
  result = Queue.loads(js)

proc queueBindings*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[seq[Binding]] {.multisync.} =
  ## Retrieves a list of all bindings on a given queue.
  let js = await self.callString("queues/" & encodeUrl(vhost) & "/" & encodeUrl(name) & "/bindings")
  result = seq[Binding].loads(js)

# Bindings

proc bindings*(self: AMQPStats | AMQPStatsAsync): Future[seq[Binding]] {.multisync.} =
  ## Retrieves a list of all bindings.
  let js = await self.callString("bindings")
  result = seq[Binding].loads(js)

proc vhostBindings*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[seq[Binding]] {.multisync.} =
  ## Retrieves a list of all bindings in a given virtual host.
  let js = await self.callString("bindings/" & encodeUrl(vhost))
  result = seq[Binding].loads(js)

proc bindingsForExchangeQueue*(self: AMQPStats | AMQPStatsAsync, vhost, exchange, queue: string): Future[seq[Binding]] {.multisync.} =
  ## Retrieves a list of all bindings on a given queue.
  let js = await self.callString("bindings/" & encodeUrl(vhost) & "/e/" & encodeUrl(exchange) & "/q/" & encodeUrl(queue))
  result = seq[Binding].loads(js)

proc bindingForExchangeQueue*(
  self: AMQPStats | AMQPStatsAsync, 
  vhost, exchange, queue, binding: string
): Future[Binding] {.multisync.} =
  ## Retrieves an individual binding between an exchange and a queue. 
  ## The binding is a "name" for the binding composed of its routing key and a hash of its arguments. 
  ## binding is the field named "properties_key" from a bindings listing response.
  let js = await self.callString(
    "bindings/" & encodeUrl(vhost) & 
    "/e/" &  encodeUrl(exchange) & 
    "/q/" &  encodeUrl(queue) & 
    "/" & encodeUrl(binding)
  )
  result = Binding.loads(js)

proc bindingsForExchangeSourceAndDestination*(
  self: AMQPStats | AMQPStatsAsync, 
  vhost, source, destination: string
): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all bindings between two exchanges. 
  result = await self.call(
    "bindings/" & encodeUrl(vhost) & 
    "/e/" &  encodeUrl(source) & 
    "/e/" &  encodeUrl(destination)
  )

proc bindingForExchangeSourceAndDestination*(
  self: AMQPStats | AMQPStatsAsync, 
  vhost, source, destination, binding: string
): Future[JsonNode] {.multisync.} =
  ## Retrieves an individual binding between two exchanges. 
  ## The binding is a "name" for the binding composed of its routing key and a hash of its arguments. 
  ## binding is the field named "properties_key" from a bindings listing response.
  result = await self.call(
    "bindings/" & encodeUrl(vhost) & 
    "/e/" &  encodeUrl(source) & 
    "/e/" &  encodeUrl(destination) & 
    "/" & encodeUrl(binding)
  )

# VHosts

proc vhosts*(self: AMQPStats | AMQPStatsAsync): Future[seq[VHost]] {.multisync.} =
  ## Retrieves a list of all vhosts.
  let js = await self.callString("vhosts")
  result = seq[VHost].loads(js)

proc vhost*(self: AMQPStats | AMQPStatsAsync, name: string): Future[VHost] {.multisync.} =
  ## Retrieves details about an individual vhost.
  let js = await self.callString("vhosts/" & encodeUrl(name))
  result = VHost.loads(js)

proc vhostConnections*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all open connections in a specific virtual host.
  result = await self.call("/vhosts/" & encodeUrl(vhost) & "/connections")

proc vhostChannels*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all open connections in a specific virtual host.
  result = await self.call("/vhosts/" & encodeUrl(vhost) & "/channels")

proc vhostPermissions*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all permissions for a given virtual host.
  result = await self.call("/vhosts/" & encodeUrl(vhost) & "/permissions")

proc vhostTopicPermissions*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all topic permissions for a given virtual host.
  result = await self.call("/vhosts/" & encodeUrl(vhost) & "/topic-permissions")

# Users

proc users*(self: AMQPStats | AMQPStatsAsync): Future[seq[User]] {.multisync.} =
  ## Retrieves a list of all users.
  let js = await self.callString("users")
  result = seq[User].loads(js)

proc usersWithoutPermissions*(self: AMQPStats | AMQPStatsAsync): Future[seq[User]] {.multisync.} =
  ## Retrieves a list of all users.
  let js = await self.callString("users/without-permissions")
  result = seq[User].loads(js)

proc user*(self: AMQPStats | AMQPStatsAsync, name: string): Future[User] {.multisync.} =
  ## Retrieves details about an individual user.
  let js = await self.callString("users/" & encodeUrl(name))
  result = User.loads(js)

proc userPermissions*(self: AMQPStats | AMQPStatsAsync, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all permissions for a given user.
  result = await self.call("users/" & encodeUrl(name) & "/permissions")

proc userTopicPermissions*(self: AMQPStats | AMQPStatsAsync, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all topic permissions for a given user.
  result = await self.call("users/" & encodeUrl(name) & "/topic-permissions")

# User limits

proc usersLimits*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list per-user limits for all users. 
  result = await self.call("user-limits")

proc userLimits*(self: AMQPStats | AMQPStatsAsync, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of per-user limits for a specific user. 
  result = await self.call("user-limits/" & encodeUrl(name))

# Who Am I

proc whoAmI*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves details of the currently authenticated user.
  result = await self.call("whoami")

# Permissions

proc permissions*(self: AMQPStats | AMQPStatsAsync): Future[seq[Permission]] {.multisync.} =
  ## Retrieves a list of all permissions for all users.
  let js = await self.callString("permissions")
  result = seq[Permission].loads(js)

proc permissionsForUser*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[Permission] {.multisync.} =
  ## Retrieves an individual permission of a user and virtual host.
  let js = await self.callString("permissions/" & encodeUrl(vhost) & "/" & encodeUrl(name))
  result = Permission.loads(js)

proc topicPermissions*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all topic permissions for all users.
  result = await self.call("topic-permissions")

proc topicPermissionsForUser*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves topic permissions for a user and virtual host.
  result = await self.call("topic-permissions/" & encodeUrl(vhost) & "/" & encodeUrl(name))

# Parameters

proc parameters*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all vhost-scoped parameters.
  result = await self.call("parameters")

proc parametersForComponent*(self: AMQPStats | AMQPStatsAsync, component: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all vhost-scoped parameters for a given component.
  result = await self.call("parameters/" & encodeUrl(component))

proc parametersForComponentOnVhost*(self: AMQPStats | AMQPStatsAsync, component, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all vhost-scoped parameters for a given component and virtual host.
  result = await self.call("parameters/" & encodeUrl(component) & "/" & encodeUrl(vhost))

proc parameterForComponentOnVhost*(self: AMQPStats | AMQPStatsAsync, component, vhost, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves an individual vhost-scoped parameter.
  result = await self.call("parameters/" & encodeUrl(component) & "/" & encodeUrl(vhost) & "/" & encodeUrl(name))

proc globalParameters*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all global parameters.
  result = await self.call("global-parameters")

proc globalParameter*(self: AMQPStats | AMQPStatsAsync, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves an individual global parameter.
  result = await self.call("global-parameters/" & encodeUrl(name))

# Policies

proc policies*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all policies.
  result = await self.call("policies")

proc vhostPolicies*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all policies in a given virtual host.
  result = await self.call("policies/" & encodeUrl(vhost))

proc policy*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves an individual policy.
  result = await self.call("policies/" & encodeUrl(vhost) & "/" & encodeUrl(name))

proc operatorPolicies*(self: AMQPStats | AMQPStatsAsync): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all operator policy overrides.
  result = await self.call("operator-policies")

proc vhostOperatorPolicies*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Retrieves a list of all operator policy overrides in a given virtual host.
  result = await self.call("operator-policies/" & encodeUrl(vhost))

proc operatorPolicy*(self: AMQPStats | AMQPStatsAsync, vhost, name: string): Future[JsonNode] {.multisync.} =
  ## Retrieves an individual operator policy.
  result = await self.call("operator-policies/" & encodeUrl(vhost) & "/" & encodeUrl(name))

# Aliveness

proc vhostAliveness*(self: AMQPStats | AMQPStatsAsync, vhost: string): Future[JsonNode] {.multisync.} =
  ## Declares a test queue on the target node, then publishes and consumes a message. 
  ## Intended to be used as a very basic health check. 
  ## Responds a 200 OK if the check succeeded, otherwise responds with a 503 Service Unavailable. 
  result = await self.call("aliveness-test/" & encodeUrl(vhost))
