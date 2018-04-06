{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set hdfs_name_node = salt.sdb.get('sdb://hadoop/name_node') %}

# I can't do this because the hadoop user hasn't been created yet.
#   I need to format hdfs after the hadoop user has been created, but before it starts up
#   Maybe I can pass an argument to bootstrap or maybe hadoop/bootstrap.sls will be very similar
#     to hadoop/init.sls, but it will inject this format command
format_hdfs:
  salt.function:
    - name: cmd.run
    - tgt: {{ hdfs_name_node }}
    - arg:
      - {{ 'hdfs --config /etc/hadoop -format {}'.format(hadoop.cluster_name) }}
