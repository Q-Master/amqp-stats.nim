import std/[tables, options]
import packets/packets
import packets/json/serialization

export packets, serialization

packet Rate:
  var rate*: float

packet MessageStats:
  var ack*: int
  var ackDetails* {.asName: "ack_details".}: Rate
  var confirm*: Option[int]
  var confirmDetails* {.asName: "confirm_details".}: Option[Rate]
  var deliver*: int
  var deliverDetails* {.asName: "deliver_details".}: Rate
  var deliverGet* {.asName: "deliver_get".}: int
  var deliverGetDetails* {.asName: "deliver_get_details".}: Rate
  var deliverNoAck* {.asName: "deliver_no_ack".}: int
  var deliverNoAckDetails* {.asName: "deliver_no_ack_details".}: Rate
  var diskReads* {.asName: "disk_reads".}: Option[int]
  var diskReadsDetails* {.asName: "disk_reads_details".}: Option[Rate]
  var diskWrites* {.asName: "disk_writes".}: Option[int]
  var diskWritesDetails* {.asName: "disk_writes_details".}: Option[Rate]
  var dropUnroutable* {.asName: "drop_unroutable".}: Option[int]
  var dropUnroutableDetails* {.asName: "drop_unroutable_details".}: Option[Rate]
  var get*: int
  var getDetails* {.asName: "get_details".}: Rate
  var getEmpty* {.asName: "get_empty".}: int
  var getEmptyDetails* {.asName: "get_empty_details".}: Rate
  var getNoAck* {.asName: "get_no_ack".}: int
  var getNoAckDetails* {.asName: "get_no_ack_details".}: Rate
  var publish*: Option[int]
  var publishDetails* {.asName: "publish_details".}: Option[Rate]
  var redeliver*: int
  var redeliverDetails* {.asName: "redeliver_details".}: Rate
  var returnUnroutable* {.asName: "return_unroutable".}: Option[int]
  var returnUnroutableDetails* {.asName: "return_unroutable_details".}: Option[Rate]
  var publishIn* {.asName: "publish_in".}: Option[int]
  var publishInDetails* {.asName: "publish_in_details".}: Option[Rate]
  var publishOut* {.asName: "publish_out".}: Option[int]
  var publishOutDetails* {.asName: "publish_out_details".}: Option[Rate]

packet EnabledType:
  var name*: string
  var description*: string
  var enabled*: bool

packet Application:
  var name*: string
  var description*: string
  var version*: string

packet Context:
  var description*: string
  var path*: string
  var cowboy_opts*: string
  var port*: string
  var protocol*: Option[string]

packet GCDetails:
  var fullsweepAfter* {.asName: "fullsweep_after".}: int
  var maxHeapSize* {.asName: "max_heap_size".}: int
  var minBinVheapSize* {.asName: "min_bin_vheap_size".}: int
  var minHeapSize* {.asName: "min_heap_size".}: int
  var minorGcs* {.asName: "minor_gcs".}: int

packet ConnectionDetails:
  var name*: string
  var peerHost* {.asName: "peer_host".}: string
  var peerPort* {.asName: "peer_port".}: int

packet Exchange:
  #var arguments*: None
  var name*: string
  var vhost*: string
  var autoDelete* {.asName: "auto_delete".}: bool
  var durable*: bool
  var internal*: bool
  var messageStats* {.asName: "message_stats".}: Option[MessageStats]
  var exchangeType* {.asName: "type".}: string
  var userWhoPerformedAction* {.asName: "user_who_performed_action".}: Option[string]

packet QueueBase:
  var name*: string
  var vhost*: string
  var durable*: Option[bool]
  var autoDelete* {.asName: "auto_delete".}: Option[bool]
  var arguments*: Option[Table[string, int]]

packet MessagesCommonInfo:
  var messages*: Option[int]
  var messagesDetails* {.asName: "messages_details".}: Option[Rate]
  var messagesReady* {.asName: "messages_ready".}: Option[int]
  var messagesReadyDetails* {.asName: "messages_ready_details".}: Option[Rate]
  var messagesUnacknowledged* {.asName: "messages_unacknowledged".}: Option[int]
  var messagesUnacknowledgedDetails* {.asName: "messages_unacknowledged_details".}: Option[Rate]

packet User:
  var name*: string
  var passwordHash* {.asName: "password_hash".}: string
  var hashingAlgorithm* {.asName: "hashing_algorithm".}: string
  var tags*: seq[string]
  #var limits*: None

packet Permission:
  var user*: string
  var vhost*: string
  var configure*: string
  var write*: string
  var read*: string

# Overview

packet OverviewRetentionPolicies:
  var global*: seq[int]
  var basic*: seq[int]
  var detailed*: seq[int]

packet OverviewListener:
  var node*: string
  var protocol*: string
  var ipAddress* {.asName:"ip_address".}: string
  var port*: int

packet OverviewContext:
  var node*: string
  var description*: string
  var path*: string
  var port*: string
  var protocol*: Option[string]

packet OverviewChurnRates:
  var channelClosed* {.asName: "channel_closed".}: int
  var channelClosedDetails* {.asName: "channel_closed_details".}: Rate
  var channelCreated* {.asName: "channel_created".}: int
  var channelCreatedDetails* {.asName: "channel_created_details".}: Rate
  var connectionClosed* {.asName: "connection_closed".}: int
  var connectionClosedDetails* {.asName: "connection_closed_details".}: Rate
  var connectionCreated* {.asName: "connection_created".}: int
  var connectionCreatedDetails* {.asName: "connection_created_details".}: Rate
  var queueCreated* {.asName: "queue_created".}: int
  var queueCreatedDetails* {.asName: "queue_created_details".}: Rate
  var queueDeclared* {.asName: "queue_declared".}: int
  var queueDeclaredDetails* {.asName: "queue_declared_details".}: Rate
  var queueDeleted* {.asName: "queue_deleted".}: int
  var queueDeletedDetails* {.asName: "queue_deleted_details".}: Rate

packet OverviewObjectTotals:
  var channels*: int
  var connections*: int
  var consumers*: int
  var exchanges*: int
  var queues*: int

packet Overview:
  var managementVersion* {.asName: "management_version".}: string
  var ratesMode* {.asName: "rates_mode".}: string
  var productVersion* {.asName: "product_version".}: string
  var productName* {.asName: "product_name".}: string
  var rabbitmqVersion* {.asName: "rabbitmq_version".}: string
  var clusterName* {.asName: "cluster_name".}: string
  var erlangVersion* {.asName: "erlang_version".}: string
  var erlangFullVersion* {.asName: "erlang_full_version".}: string
  var releaseSeriesSupportStatus* {.asName: "release_series_support_status".}: string
  var disableStats* {.asName: "disable_stats".}: bool
  var isOpPolicyUpdatingEnabled* {.asName: "is_op_policy_updating_enabled".}: bool
  var enableQueueTotals* {.asName: "enable_queue_totals".}: bool
  var statisticsDbEventQueue* {.asName: "statistics_db_event_queue".}: int
  var node*: string
  var sampleRetentionPolicies* {.asName: "sample_retention_policies".}: OverviewRetentionPolicies
  var exchangeTypes* {.asName: "exchange_types".}: seq[EnabledType]
  var messageStats* {.asName: "message_stats".}: Option[MessageStats]
  var churnRates* {.asName: "churn_rates".}: OverviewChurnRates
  var queueTotals* {.asName: "queue_totals".}: MessagesCommonInfo
  var objectTotals* {.asName: "object_totals".}: OverviewObjectTotals
  var listeners*: seq[OverviewListener]
  var contexts*: seq[OverviewContext]

# Node

packet NodeRaOpenFileMetrics:
  var raLogWal* {.asName: "ra_log_wal".}: int
  var raLogSegmentWriter* {.asName: "ra_log_segment_writer".}: int

packet NodeMetricsGCQueueLength:
  var connectionClosed* {.asName: "connection_closed".}: int
  var channelClosed* {.asName: "channel_closed".}: int
  var consumerDeleted* {.asName: "consumer_deleted".}: int
  var exchangeDeleted* {.asName: "exchange_deleted".}: int
  var queueDeleted* {.asName: "queue_deleted".}: int
  var vhostDeleted* {.asName: "vhost_deleted".}: int
  var nodeNodeDeleted* {.asName: "node_node_deleted".}: int
  var channelConsumerDeleted* {.asName: "channel_consumer_deleted".}: int

packet Node:
  var name*: string
  var osPID* {.asName: "os_pid".}: string
  var fdTotal* {.asName: "fd_total".}: int
  var socketsTotal* {.asName: "sockets_total".}: int
  var memLimit* {.asName: "mem_limit".}: int
  var memAlarm* {.asName: "mem_alarm".}: bool
  var diskFreeLimit* {.asName: "disk_free_limit".}: int
  var diskFreeAlarm* {.asName: "disk_free_alarm".}: bool
  var procTotal* {.asName: "proc_total".}: int
  var ratesMode* {.asName: "rates_mode".}: string
  var uptime*: int
  var runQueue* {.asName: "run_queue".}: int
  var processors*: int
  var nodeType* {.asName: "type".}: string
  var running*: bool
  var memCalculationStrategy* {.asName: "mem_calculation_strategy".}: string
  var netTicktime* {.asName: "net_ticktime".}: int
  var dbDir* {.asName: "db_dir".}: string
  var exchangeTypes* {.asName: "exchange_types".}: seq[EnabledType]
  var authMechanisms* {.asName: "auth_mechanisms"}: seq[EnabledType]
  var applications*: seq[Application]
  var contexts*: seq[Context]
  var logFiles* {.asName: "log_files".}: seq[string]
  var configFiles* {.asName: "config_files".}: seq[string]
  var enabledPlugins* {.asName: "enabled_plugins".}: seq[string]
  var memUsed* {.asName: "mem_used".}: int
  var memUsedDetails* {.asName: "mem_used_details".}: Rate
  var fdUsed* {.asName: "fd_used".}: int
  var fdUsedDetails* {.asName: "fd_used_details".}: Rate
  var socketsUsed* {.asName: "sockets_used".}: int
  var socketsUsedDetails* {.asName: "sockets_used_details".}: Rate
  var procUsed* {.asName: "proc_used".}: int
  var procUsedDetails* {.asName: "proc_used_details".}: Rate
  var diskFree* {.asName: "disk_free".}: int
  var diskFreeDetails* {.asName: "disk_free_details".}: Rate
  var gcNum* {.asName: "gc_num".}: int
  var gcNumDetails* {.asName: "gc_num_details".}: Rate
  var gcBytesReclaimed* {.asName: "gc_bytes_reclaimed".}: int
  var gcBytesReclaimedDetails* {.asName: "gc_bytes_reclaimed_details".}: Rate
  var contextSwitches* {.asName: "context_switches".}: int
  var contextSwitchesDetails* {.asName: "context_switches_details".}: Rate
  var ioReadCount* {.asName: "io_read_count".}: int
  var ioReadCountDetails* {.asName: "io_read_count_details".}: Rate
  var ioReadBytes* {.asName: "io_read_bytes".}: int
  var ioReadBytesDetails* {.asName: "io_read_bytes_details".}: Rate
  var ioReadAvgTime* {.asName: "io_read_avg_time".}: float
  var ioReadAvgTimeDetails* {.asName: "io_read_avg_time_details".}: Rate
  var ioWriteCount* {.asName: "io_write_count".}: int
  var ioWriteCountDetails* {.asName: "io_write_count_details".}: Rate
  var ioWriteBytes* {.asName: "io_write_bytes".}: int
  var ioWriteBytesDetails* {.asName: "io_write_bytes_details".}: Rate
  var ioWriteAvgTime* {.asName: "io_write_avg_time".}: float
  var ioWriteAvgTimeDetails* {.asName: "io_write_avg_time_details".}: Rate
  var ioSyncCount* {.asName: "io_sync_count".}: int
  var ioSyncCountDetails* {.asName: "io_sync_count_details".}: Rate
  var ioSyncAvgTime* {.asName: "io_sync_avg_time".}: float
  var ioSyncAvgTimeDetails* {.asName: "io_sync_avg_time_details".}: Rate
  var ioSeekCount* {.asName: "io_seek_count".}: int
  var ioSeekCountDetails* {.asName: "io_seek_count_details".}: Rate
  var ioSeekAvgTime* {.asName: "io_seek_avg_time".}: float
  var ioSeekAvgTimeDetails* {.asName: "io_seek_avg_time_details".}: Rate
  var ioReopenCount* {.asName: "io_reopen_count".}: int
  var ioReopenCountDetails* {.asName: "io_reopen_count_details".}: Rate
  var mnesiaRamTxCount* {.asName: "mnesia_ram_tx_count".}: int
  var mnesiaRamTxCountDetails* {.asName: "mnesia_ram_tx_count_details".}: Rate
  var mnesiaDiskTxCount* {.asName: "mnesia_disk_tx_count".}: int
  var mnesiaDiskTxCountDetails* {.asName: "mnesia_disk_tx_count_details".}: Rate
  var msgStoreReadCount* {.asName: "msg_store_read_count".}: int
  var msgStoreReadCountDetails* {.asName: "msg_store_read_count_details".}: Rate
  var msgStoreWriteCount* {.asName: "msg_store_write_count".}: int
  var msgStoreWriteCountDetails* {.asName: "msg_store_write_count_details".}: Rate
  var queueIndexWriteCount* {.asName: "queue_index_write_count".}: int
  var queueIndexWriteCountDetails* {.asName: "queue_index_write_count_details".}: Rate
  var queueIndexReadCount* {.asName: "queue_index_read_count".}: int
  var queueIndexReadCountDetails* {.asName: "queue_index_read_count_details".}: Rate
  var connectionCreated* {.asName: "connection_created".}: int
  var connectionCreatedDetails* {.asName: "connection_created_details".}: Rate
  var connectionClosed* {.asName: "connection_closed".}: int
  var connectionClosedDetails* {.asName: "connection_closed_details".}: Rate
  var channelCreated* {.asName: "channel_created".}: int
  var channelCreatedDetails* {.asName: "channel_created_details".}: Rate
  var channelClosed* {.asName: "channel_closed".}: int
  var channelClosedDetails* {.asName: "channel_closed_details".}: Rate
  var queueDeclared* {.asName: "queue_declared".}: int
  var queueDeclaredDetails* {.asName: "queue_declared_details".}: Rate
  var queueCreated* {.asName: "queue_created".}: int
  var queueCreatedDetails* {.asName: "queue_created_details".}: Rate
  var queueDeleted* {.asName: "queue_deleted".}: int
  var queueDeletedDetails* {.asName: "queue_deleted_details".}: Rate
  var partitions*: seq[string]
  var clusterLinks* {.asName: "cluster_links".}: seq[string]
  var beingDrained* {.asName: "being_drained".}: Option[bool]
  var raOpenFileMetrics* {.asName: "ra_open_file_metrics".}: NodeRaOpenFileMetrics
  var metricsGcQueueLength* {.asName: "metrics_gc_queue_length".}: NodeMetricsGCQueueLength

# Definitions

packet Binding:
  var source*: string
  var vhost*: string
  var destination*: string
  var destinationType* {.asName: "destination_type".}: string
  var routingKey* {.asName: "routing_key".}: string
  var propertiesKey* {.asName: "properties_key".}: Option[string]

packet DefinitionsVhost:
  var name*: string

packet Definitions:
  var rabbitVersion* {.asName: "rabbit_version".}: string
  var rabbitmqVersion* {.asName: "rabbitmq_version".}: string
  var productName* {.asName: "product_name".}: string
  var productVersion* {.asName: "product_version".}: string
  var users*: seq[User]
  var vhosts*: seq[DefinitionsVhost]
  var permissions*: seq[Permission]
  var queues*: seq[QueueBase]
  var exchanges*: seq[Exchange]
  var bindings*: seq[Binding]

# Connections

packet ClientPropertiesCapabilities:
  var authenticationFailureClose* {.asName: "authentication_failure_close".}: bool
  var basicNack* {.asName: "basic.nack".}: Option[bool]
  var connectionBlocked* {.asName: "connection.blocked".}: Option[bool]
  var consumerCancelNotify* {.asName: "consumer_cancel_notify".}: bool
  var publisherConfirms* {.asName: "publisher_confirms".}: Option[bool]

packet ClientProperties:
  var capabilities*: ClientPropertiesCapabilities
  var information*: string
  var platform*: string
  var product*: string
  var version*: string

packet Connection of ConnectionDetails:
  var authMechanism* {.asName: "auth_mechanism".}: string
  var channelMax* {.asName: "channel_max".}: int
  var channels*: int
  var connectedAt* {.asName: "connected_at".}: int
  var frameMax* {.asName: "frame_max".}: int
  var host*: string
  var node*: string
  var clientProperties* {.asName: "client_properties".}: ClientProperties
  var garbageCollection* {.asName: "garbage_collection".}: GCDetails
  var port*: int
  var protocol*: string
  var recvCnt* {.asName: "recv_cnt".}: int
  var recvOct* {.asName: "recv_oct".}: int
  var recvOctDetails* {.asName: "recv_oct_details".}: Rate
  var reductions*: int
  var reductionsDetails* {.asName: "reductions_details".}: Rate
  var sendCnt* {.asName: "send_cnt".}: int
  var sendOct* {.asName: "send_oct".}: int
  var sendOctDetails* {.asName: "send_oct_details".}: Rate
  var sendPend* {.asName: "send_pend".}: int
  var ssl*: bool
  var state*: string
  var timeout*: int
  var connectionType* {.asName: "type".}: string
  var user*: string
  var userWhoPerformedAction* {.asName: "user_who_performed_action".}: string
  var vhost*: string

# Channels

packet RMQChannel:
  var acksUncommitted* {.asName: "acks_uncommitted".}: int
  var confirm*: bool
  var connectionDetails* {.asName: "connection_details".}: ConnectionDetails
  var consumerCount* {.asName: "consumer_count".}: int
  var garbageCollection* {.asName: "garbage_collection".}: GCDetails
  var globalPrefetchCount* {.asName: "global_prefetch_count".}: int
  var idleSince* {.asName: "idle_since".}: Option[string]
  var messageStats* {.asName: "message_stats".}: Option[MessageStats]
  var messagesUnacknowledged* {.asName: "messages_unacknowledged".}: int
  var messagesUncommitted* {.asName: "messages_uncommitted".}: int
  var messagesUnconfirmed* {.asName: "messages_unconfirmed".}: int
  var name*: string
  var node*: string
  var number*: int
  var pendingRaftCommands* {.asName: "pending_raft_commands".}: int
  var prefetchCount* {.asName: "prefetch_count".}: int
  var reductions*: int
  var reductionsDetails* {.asName: "reductions_details".}: Rate
  var state*: string
  var transactional*: bool
  var user*: string
  var userWhoPerformedAction* {.asName: "user_who_performed_action".}: string
  var vhost*: string

# Consumers

packet ChannelDetails:
  var connectionName* {.asName: "connection_name".}: string
  var name*: string
  var node*: string
  var number*: int
  var peerHost* {.asName: "peer_host".}: string
  var peerPort* {.asName: "peer_port".}: int
  var user*: string

packet Consumer:
  #var arguments*: None
  var ackRequired* {.asName: "ack_required".}: bool
  var active*: bool
  var activityStatus* {.asName: "activity_status".}: string
  var channelDetails* {.asName: "channel_details".}: ChannelDetails
  var consumerTag* {.asName: "consumer_tag".}: string
  var consumerTimeout* {.asName: "consumer_timeout".}: int
  var exclusive*: bool
  var prefetchCount* {.asName: "prefetch_count".}: int
  var queue*: QueueBase


# Queue

packet QueueBackingStatus:
  var avgAckEgressRate* {.asName: "avg_ack_egress_rate".}: float
  var avgAckIngressRate* {.asName: "avg_ack_ingress_rate".}: float
  var avgEgressRate* {.asName: "avg_egress_rate".}: float
  var avgIngressRate* {.asName: "avg_ingress_rate".}: float
  #var delta*: seq
  var len*: int
  var mode*: string
  var nextDeliverSeqId* {.asName: "next_deliver_seq_id".}: int
  var nextSeqId* {.asName: "next_seq_id".}: int
  var numPendingAcks* {.asName: "num_pending_acks".}: int
  var numUnconfirmed* {.asName: "num_unconfirmed".}: int
  var q1*: int
  var q2*: int
  var q3*: int
  var q4*: int
  var qsBufferSize* {.asName: "qs_buffer_size".}: int
  var targetRamCount* {.asName: "target_ram_count".}: string
  var version*: int

packet Queue of QueueBase:
  var node*: string
  var queueType* {.asName: "type".}: string
  var exclusive*: bool
  var backingQueueStatus* {.asName: "backing_queue_status".}: Option[QueueBackingStatus]
  var consumerCapacity* {.asName: "consumer_capacity".}: Option[float]
  var consumerUtilisation* {.asName: "consumer_utilisation".}: Option[float]
  var consumers*: Option[int]
  var exclusiveConsumerTag* {.asName: "exclusive_consumer_tag".}: Option[string]
  var garbageCollection* {.asName: "garbage_collection".}: Option[GCDetails]
  var headMessageTimestamp* {.asName: "head_message_timestamp".}: Option[int]
  var memory*: Option[int]
  var messageStats* {.asName: "message_stats".}: Option[MessageStats]
  var messages*: Option[int]
  var messagesDetails* {.asName: "messages_details".}: Option[Rate]
  var messageBytes* {.asName: "message_bytes".}: Option[int]
  var messageBytesPagedOut* {.asName: "message_bytes_paged_out".}: Option[int]
  var messageBytesPersistent* {.asName: "message_bytes_persistent".}: Option[int]
  var messageBytesRam* {.asName: "message_bytes_ram".}: Option[int]
  var messageBytesReady* {.asName: "message_bytes_ready".}: Option[int]
  var messageBytesUnacknowledged* {.asName: "message_bytes_unacknowledged".}: Option[int]
  var messagesPagedOut* {.asName: "messages_paged_out".}: Option[int]
  var messagesPersistent* {.asName: "messages_persistent".}: Option[int]
  var messagesRam* {.asName: "messages_ram".}: Option[int]
  var messagesReady* {.asName: "messages_ready".}: Option[int]
  var messagesReadyDetails* {.asName: "messages_ready_details".}: Option[Rate]
  var messagesReadyRam* {.asName: "messages_ready_ram".}: Option[int]
  var messagesUnacknowledged* {.asName: "messages_unacknowledged".}: Option[int]
  var messagesUnacknowledgedDetails* {.asName: "messages_unacknowledged_details".}: Option[Rate]
  var messagesUnacknowledgedRam* {.asName: "messages_unacknowledged_ram".}: Option[int]
  var reductions*: Option[int]
  var reductionsDetails* {.asName: "reductions_details".}: Option[Rate]
  var singleActiveConsumerTag* {.asName: "single_active_consumer_tag".}: Option[string]
  var state*: Option[string]
  var idleSince* {.asName: "idle_since".}: Option[string]
  #var effectivePolicyDefinition* {.asName: "effective_policy_definition".}: None
  #var operatorPolicy* {.asName: "operator_policy".}: None
  #var policy*: None
  #var recoverableSlaves* {.asName: "recoverable_slaves".}: None

# VHosts

packet Metadata:
  var description*: string
  var tags*: seq[string]

packet VHost of MessagesCommonInfo:
  var clusterState* {.asName: "cluster_state".}: Table[string, string]
  var defaultQueueType* {.asName: "default_queue_type".}: string
  var description*: string
  var messageStats* {.asName: "message_stats".}: Option[MessageStats]
  var metadata*: Metadata
  var name*: string
  var recvOct* {.asName: "recv_oct".}: Option[int]
  var recvOctDetails* {.asName: "recv_oct_details".}: Option[Rate]
  var sendOct* {.asName: "send_oct".}: Option[int]
  var sendOctDetails* {.asName: "send_oct_details".}: Option[Rate]
  var tags*: seq[string]
  var tracing*: bool
