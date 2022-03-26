{% macro get_payment_methods() %}
{{ return(["page_view", "add_to_cart", "checkout"] ) }}
{% endmacro %}