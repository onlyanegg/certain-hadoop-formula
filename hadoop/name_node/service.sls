{% from 'hadoop/settings.sls' import hadoop with context -%}

{{ hadoop.name_node.service.name }}_service:
  service.running:
    - name: {{ hadoop.name_node.service.name }}
    - enable: True
