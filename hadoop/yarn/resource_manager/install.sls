{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.yarn.resource_manager: {{ hadoop.yarn.resource_manager }}

{{ hadoop.yarn.resource_manager.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.yarn.resource_manager.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.yarn.resource_manager.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.yarn.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.yarn.resource_manager.service.name }}

{{ hadoop.yarn.resource_manager.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.yarn.resource_manager.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ 
          salt.slsutil.merge(
            hadoop.environment, salt.slsutil.merge(
              hadoop.yarn.environment,
              hadoop.yarn.resource_manager.environment
            )
          )
        }}
    - watch_in:
      - service: {{ hadoop.yarn.resource_manager.service.name }}

{#-
#
# I think I'd like for this to eventually be handled by a serializer
#
#{{ hadoop.yarn.resource_manager.service.name }}_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/{{ hadoop.yarn.resource_manager.service.name }}
#    - dataset: {{ hadoop.yarn.resource_manager.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.yarn.resource_manager.environment }}
#    - watch_in:
#      - service: {{ hadoop.yarn.resource_manager.service.name }}
#}
