{% from 'hadoop/settings.sls' import hadoop with context -%}

{{ hadoop.hdfs.data_node.service.name }}_service:
  service.running:
    - name: {{ hadoop.hdfs.data_node.service.name }}
    - enable: True
