{% set payment_methods = ["bank_transfer", "credit_card", "coupon", "gift_card"] -%}
with
    payments as (select * from {{ ref("stg_payments") }}),

    pivoted as (
        select
            order_id,
            sum(amount) as total_amount,
            {%- for payment_method in payment_methods %}
                sum(
                    case when payment_method = '{{ payment_method}}' then amount else 0 end
                ) as {{ payment_method }}_amount
                {%- if not loop.last -%}, {%- endif -%}
            {% endfor %}
        from payments
        group by 1
    )

select *
from pivoted
