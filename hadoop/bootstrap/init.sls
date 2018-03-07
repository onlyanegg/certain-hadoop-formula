{% from 'hadoop/settings.sls' import hadoop with context -%}

{% set hadoop_nodes = salt['saltutil.runner'](
    'manage.up', tgt=hadoop.target, expr_form=hadoop.target_type
  )
-%}

{# This should return the same node every time, even after adding or removing
#  boxes.
#}
{% set name_node = hadoop_nodes[0] -%}
{% set resource_manager = hadoop_nodes[0] -%}

{% set ret = [] -%}
{% do ret.append(salt['sdb.set']('sdb://hadoop/name_node', name_node)) -%}
{% do ret.append(salt['sdb.set']('sdb://hadoop/resource_manager', resource_manager)) -%}

# {{ ret }}

{% if 'false' in ret -%}
hadoop_bootstrap_failed:
  test.fail_without_changes:
    - name: 'Failed to configure the Hadoop NameNode and ResourceManager'
{% else -%}
hadoop_bootstrap_succeeded:
  test.succeed_without_changes:
    - name: 'Successfully configured the Hadoop NameNode and ResourceManager'
{%- endif %}
