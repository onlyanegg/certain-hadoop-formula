{% from 'hadoop/settings.sls' import hadoop with context -%}

# WARNING: This state should not be run outside the context of bootstrapping

include:
  - .service

hadoop_store_resource_manager_endpoint:
  module.run:
    - name: sdb.set
    - uri: 'sdb://hadoop/resource_manager'
    - value: '{{ salt['grains.get'](hadoop.yarn.resource_manager.endpoint_grain) }}'#}
    - require:
      - service: {{ hadoop.yarn.resource_manager.service.name }}
