{% from 'hadoop/settings.sls' import hadoop with context -%}

{#
include:
  - ..install

hadoop_yarn_group_present:
  group.present:
    - name: {{ hadoop.yarn.group.name }}
    - gid: {{ hadoop.yarn.group.gid }}

hadoop_yarn_user_present:
  user.present:
    - name: {{ hadoop.yarn.user.name }}
    - uid: {{ hadoop.yarn.user.uid }}
    - gid_from_name: True
    - createhome: False
    - groups:
      - {{ hadoop.group.name }}
    - require:
      - group: {{ hadoop.group.name }}
      - group: {{ hadoop.yarn.group.name }}
#}
