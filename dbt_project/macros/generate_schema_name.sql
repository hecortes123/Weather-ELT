{% macro generate_schema_name(custom_schema_name, node) -%}
    {# dbt usa el schema del profile por defecto, esto evita la concatenación #}
    {{ target.schema | trim }}
{%- endmacro %}