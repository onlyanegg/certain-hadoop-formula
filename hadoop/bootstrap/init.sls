{% from 'hadoop/settings.sls' import hadoop with context -%}

{% set hadoop_nodes = salt['saltutil.runner'](
    'manage.up', tgt=hadoop.target, expr_form=hadoop.target_type
  )
-%}
# hadoop_nodes: {{ hadoop_nodes }}
{% set name_node = hadoop_nodes.pop(0) -%}

# {{ grains.id }}
# hadoop_nodes: {{ hadoop_nodes }}
# name_node: {{ name_node }}

configure_masters:
  salt.state:
    - sls: hadoop.bootstrap.configure_masters
    - tgt: 'mgmt101*'

bootstrap_name_node:
  salt.state:
    - sls: hadoop.bootstrap.bootstrap
    - tgt: {{ name_node }}

bootstrap_others:
  salt.state:
    - sls: hadoop
    - tgt: {{ hadoop_nodes }}
    - tgt_type: list
