include:

{%- if pillar.bootstrap | default('False') | lower() == 'true' %}
  - .store_resource_manager_endpoint
{%- endif %}

  - .install
  - .service
