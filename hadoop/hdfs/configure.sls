{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_hdfs_config_serialized:
  file.serialize:
    - name: /etc/hadoop/hdfs-site.xml
    - dataset: {{ hadoop.hdfs.config }}
    - formatter: xml
    - user: {{ hadoop.hdfs.user }}
    - group: {{ hadoop.hdfs.group }}
    - makedirs: True
    - mode: 644
