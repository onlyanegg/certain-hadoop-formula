{%- import_yaml 'hadoop/defaults.yaml' as hadoop_defaults -%}
{%- set hadoop_pillar = salt.pillar.get('hadoop', {}) %}
{%- set hadoop_grains = salt.grains.get('hadoop', {}) %}

{%- set hadoop = hadoop_defaults.hadoop %}
{%- do salt.slsutil.update(hadoop, hadoop_pillar) %}
{%- do salt.slsutil.update(hadoop, hadoop_grains) %}
