# KPI Catalog

| KPI | Formula | Granularità | Fonte | Note |
|---|---|---|---|---|
| Net Sales | somma net_amount | riga vendita | ERP | resi negativi |
| Gross Margin | Net Sales - Standard Cost | riga vendita | ERP | costo alla vendita |
| Gross Margin % | Gross Margin / Net Sales | aggregata | Gold | blank se vendite 0 |
| Units | somma quantity | riga vendita | ERP | resi negativi |
| Average Ticket | Net Sales / documenti distinti | giorno/store | ERP | esclusi documenti annullati |
| Active Customers | clienti distinti con acquisto | periodo | CRM+ERP | cliente non nullo |
| New Customers | prima vendita nel periodo | mese | CRM+ERP | sulla prima data acquisto |
| Stock Qty | somma on_hand_qty | giorno/prodotto/location | ERP | snapshot |
| Days of Cover | Stock Qty / media unità 30gg | giorno | Gold | cap a 999 |
| Budget Variance | Net Sales - Budget | mese/store/categoria | Gold+CSV | scenario selezionato |
