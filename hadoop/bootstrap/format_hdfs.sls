{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set hdfs_name_node = salt.sdb.get('sdb://hadoop/name_node') %}
{%- set environment = salt.slsutil.merge(
    hadoop.environment, salt.slsutil.merge(
      hadoop.hdfs.environment,
      hadoop.hdfs.name_node.environment
    )
  )
%}

# I can't do this because the hadoop user hasn't been created yet.
#   I need to format hdfs after the hadoop user has been created, but before it starts up
#   Maybe I can pass an argument to bootstrap or maybe hadoop/bootstrap.sls will be very similar
#     to hadoop/init.sls, but it will inject this format command
format_hdfs:
  cmd.run:
    - name: {{ '/opt/hadoop/bin/hdfs --config /etc/hadoop namenode -format {}'.format(hadoop.cluster_name) }}
    - env:
      - JAVA_HOME: {{ environment.JAVA_HOME }}
