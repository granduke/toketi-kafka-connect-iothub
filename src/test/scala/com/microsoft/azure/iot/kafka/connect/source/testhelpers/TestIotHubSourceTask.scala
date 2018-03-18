// Copyright (c) Microsoft. All rights reserved.

package com.microsoft.azure.iot.kafka.connect.source.testhelpers

import java.time.{Duration, Instant}

import com.microsoft.azure.eventhubs.EventPosition
import com.microsoft.azure.iot.kafka.connect.source.{DataReceiver, IotHubSourceTask}

class TestIotHubSourceTask extends IotHubSourceTask {
  override def getDataReceiver(connectionString: String, receiverConsumerGroup: String, partition: String,
      eventPosition: EventPosition, receiveTimeout: Duration): DataReceiver = {
    new MockDataReceiver(connectionString, receiverConsumerGroup, partition, eventPosition, receiveTimeout)
  }
}
