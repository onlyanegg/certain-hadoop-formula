{% from 'hadoop/settings.sls' import hadoop with context -%}

{{ hadoop.resource_manager.service.name }}_service:
  service.running:
    - name: {{ hadoop.resource_manager.service.name }}
    - enable: True
