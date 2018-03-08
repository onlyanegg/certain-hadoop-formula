{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.name_node: {{ hadoop.name_node }}

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
  file.managed:
    - name: /etc/sysconfig/hadoop_name_node
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ hadoop.name_node.environment }}
    - require_in:
      - service: hadoop_name_node

{#
#
# I think I'd like for this to eventually be handled by a serializer
#
#hadoop_name_node_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/hadoop_name_node
#    - dataset: {{ hadoop.name_node.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.name_node.environment }}
#    - require_in:
#      - service: hadoop_name_node
#}
