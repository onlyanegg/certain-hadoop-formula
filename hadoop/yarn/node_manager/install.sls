{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.yarn.node_manager: {{ hadoop.yarn.node_manager }}

{{ hadoop.yarn.node_manager.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.yarn.node_manager.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.yarn.node_manager.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.yarn.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.yarn.node_manager.service.name }}

{{ hadoop.yarn.node_manager.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.yarn.node_manager.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ 
          salt.slsutil.merge(
            hadoop.environment, salt.slsutil.merge(
              hadoop.yarn.environment,
              hadoop.yarn.node_manager.environment
            )
          )
        }}
    - watch_in:
      - service: {{ hadoop.yarn.node_manager.service.name }}

{#-
#
# I think I'd like for this to eventually be handled by a serializer
#
#{{ hadoop.yarn.node_manager.service.name }}_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/{{ hadoop.yarn.node_manager.service.name }}
#    - dataset: {{ hadoop.yarn.node_manager.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.yarn.node_manager.environment }}
#    - watch_in:
#      - service: {{ hadoop.yarn.node_manager.service.name }}
#}
