{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set name_node = hadoop.hdfs.name_node %}
{%- set data_node = hadoop.hdfs.data_node %}

{%- set include = [] %}
{%- set watch_in = [] %}
{%- set dataset = [hadoop.hdfs.config] %}
{%- if salt['match.{}'.format(name_node.target_type)](name_node.target) %}
  {%- do include.append('.name_node.service') %}
  {%- do watch_in.append('{}_service'.format(hadoop.hdfs.name_node.service.name)) %}
  {%- do dataset.append(name_node.config) %}
{%- endif %}
{%- if salt['match.{}'.format(data_node.target_type)](data_node.target) %}
  {%- do include.append('.data_node.service') %}
  {%- do watch_in.append('{}_service'.format(hadoop.hdfs.data_node.service.name)) %}
  {%- do dataset.append(data_node.config) %}
  {%- do dataset.append({
      'dfs.namenode.rpc-address': '{}:{}'.format(
        salt.sdb.get('sdb://hadoop/name_node'), 8020
      )
    })
  %}
{%- endif %}

include: {{ include }}

hadoop_hdfs_config_serialized:
  file.serialize:
    - name: /etc/hadoop/hdfs-site.xml
    - dataset: {{ salt.slsutil.merge_all(dataset) | json }}
    - formatter: xml_hadoop
    - user: {{ hadoop.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
    - mode: 644
    - watch_in: {{ watch_in }}
