{% from 'hadoop/settings.sls' import hadoop with context -%}

{{ hadoop.yarn.node_manager.service.name }}_service:
  service.running:
    - name: {{ hadoop.yarn.node_manager.service.name }}
    - enable: True
