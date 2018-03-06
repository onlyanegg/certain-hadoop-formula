{% from 'hadoop/settings.sls' import hadoop with context -%}

{% set hadoop_nodes = salt['saltutil.runner'](
    'manage.up', 'tgt'=hadoop.target, 'tgt_type'=hadoop.target_type
  )
-%}

{# This should return the same node every time, even after adding or removing
#  boxes.
#}
{% set name_node = sorted(hadoop_nodes)[0] %}
{% set resource_manager = sorted(hadoop_nodes)[0] %}

{% do salt['sdb.set']('sdb://hadoop/name_node', name_node) -%}
{% do salt['sdb.set']('sdb://hadoop/resource_manager', resource_manager) -%}
