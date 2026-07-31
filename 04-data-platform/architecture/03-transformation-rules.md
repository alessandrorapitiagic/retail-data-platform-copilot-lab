# Transformation Rules

- Normalizzare e-mail con `lower(trim(email))`.
- Golden customer: priorità VAT, poi e-mail normalizzata, altrimenti customer_id.
- Scartare dal Silver vendite con prodotto o store inesistente.
- `net_amount = quantity * unit_price - sign(quantity) * abs(discount_amount)`; i resi restano negativi.
- `cost_amount = quantity * standard_cost`.
- `margin_amount = net_amount - cost_amount`.
- Gold usa chiavi surrogate e una dimensione Data condivisa.
