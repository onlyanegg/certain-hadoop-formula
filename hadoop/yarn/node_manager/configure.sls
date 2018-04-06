{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_yarn_config_serialized:
  file.serialize:
    - name: /etc/hadoop/yarn-site.xml
    - dataset: {{ salt.slsutil.merge(hadoop.yarn.config, hadoop.yarn.node_manager.config) }}
    - formatter: xml_hadoop
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - mode: 644
