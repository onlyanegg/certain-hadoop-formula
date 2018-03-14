{% from 'hadoop/settings.sls' import hadoop with context -%}

{{ hadoop.data_node.service.name }}_service:
  service.running:
    - name: {{ hadoop.data_node.service.name }}
    - enable: True
