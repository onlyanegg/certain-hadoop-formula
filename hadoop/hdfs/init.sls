{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set name_node = hadoop.hdfs.name_node %}
{%- set data_node = hadoop.hdfs.data_node %}

include:
  - .configure

{%- if salt['match.{}'.format(name_node.target_type)](name_node.target) %}
  - .name_node
{%- endif %}

{%- if salt['match.{}'.format(data_node.target_type)](data_node.target) %}
  - .data_node
{%- endif %}
