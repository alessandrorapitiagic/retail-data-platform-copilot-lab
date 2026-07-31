# DAX Measures

> Le misure qui sotto sono documentate qui a scopo di revisione funzionale; la definizione ufficiale
> vive nel modello TMDL (`05-powerbi/RetailAnalytics.SemanticModel/definition/tables/*.tmdl`), unica
> fonte deployata in Power BI Desktop. Aggiornare sempre entrambi i posti in modo coerente.

```DAX
Net Sales := SUM ( 'Fact Sales'[net_amount] )
Gross Sales := SUM ( 'Fact Sales'[gross_amount] )
Gross Margin := SUM ( 'Fact Sales'[margin_amount] )
Gross Margin % := DIVIDE ( [Gross Margin], [Net Sales] )
Units := SUM ( 'Fact Sales'[quantity] )
Orders := DISTINCTCOUNT ( 'Fact Sales'[order_id] )
Average Ticket := DIVIDE ( [Net Sales], [Orders] )
Active Customers := DISTINCTCOUNT ( 'Fact Sales'[customer_key] )
Stock Qty := SUM ( 'Fact Inventory'[on_hand_qty] )
Available Qty := SUM ( 'Fact Inventory'[available_qty] )
Budget := SUM ( 'Fact Budget'[budget_amount] )
Budget Variance := [Net Sales] - [Budget]
Budget Variance % := DIVIDE ( [Budget Variance], [Budget] )
```

## Backlog DAX (da implementare in una prossima iterazione)

Le seguenti misure sono richieste dalla specifica report (`05-powerbi/report-specification.md`, sezione Inventory)
ma non sono ancora presenti nel modello: tracciarle in backlog (vedi US-05).

```DAX
Days Of Cover :=
VAR AvgDailySales = DIVIDE ( [Units], 30 )
RETURN DIVIDE ( [Available Qty], AvgDailySales )
```

