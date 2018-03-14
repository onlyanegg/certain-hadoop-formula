{%- if grains.id == salt['sdb.get']('sdb://hadoop/name_node') %}
  {%- set role = 'name_node' %}
{%- else %}
  {%- set role = 'data_node' %}
{%- endif -%}

include:
  - .install
  - .configure
  - .{{ role }}
