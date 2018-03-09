{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.name_node: {{ hadoop.name_node }}

{{ hadoop.name_node.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.name_node.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.name_node.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.hdfs.user.name }}
        group: {{ hadoop.group.name }}
    - require_in:
      - service: {{ hadoop.name_node.service.name }}

{{ hadoop.name_node.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.name_node.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ hadoop.name_node.environment }}
    - require_in:
      - service: {{ hadoop.name_node.service.name }}

{#
#
# I think I'd like for this to eventually be handled by a serializer
#
#{{ hadoop.name_node.service.name }}_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/{{ hadoop.name_node.service.name }}
#    - dataset: {{ hadoop.name_node.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.name_node.environment }}
#    - require_in:
#      - service: {{ hadoop.name_node.service.name }}
#}
