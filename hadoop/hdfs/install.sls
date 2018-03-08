{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_hdfs_group_present:
  group.present:
    - name: {{ hadoop.hdfs.group.name }}
    - gid: {{ hadoop.hdfs.group.gid }}

hadoop_hdfs_user_present:
  user.present:
    - name: {{ hadoop.hdfs.user.name }}
    - uid: {{ hadoop.hdfs.user.uid }}
    - gid_from_name: True
    - createhome: False
    - require:
      - group: {{ hadoop.hdfs.group.name }}
