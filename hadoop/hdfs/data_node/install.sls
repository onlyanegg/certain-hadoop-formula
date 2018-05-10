{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

{{ hadoop.hdfs.data_node.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.hdfs.data_node.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.hdfs.data_node.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.hdfs.data_node.service.name }}

{{ hadoop.hdfs.data_node.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.hdfs.data_node.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{
          salt.slsutil.merge_all([
            hadoop.environment,
            hadoop.hdfs.environment,
            hadoop.hdfs.data_node.environment
          ])
        }}
    - watch_in:
      - service: {{ hadoop.hdfs.data_node.service.name }}

{{ hadoop.hdfs.data_node.service.name }}_data_dir_installed:
  file.directory:
    - name: {{ hadoop.hdfs.data_node.config['dfs.datanode.data.dir'].replace('file://', '') }}
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - require_in:
      - service: {{ hadoop.hdfs.data_node.service.name }}
