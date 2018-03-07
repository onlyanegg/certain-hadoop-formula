include:
  - .download
{%- if grains.id == salt['sdb.get']('sdb://hadoop/name_node') %}
  - .name_node
{%- elif grains.id == salt['sdb.get']('sdb://hadoop/resource_manager') %}
  - .resource_manager
{%- else %}
  - .node_manager
  - .data_node
