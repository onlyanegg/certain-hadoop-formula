{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_hdfs_config_serialized:
  file.serialize:
    - name: /etc/hadoop/hdfs-site.xml
    - dataset: {{ salt.slsutil.merge(hadoop.hdfs.config, hadoop.hdfs.name_node.config) }}
    - formatter: xml_hadoop
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - mode: 644
