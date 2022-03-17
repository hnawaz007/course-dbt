{% test field_length(model, column_name, length_of_field) %}


   select *
   from {{ model }}
   where length({{ column_name }}) <> {{length_of_field}}


{% endtest %}