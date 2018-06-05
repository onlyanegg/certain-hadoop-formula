{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set resource_manager = hadoop.yarn.resource_manager %}
{%- set node_manager = hadoop.yarn.node_manager %}

include:
  - .configure

{%- if salt['match.{}'.format(node_manager.target_type)](node_manager.target) %}
  - .resource_manager
{%- endif %}

{%- if salt['match.{}'.format(node_manager.target_type)](node_manager.target) %}
  - .node_manager
{%- endif %}
