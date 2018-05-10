{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

{{ hadoop.yarn.resource_manager.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.yarn.resource_manager.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.yarn.resource_manager.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.user.name }}
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
          salt.slsutil.merge_all([
            hadoop.environment,
            hadoop.yarn.environment,
            hadoop.yarn.resource_manager.environment
          ])
        }}
    - watch_in:
      - service: {{ hadoop.yarn.resource_manager.service.name }}
