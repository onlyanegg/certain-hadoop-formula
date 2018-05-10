Hadoop
----
A Salt formula to install hadoop

Currently supports HDFS and YARN

Dependencies:
----

- xml_hadoop custom serializer
  - Python lxml
  - Serializer external modules patch - https://github.com/saltstack/salt/pull/46435
- slsutil.merge_all function - https://github.com/saltstack/salt/pull/47679

Minimal Configuration:
----

hadoop:
  hdfs:
    name_node:
      target: 'hdfs01*'
    data_node:
      target: 'hdfs*'
  yarn:
    resource_manager:
      target: 'yarn01*'
    node_manager:
      target: 'yarn*'

Bootstrap:
----

Passing the bootstrap pillar tells the NameNode and ResourceManager to store
their endpoints in SDB and tells the NameNode to format HDFS.

```
salt '<tgt>' state.apply hadoop pillar='{"bootstrap": "True"}'
```

Available States:
----

**hadoop**

Install Hadoop YARN and HDFS

**hadoop.install**

Install user and  packages

**hadoop.hdfs**

Install Hadoop HDFS

**hadoop.hdfs.configure**

Manage hdfs-site.xml

**hadoop.hdfs.name_node**

Install Hadoop HDFS NameNode

**hadoop.hdfs.name_node.install**

Manage service and environment file, and format HDFS

**hadoop.hdfs.name_node.service**

Start the NameNode service

**hadoop.hdfs.name_node.store_name_node_endpoint**

Store the NameNode endpoint in SDB

**hadoop.hdfs.data_node**

Install Hadoop HDFS DataNode

**hadoop.hdfs.data_node.install**

Manage service and environment file

**hadoop.hdfs.data_node.service**

Start the NameNode service

**hadoop.yarn**

Install Hadoop YARN

**hadoop.yarn.configure**

Manage yarn-site.xml

**hadoop.yarn.resource_manager**

Install Hadoop YARN ResourceManager

**hadoop.yarn.resource_manager.install**

Manage service and environment file

**hadoop.yarn.resource_manager.service**

Start the ResourceManager service

**hadoop.yarn.resource_manager.store_resource_manager_endpoint**

Store the ResourceManager endpoint in SDB

**hadoop.yarn.node_manager**

Install Hadoop YARN NodeManager

**hadoop.yarn.node_manager.install**

Manage service and environment file

**hadoop.yarn.node_manager.service**

Start the NodeManager service
