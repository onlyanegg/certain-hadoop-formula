{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set mirrors = [] %}
{%- for mirror in hadoop.source.mirrors %}
  {% do mirrors.append('{0}/hadoop-{1}/hadoop-{1}.tar.gz'.format(mirror, hadoop.version)) %} 
{%- endfor %}

hadoop_bin_downloaded:
  file.managed:
    - name: /opt/hadoop-{{ hadoop.version }}
    - source: {{ mirrors }}
    - source_hash: {{ '{0}/hadoop-{1}/hadoop-{1}.tar.gz.mds'.format(hadoop.source.sum, hadoop.version) }}
