{% from 'hadoop/settings.sls' import hadoop with context -%}

# {{ hadoop.hdfs.data_node.config['dfs.data_node.data.dir'] }}
{%- set dynamic_config = {
    'dfs.namenode.rpc-address': '{}:{}'.format(salt.sdb.get('sdb://hadoop/name_node'), 8020)
  }
%}
hadoop_hdfs_config_serialized:
  file.serialize:
    - name: /etc/hadoop/hdfs-site.xml
    - dataset: {{
        salt.slsutil.merge(hadoop.hdfs.config,
          salt.slsutil.merge(
            hadoop.hdfs.data_node.config,
            dynamic_config
          )
        ) | string
      }}
    - formatter: xml_hadoop
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - mode: 644
