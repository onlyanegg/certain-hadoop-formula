{% from 'hadoop/settings.sls' import hadoop with context -%}

{{ hadoop.hdfs.name_node.service.name }}_service:
  service.running:
    - name: {{ hadoop.hdfs.name_node.service.name }}
    - enable: True
