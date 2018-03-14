{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.data_node: {{ hadoop.data_node }}

{{ hadoop.data_node.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.data_node.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.data_node.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.hdfs.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.data_node.service.name }}

{{ hadoop.data_node.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.data_node.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ hadoop.data_node.environment }}
    - watch_in:
      - service: {{ hadoop.data_node.service.name }}

{#-
#
# I think I'd like for this to eventually be handled by a serializer
#
#{{ hadoop.data_node.service.name }}_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/{{ hadoop.data_node.service.name }}
#    - dataset: {{ hadoop.data_node.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.data_node.environment }}
#    - watch_in:
#      - service: {{ hadoop.data_node.service.name }}
#}

{%- set name_dir = [] %}
{%- for property in hadoop.data_node.hdfs.config.configuration %}
  {%- if property.property.name == 'dfs.namenode.name.dir' %}
    {%- do name_dir.append(property.property.value.replace('file://', '')) %}
  {%- endif %}
{%- endfor %}
{{ hadoop.data_node.service.name }}_name_dir_installed:
  file.directory:
    - name: {{ name_dir[0] }}
    - user: {{ hadoop.hdfs.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
