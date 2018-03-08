{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_name_node_service:
  service.running:
    - name: hadoop_name_node
    - enable: True
