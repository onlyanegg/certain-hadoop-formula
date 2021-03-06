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
    {%- do checksums.append(''.join(line.split()[2:]).lower()) %}
  {%- endif %}
{%- endfor %}
{%- set checksum = checksums[0] %}

hadoop_group_present:
  group.present:
    - name: {{ hadoop.group.name }}
    - gid: {{ hadoop.group.gid }}

hadoop_user_present:
  user.present:
    - name: {{ hadoop.user.name }}
    - uid: {{ hadoop.user.uid }}
    - gid_from_name: True
    - createhome: False

hadoop_archive_extracted:
  archive.extracted:
    - name: /opt
    - source: {{ mirrors }}
    - source_hash: {{ checksum }}
    {#- source_hash: {{ '{0}/hadoop-{1}/hadoop-{1}.tar.gz.sha256'.format(hadoop.source.sum,hadoop.version) }}#}
    - user: root
    - group: {{ hadoop.group.name }}
  file.directory:
    - name: /opt/hadoop-{{ hadoop.version }}
    - dir_mode: 775

hadoop_archive_symlinked:
  file.symlink:
    - name: /opt/hadoop
    - target: /opt/hadoop-{{ hadoop.version }}
    - onchanges:
      - archive: hadoop_archive_extracted

hadoop_log4j_properties_installed:
  file.managed:
    - name: /etc/hadoop/log4j.properties
    - source: salt://hadoop/files/log4j.properties
    - template: jinja

hadoop_logs_dir_installed:
  file.directory:
    - name: {{ hadoop.log_dir | default('/opt/hadoop/logs') }}
    - user: root
    - group: {{ hadoop.group.name }}
    - mode: 775
