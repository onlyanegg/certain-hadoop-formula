{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set environment = salt.slsutil.merge(
    hadoop.environment, salt.slsutil.merge(
      hadoop.hdfs.environment,
      hadoop.hdfs.name_node.environment
    )
  )
%}

format_hdfs:
  cmd.run:
    - name: {{ '/opt/hadoop/bin/hdfs --config /etc/hadoop namenode -format {}'.format(hadoop.cluster_name) }}
    - runas: {{ hadoop.user.name }}
    - env:
      - JAVA_HOME: {{ environment.JAVA_HOME }}
