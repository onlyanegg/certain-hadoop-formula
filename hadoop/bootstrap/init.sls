{% from 'hadoop/settings.sls' import hadoop with context -%}

{% set hadoop_nodes = salt['saltutil.runner'](
    'manage.up', tgt=hadoop.target, expr_form=hadoop.target_type
  )
-%}
{% set name_node = hadoop_nodes[0] -%}
{% set other_nodes = hadoop_nodes[1:] %}

install_dependencies:
  salt.state:
    - sls: hadoop.dependencies
    - tgt: {{ hadoop_nodes }}
    - tgt_type: list

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
    - tgt: {{ other_nodes }}
    - tgt_type: list
