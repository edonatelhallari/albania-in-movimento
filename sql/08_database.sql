-- =====================================================
-- 08 – Database SQL: Albania in movimento
-- =====================================================

-- 1. Creazione del database
CREATE DATABASE IF NOT EXISTS albania_migrazione;
USE albania_migrazione;

-- 2. Importazione dei 7 file puliti (cartella dataclean)
--    fatta con "Table Data Import Wizard" di MySQL Workbench:
--    stock_albanesi_1990_2024, residenti_albanesi_europa,
--    permessi_primi_albanesi, permessi_validi_albanesi,
--    cittadinanze_albanesi, albanesi_italia_regioni, indicatori_economici
--    Nota: 14 righe di permessi_validi senza valore non sono state importate.

-- Controllo: numero di righe per ogni tabella
SELECT 'stock' AS tabella, COUNT(*) AS righe FROM stock_albanesi_1990_2024
UNION ALL SELECT 'residenti', COUNT(*) FROM residenti_albanesi_europa
UNION ALL SELECT 'permessi_primi', COUNT(*) FROM permessi_primi_albanesi
UNION ALL SELECT 'permessi_validi', COUNT(*) FROM permessi_validi_albanesi
UNION ALL SELECT 'cittadinanze', COUNT(*) FROM cittadinanze_albanesi
UNION ALL SELECT 'italia_regioni', COUNT(*) FROM albanesi_italia_regioni
UNION ALL SELECT 'indicatori', COUNT(*) FROM indicatori_economici;

-- 3. Tabelle di dimensione (modello a stella)
CREATE TABLE IF NOT EXISTS dim_paese AS
SELECT paese FROM stock_albanesi_1990_2024
UNION SELECT paese FROM residenti_albanesi_europa
UNION SELECT paese FROM permessi_primi_albanesi
UNION SELECT paese FROM permessi_validi_albanesi
UNION SELECT paese FROM cittadinanze_albanesi
UNION SELECT paese FROM indicatori_economici;

CREATE TABLE IF NOT EXISTS dim_motivo AS
SELECT motivo FROM permessi_primi_albanesi
UNION SELECT motivo FROM permessi_validi_albanesi;

SELECT COUNT(*) AS numero_paesi FROM dim_paese;   -- 54
SELECT * FROM dim_motivo;                         -- 7 motivi

-- =====================================================
-- 4. Query di analisi
-- =====================================================

-- Classifica: i 5 paesi con più albanesi residenti, nel 2010 e nel 2025
SELECT *
FROM (
    SELECT anno, paese, residenti,
           RANK() OVER (PARTITION BY anno ORDER BY residenti DESC) AS posizione
    FROM residenti_albanesi_europa
    WHERE anno IN (2010, 2025)
) AS classifica
WHERE posizione <= 5
ORDER BY anno, posizione;


-- Italia e Germania: residenti albanesi e variazione % anno su anno
SELECT paese, anno, residenti,
       LAG(residenti) OVER (PARTITION BY paese ORDER BY anno) AS anno_precedente,
       ROUND(100 * (residenti - LAG(residenti) OVER (PARTITION BY paese ORDER BY anno))
             / LAG(residenti) OVER (PARTITION BY paese ORDER BY anno), 1) AS variazione_perc
FROM residenti_albanesi_europa
WHERE paese IN ('Italy', 'Germany')
  AND anno >= 2010
ORDER BY paese, anno;

-- Quota % di ogni motivo sui primi permessi, ultimo anno disponibile
SELECT paese, anno, motivo, permessi,
       ROUND(100 * permessi / SUM(permessi) OVER (PARTITION BY paese), 1) AS quota_perc
FROM permessi_primi_albanesi
WHERE motivo <> 'Totale'
  AND paese IN ('Italy', 'Greece', 'Germany')
  AND anno = (SELECT MAX(anno) FROM permessi_primi_albanesi)
ORDER BY paese, quota_perc DESC;

-- Paradosso italiano: residenti albanesi in Italia e cittadinanze italiane acquisite
SELECT r.anno,
       r.residenti,
       c.cittadinanze,
       SUM(c.cittadinanze) OVER (ORDER BY r.anno) AS cittadinanze_cumulate
FROM residenti_albanesi_europa AS r
JOIN cittadinanze_albanesi AS c
  ON r.paese = c.paese AND r.anno = c.anno
WHERE r.paese = 'Italy'
ORDER BY r.anno;

-- Albanesi in Italia per regione: 2015 vs 2025, variazione e % donne
SELECT r25.regione,
       r15.totale AS anno_2015,
       r25.totale AS anno_2025,
       ROUND(100 * (r25.totale - r15.totale) / r15.totale, 1) AS variazione_perc,
       r25.perc_femmine
FROM albanesi_italia_regioni AS r25
JOIN albanesi_italia_regioni AS r15
  ON r25.regione = r15.regione AND r15.anno = 2015
WHERE r25.anno = 2025
ORDER BY r25.totale DESC;

-- Indicatori economici 2024: Albania vs paesi di destinazione
SELECT indicatore,
       ROUND(MAX(CASE WHEN paese = 'Albania' THEN valore END), 1) AS Albania,
       ROUND(MAX(CASE WHEN paese = 'Italy'   THEN valore END), 1) AS Italia,
       ROUND(MAX(CASE WHEN paese = 'Greece'  THEN valore END), 1) AS Grecia,
       ROUND(MAX(CASE WHEN paese = 'Germany' THEN valore END), 1) AS Germania
FROM indicatori_economici
WHERE anno = 2024
GROUP BY indicatore;