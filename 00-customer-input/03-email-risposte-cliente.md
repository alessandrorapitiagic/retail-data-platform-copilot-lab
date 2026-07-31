# E-mail 3 - Risposte del cliente

- **ERP RetailCore:** ordini, righe vendita, resi, prodotti, negozi e stock. È source of truth per vendite e magazzino.
- **CRM ClientHub:** clienti, segmentazione e consensi. È source of truth per anagrafica cliente.
- **E-commerce ShopNow:** ordini online; dopo fatturazione l'ERP resta la fonte ufficiale.
- **Budget:** file CSV mensile del Controlling per negozio, categoria e mese.
- **Storico:** cinque anni completi più anno corrente.
- **Granularità:** riga documento; stock giornaliero per prodotto e location.
- **Fatturato netto:** quantità * prezzo unitario - sconto, al netto dei resi.
- **Margine:** fatturato netto - costo standard valorizzato alla data di vendita.
- **KPI release 1:** fatturato netto, margine e margine %, quantità, ticket medio, clienti attivi, nuovi clienti, stock, giorni di copertura e scostamento budget.
- **Sicurezza:** Direzione vede tutto; area manager solo la propria regione; store manager solo il proprio negozio.
- **Qualità:** vendite senza prodotto o negozio non pubblicabili; differenza giornaliera ERP/Gold sotto 0,1%; clienti duplicati vanno consolidati tramite e-mail normalizzata o partita IVA.
- **SLA:** caricamento completato entro le 06:30; dashboard disponibile alle 07:00; log conservati 13 mesi.
