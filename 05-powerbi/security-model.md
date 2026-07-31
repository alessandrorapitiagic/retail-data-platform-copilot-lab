# Security Model

Tabella autorizzazioni: `gold.security_user_store(security_user_store_id, user_email, role_code, store_code, region)`
(vedi `04-data-platform/sql/init/02_tables.sql` e seed in `04-data-platform/sql/init/03_seed_security.sql`),
importata nel modello semantico come tabella tecnica nascosta `SecurityUserStore`.

| Ruolo Power BI (RLS) | role_code | Filtro | Accesso |
|---|---|---|---|
| Executive | EXECUTIVE | nessuno | tutte le region/store |
| Area Manager | AREA_MANAGER | `Dim Store[region] = LOOKUPVALUE(region utente)` | store della regione assegnata |
| Store Manager | STORE_MANAGER | `Dim Store[store_code] = LOOKUPVALUE(store_code utente)` | singolo store |

## Come testare i ruoli in Power BI Desktop

1. Aprire il modello, andare su **Modeling > Manage Roles**: sono presenti i tre ruoli sopra.
2. Usare **View As** e selezionare un ruolo, inserendo come "other user" uno degli indirizzi seed
   (es. `store.manager.milano@retailone-demo.local`, `area.manager.lombardia@retailone-demo.local`,
   `ceo@retailone-demo.local`) per verificare il filtro su `Dim Store`.
3. In produzione l'attribuzione utente -> ruolo avviene lato Power BI Service (membership del ruolo);
   `USERPRINCIPALNAME()` in Desktop viene simulato tramite "View As > Other user".

## Note di governance

- La tabella `SecurityUserStore` è marcata `isHidden` nel modello: non deve mai comparire nei report.
- Nessun indirizzo e-mail reale di clienti viene esposto nel modello (vedi `Dim Customer`, priva della colonna `email`)
  per minimizzazione dei dati personali, in linea con il consenso marketing tracciato in `consent_marketing`.
