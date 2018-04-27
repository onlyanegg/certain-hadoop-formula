{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set is_name_node = 
  salt['mine.get'](fun=hadoop.target_function, tgt=grains.id)[grains.id] ==
  salt['sdb.get']('sdb://hadoop/name_node')
%}

{%- if is_name_node %}
  {%- set role = 'name_node' %}
{%- else %}
  {%- set role = 'data_node' %}
{%- endif -%}

include:
  - .install
  - .configure
  - .{{ role }}
