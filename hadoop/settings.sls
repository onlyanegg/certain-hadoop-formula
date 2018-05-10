{%- set hadoop_defaults = {} %}
{%- for defaults in ['hadoop', 'log4j'] %}
  {%- import_yaml 'hadoop/defaults/{}.yaml'.format(defaults) as defaults %}
  {%- do salt.slsutil.update(hadoop_defaults, defaults) %}
{%- endfor %}

{%- set hadoop_pillar = salt.pillar.get('hadoop', {}) %}
{%- set hadoop_grains = salt.grains.get('hadoop', {}) %}

{%- set hadoop = hadoop_defaults.hadoop %}
{%- do salt.slsutil.update(hadoop, hadoop_pillar) %}
{%- do salt.slsutil.update(hadoop, hadoop_grains) %}
