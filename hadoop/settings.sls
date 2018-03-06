{%- import_yaml 'hadoop/defaults.yaml' as hadoop_defaults -%}
{%- set hadoop_pillar = salt.pillar.get('hadoop', {}) %}
{%- set hadoop_grains = salt.grains.get('hadoop', {}) %}

{%- set hadoop = hadoop_defaults.hadoop %}
{%- do salt.slsutil.update(hadoop, hadoop_pillar) %}
{%- do salt.slsutil.update(hadoop, hadoop_grains) %}

{# Dynamic configuration like node_manager hostname must be added here. Pillar
#  cannot reference pillar.
#}
{%- set dynamic_config = {
    'name_node': {
      'host': salt.sdb.get('sdb://hadoop/name_node'),
      'port': 3000
    }
  }
%}

{%- set hadoop_dynamic = {
    'hadoop': {
      'config': {
        'fs': {
          'deafultFS': 'hdfs://{host}:{port}'.format(**dynamic_config.name_node)
        }
      }
      'yarn': {
        'config': {
          'yarn': {
            'resourcemanager': {
              'address': '',
              'scheduler': {
                'address': ''
              },
              'resource-tracker': {
                'address': ''
              }
              'hostname': {}
            }
          }
        }
      }
    }
  }
%}

{%- do salt.slsutil.update(hadoop, hadoop_dynamic) %}
