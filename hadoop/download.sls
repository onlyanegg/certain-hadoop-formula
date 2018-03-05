{% from 'hadoop/settings.sls' import hadoop with context -%}

{%- set mirrors = [] %}
{%- for mirror in hadoop.source.mirrors %}
  {% do mirrors.append(
      '{0}/hadoop-{1}/hadoop-{1}.tar.gz'.format(mirror, hadoop.version)
    )
  %}
{%- endfor %}

{%- set checksums = [] %}
{%- set ret = salt['http.query'](
    '{0}/hadoop-{1}/hadoop-{1}.tar.gz.mds'.format(
      hadoop.source.sum,
      hadoop.version
    )
  )
%}
{%- for line in ret.body.split('\n') %}
  {%- if 'SHA1' in line %}
    {%- do checksums.append(''.join(line.split()[3:]).lower()) %}
  {%- endif %}
{%- endfor %}
{%- set checksum = checksums[0] %}

hadoop_bin_downloaded:
  file.managed:
    - name: /opt/hadoop-{{ hadoop.version }}
    - source: {{ mirrors }}
    - source_hash: {{ checksum }}
