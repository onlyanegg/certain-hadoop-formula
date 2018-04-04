{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.hdfs.name_node: {{ hadoop.hdfs.name_node }}

{{ hadoop.hdfs.name_node.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.hdfs.name_node.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.hdfs.name_node.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.hdfs.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}

{{ hadoop.hdfs.name_node.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.hdfs.name_node.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ hadoop.hdfs.name_node.environment }}
    - watch_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}

{#-
#
# I think I'd like for this to eventually be handled by a serializer
#
#{{ hadoop.hdfs.name_node.service.name }}_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/{{ hadoop.hdfs.name_node.service.name }}
#    - dataset: {{ hadoop.hdfs.name_node.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.hdfs.name_node.environment }}
#    - watch_in:
#      - service: {{ hadoop.hdfs.name_node.service.name }}
#}

{{ hadoop.hdfs.name_node.service.name }}_name_dir_installed:
  file.directory:
    - name: {{ hadoop.hdfs.name_node.config['dfs.namenode.name.dir'].replace('file://', '') }}
    - user: {{ hadoop.hdfs.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
