{% from 'hadoop/settings.sls' import hadoop with context -%}

{#
include:
  - ..install

hadoop_hdfs_group_present:
  group.present:
    - name: {{ hadoop.hdfs.group.name }}
    - gid: {{ hadoop.hdfs.group.gid }}

hadoop_hdfs_user_present:
  user.present:
    - name: {{ hadoop.user.name }}
    - uid: {{ hadoop.user.uid }}
    - gid_from_name: True
    - createhome: False
    - groups:
      - {{ hadoop.group.name }}
    - require:
      - group: {{ hadoop.group.name }}
      - group: {{ hadoop.hdfs.group.name }}
#}
