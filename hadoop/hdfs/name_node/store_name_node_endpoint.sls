{% from 'hadoop/settings.sls' import hadoop with context -%}

# WARNING: This state should not be run outside the context of bootstrapping

include:
  - .service

hadoop_store_name_node_endpoint:
  module.run:
    - name: sdb.set
    - uri: 'sdb://hadoop/name_node'
    - value: '{{ grains.get(hadoop.hdfs.name_node.endpoint_grain) }}'
    - require_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}
