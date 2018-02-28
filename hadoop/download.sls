{% from 'hadoop/settings.sls' import hadoop with context -%}

hadoop_bin_downloaded:
  file.managed:
    - name: /opt/hadoop-{{ version }}
    - source: {{ '{0}/hadoop-{1}/hadoop-{1}.tar.gz'.format(hadoop.source.mirrors, hadoop.version) }} 
    - source_hash: {{ '{0}/hadoop-{1}/hadoop-{1}.tar.gz.mds'.format(hadoop.source.sum, hadoop.version) }}
