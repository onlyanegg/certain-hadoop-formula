{% from 'hadoop/settings.sls' import hadoop with context -%}

include:
  - .service

# hadoop.node_manager: {{ hadoop.node_manager }}

{{ hadoop.node_manager.service.name }}_service_file_installed:
  file.managed:
    - name: /etc/systemd/system/{{ hadoop.node_manager.service.name }}.service
    - source: salt://hadoop/files/{{ hadoop.node_manager.service.name }}.service
    - template: jinja
    - context:
        user: {{ hadoop.yarn.user.name }}
        group: {{ hadoop.group.name }}
    - watch_in:
      - service: {{ hadoop.node_manager.service.name }}

{{ hadoop.node_manager.service.name }}_environment_file_installed:
  file.managed:
    - name: /etc/sysconfig/{{ hadoop.node_manager.service.name }}
    - source: salt://hadoop/files/environment
    - template: jinja
    - context:
        environment: {{ 
          salt.slsutil.merge(
            hadoop.environment, salt.slsutil.merge(
              hadoop.yarn.environment,
              hadoop.node_manager.environment
            )
          )
        }}
    - watch_in:
      - service: {{ hadoop.node_manager.service.name }}

{#-
#
# I think I'd like for this to eventually be handled by a serializer
#
#{{ hadoop.node_manager.service.name }}_environment_file_installed:
#  file.serialize:
#    - name: /etc/sysconfig/{{ hadoop.node_manager.service.name }}
#    - dataset: {{ hadoop.node_manager.environment }}
#    - formatter: configparser
#    - context:
#        environment: {{ hadoop.node_manager.environment }}
#    - watch_in:
#      - service: {{ hadoop.node_manager.service.name }}
#}

{#-
{%- set name_dir = [] %}
{%- for property in hadoop.node_manager.yarn.config.configuration %}
  {%- if property.property.name == 'dfs.namenode.name.dir' %}
    {%- do name_dir.append(property.property.value.replace('file://', '')) %}
  {%- endif %}
{%- endfor %}
{{ hadoop.node_manager.service.name }}_name_dir_installed:
  file.directory:
    - name: {{ name_dir[0] }}
    - user: {{ hadoop.yarn.user.name }}
    - group: {{ hadoop.group.name }}
    - makedirs: True
#}
