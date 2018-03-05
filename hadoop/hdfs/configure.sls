{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_hdfs_config_serialized:
  file.serialize:
    - name: /etc/hadoop/hdfs-site.xml
    - dataset: {{ hadoop.hdfs.config }}
    - formatter: xml_badgerfish
    - user: {{ hadoop.hdfs.user.name }}
    - group: {{ hadoop.hdfs.group.name }}
    - makedirs: True
    - mode: 644
