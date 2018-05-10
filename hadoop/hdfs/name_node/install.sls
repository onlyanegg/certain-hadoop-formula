{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

{{ hadoop.hdfs.name_node.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.hdfs.name_node.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.hdfs.name_node.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}

{{ hadoop.hdfs.name_node.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.hdfs.name_node.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{
          salt.slsutil.merge_all([
            hadoop.environment,
            hadoop.hdfs.environment,
            hadoop.hdfs.name_node.environment
          ])
        }}
    - watch_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}

{{ hadoop.hdfs.name_node.service.name }}_name_dir_installed:
  file.directory:
    - name: {{ hadoop.hdfs.name_node.config['dfs.namenode.name.dir'].replace('file://', '') }}
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - require_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}

{% if pillar.bootstrap | default('False') | lower() == 'true' -%}
  {%- set environment = salt.slsutil.merge_all([
      hadoop.environment,
      hadoop.hdfs.environment,
      hadoop.hdfs.name_node.environment
    ])
  %}

{{ hadoop.hdfs.name_node.service.name }}_format_hdfs:
  cmd.run:
    - name: {{ '/opt/hadoop/bin/hdfs --config /etc/hadoop namenode -format {}'.format(hadoop.cluster_name) }}
    - runas: {{ hadoop.user.name }}
    - env:
      - JAVA_HOME: {{ environment.JAVA_HOME }}
    - require_in:
      - service: {{ hadoop.hdfs.name_node.service.name }}
{%- endif %}
