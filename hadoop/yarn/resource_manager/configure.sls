{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_yarn_config_serialized:
  file.serialize:
    - name: /etc/hadoop/yarn-site.xml
    - dataset: {{ salt.slsutil.merge(hadoop.yarn.config, hadoop.resource_manager.yarn.config) }}
    - formatter: xml_badgerfish
    - user: {{ hadoop.yarn.user.name }}
    - group: {{ hadoop.yarn.group.name }}
    - makedirs: True
    - mode: 644
