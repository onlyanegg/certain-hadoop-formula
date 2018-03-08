{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

hadoop_name_node_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/hdfs_name_node.service
    - source: salt://hadoop/files/hdfs_name_node.service
    - template: jinja
    - context:
        user: {{ hadoop.hdfs.user.name }}
        group: {{ hadoop.hdfs.group.name }}
    - require_in:
      - service: hadoop_name_node

hadoop_name_node_environment_file_installed:
  file.serialize:
    - name: /etc/sysconfig/hadoop_name_node
    - dataset: {{ hadoop.name_node.environment }}
    - formatter: configparser
    - require_in:
      - service: hadoop_name_node
