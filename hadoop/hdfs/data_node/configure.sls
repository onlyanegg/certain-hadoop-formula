{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set dynamic_config = {} %}
{#
    'dfs.namenode.rpc-address': '{}:{}'.format(salt.sdb.get('sdb://hadoop/name_node'), 50070)
  }
%}
#}
hadoop_hdfs_config_serialized:
  file.serialize:
    - name: /etc/hadoop/hdfs-site.xml
    - dataset: {{
        salt.slsutil.merge(hadoop.hdfs.config,
          salt.slsutil.merge(
            hadoop.hdfs.data_node.config,
            dynamic_config
          )
        )
      }}
    - formatter: xml_hadoop
    - user: {{ hadoop.hdfs.user.name }}
    - group: {{ hadoop.hdfs.group.name }}
    - makedirs: True
    - mode: 644
