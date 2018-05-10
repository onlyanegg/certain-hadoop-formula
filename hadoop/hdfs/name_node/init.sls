include:

{%- if pillar.bootstrap | default('False') | lower() == 'true' %}
  - .store_name_node_endpoint
{%- endif %}

  - .install
  - .service
