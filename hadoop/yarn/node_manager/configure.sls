{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set dynamic_config = {
    'yarn.resourcemanager.hostname': '{}'.format(salt.sdb.get('sdb://hadoop/resource_manager'))
  }
%}
hadoop_yarn_config_serialized:
  file.serialize:
    - name: /etc/hadoop/yarn-site.xml
    - dataset: {{
        salt.slsutil.merge(
          hadoop.yarn.config, salt.slsutil.merge(
            hadoop.yarn.node_manager.config,
            dynamic_config
          )
        ) | json
      }}
    - formatter: xml_hadoop
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - mode: 644
