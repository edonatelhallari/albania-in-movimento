# Albania in movimento
### Dove e perché emigrano gli albanesi (1990–2025)

Capstone project del Master in **Data Analytics & AI** (Epicode) · Edona Telhallari

Il progetto racconta l'emigrazione albanese con i dati: dove vivono oggi gli albanesi all'estero, perché partono e come è cambiato il fenomeno negli ultimi trent'anni.

## Dashboard e presentazione

- **Dashboard Looker Studio:** [apri il report](https://lookerstudio.google.com/reporting/719b52bb-497a-4a18-a445-228820905c84)
- **Presentazione:** [PDF](presentazione/Albania_in_movimento.pdf) · [PowerPoint](presentazione/Albania_in_movimento.pptx)

## Domande di ricerca

1. **Dove vanno?** I principali paesi di destinazione.
2. **Perché partono?** Famiglia, lavoro e studio (primi permessi di soggiorno nell'UE).
3. **Italia, Grecia, Germania:** le tre destinazioni principali a confronto.
4. **Focus Italia:** regioni e genere.
5. **Contesto economico:** PIL pro capite, disoccupazione giovanile, rimesse.
6. **Il paradosso italiano:** perché i residenti albanesi calano mentre crescono le cittadinanze italiane.

## Fonti dei dati

| Fonte | Contenuto |
|---|---|
| Eurostat – migr_pop1ctz | Cittadini albanesi residenti nei paesi europei, 1998–2025 |
| UN DESA – Migrant Stock 2024 | Albanesi nel mondo per paese e genere, 1990–2024 |
| Eurostat – migr_resfirst / migr_resvalid | Permessi di soggiorno per motivo |
| Eurostat – migr_acq | Acquisizioni di cittadinanza |
| Istat | Albanesi in Italia per regione e genere, 2025 |
| Banca Mondiale | PIL pro capite (PPP), disoccupazione 15–24, rimesse |

## Struttura del repository

```
notebooks/      01–07 pulizia dei dati con Python (Pandas)
sql/            08_database.sql – database MySQL e query (JOIN, RANK, LAG)
data/           dataset puliti (CSV)
powerbi/        09_report_albania.pbix – modello a stella e misure DAX
looker/         dati usati per la dashboard Looker Studio
presentazione/  slide finali (PDF e PowerPoint)
```

## Strumenti

Python (Pandas) · MySQL · Power BI (DAX) · Looker Studio · Excel / Google Sheets

## Risultati principali

- **Una diaspora grande:** circa 1,2 milioni di albanesi all'estero, quasi 1 ogni 2 residenti in Albania. Oltre l'80% vive in Italia e Grecia.
- **Un'emigrazione familiare:** il 51,6% dei primi permessi nell'UE (2024) è per ricongiungimento familiare.
- **La Germania cresce:** da 10.663 residenti albanesi nel 2010 a 118.697 nel 2025 (×11).
- **Il divario economico:** il PIL pro capite albanese è circa il 40% di quello italiano.
- **Il paradosso italiano:** dal picco del 2014 i residenti albanesi in Italia calano, ma oltre 320 mila albanesi sono diventati cittadini italiani. Il calo nasce dall'integrazione, non dalle partenze.

## Limiti

- UN DESA non fornisce l'origine albanese per Germania, USA, Regno Unito e Svizzera.
- Per la Grecia Eurostat ha solo il 1998 e il 2001, quindi è esclusa dal trend europeo.
- Chi acquisisce la cittadinanza del paese di residenza non viene più contato come albanese.
