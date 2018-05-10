{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set resource_manager = hadoop.yarn.resource_manager %}
{%- set node_manager = hadoop.yarn.node_manager %}

{%- set include = [] %}
{%- set watch_in = [] %}
{%- set dataset = [hadoop.yarn.config] %}
{%- if salt['match.{}'.format(resource_manager.target_type)](resource_manager.target) %}
  {%- do include.append('.resource_manager.service') %}
  {%- do watch_in.append('{}_service'.format(resource_manager.service.name)) %}
  {%- do dataset.append(resource_manager.config) %}
{%- endif %}
{%- if salt['match.{}'.format(node_manager.target_type)](node_manager.target) %}
  {%- do include.append('.node_manager.service') %}
  {%- do watch_in.append('{}_service'.format(node_manager.service.name)) %}
  {%- do dataset.append(node_manager.config) %}
  {%- do dataset.append({
      'yarn.resourcemanager.hostname': '{}'.format(
        salt.sdb.get('sdb://hadoop/resource_manager')
      )
    })
  %}
{%- endif %}

include: {{ include }}

hadoop_yarn_config_serialized:
  file.serialize:
    - name: /etc/hadoop/yarn-site.xml
    - dataset: {{ salt.slsutil.merge_all(dataset) | json }}
    - formatter: xml_hadoop
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - mode: 644
    - watch_in: {{ watch_in }}
