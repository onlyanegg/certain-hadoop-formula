{#{%- if grains.id == salt['sdb.get']('sdb://hadoop/resource_manager') %}#}
{%- if salt['mine.get'](hadoop.target_function, tgt=grains.id)[grains.id] == salt['sdb.get']('sdb://hadoop/resource_manager') %}
  {%- set role = 'resource_manager' %}
{%- else %}
  {%- set role = 'node_manager' %}
{%- endif -%}

include:
  - .install
  - .configure
  - .{{ role }}
