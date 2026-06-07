# Duitse Taalvaardigheid onder Nederlanders

Jesse Postma (507655), Vani Rembet (450024), Dennis Kuiper (507944)

Kwantitatief surveyonderzoek naar de beheersing van het Duits onder Nederlandse volwassenen (n = 154), uitgevoerd als onderdeel van de wetenschappelijke cyclus aan de Hanze Hogeschool Groningen (2026).

---

## Mappenstructuur

```
wetenschappelijke_cyclus_onderzoek/
├── ruwe_data/          Originele exportbestanden vanuit Microsoft Forms
├── publicatie/         Eindpaper (.Rmd + .pdf) en bibtex entries
├── analyse/            Individuele analysebestanden en logboeken
├── protocol/           Onderzoeksprotocol (.Rmd, .html)
└── docs/               Hulpmiddelen en bibtex entries
```

---

## Bestanden per map

### `ruwe_data/`
Onbewerkte data-export vanuit Microsoft Forms, niet aan te passen.

| Bestand | Beschrijving |
|---|---|
| `Duitse taalvaardigheid onderzoek(1-154).csv.xlsx` | Ruwe export (154 rows, 66 cols) |
| `Duitse taalvaardigheid onderzoek(1-154).csv` | Ruwe export (csv) (154 rows, 66 cols) |
| `cleaned_scores.csv` | Export uit R met kortere kolomnamen, 1/0 voor antwoorden, IRT scores (154 rows, 66 cols) |

---

### `publicatie/`
Bevat het eindproduct van het onderzoek.

| Bestand | Beschrijving |
|---|---|
| `paper - duitse taalvaardigheid.Rmd` | Bronbestand van de paper (te knitten naar PDF) |
| `paper---duitse-taalvaardigheid.pdf` | Gerenderde eindpaper |
| `paper_refs.bib` | Bibliografie behorend bij de paper |
| `include_tex_header.tex` | LaTeX-header voor opmaak van de PDF-output |

---

### `analyse/`
Individuele werkbestanden per onderzoeker of globaal. Niet alle bestanden hieruit zijn opgenomen in de eindpaper.

| Bestand | Beschrijving |
|---|---|
| `analyse_jesse.Rmd` | Hoofdanalyse Jesse (Beschrijvende statistiek, hypothese toetsing, IRT-scoring, CEFR-mapping, regressie) |
| `analyse_Dennis.Rmd` | Analyse Dennis |
| `analyse_vani.Rmd` | Analyse Vani (Hoofdvraag en deelvraag beantwoording, supplementaire analyse) |
| `analyse_voor_vani.Rmd` | Voorbereidend script ten behoeve van Vanis analyse door JP|
| `individual_scoring_jesse.Rmd` | Individuele IRT-scoring per respondent |
| `verband_tussen_2_resultaten.Rmd` | Verband tussen twee uitkomstvariabelen (IRT vs. Logistische regressie) door VR |
| `logistic_regression_test_Vani.Rmd` | Logistische regressietest door VR |
| `methodes_testen.Rmd` DK | Verkenning van statistische methodes (gelimiteerde resultaten) |
| `Logboek_Jesse.Rmd` | Proceslogboek Jesse |
| `logboek_Dennis.Rmd` | Proceslogboek Dennis |
| `logboek_Vani.Rmd` | Proceslogboek Vani |
| `references_jesse.bib` | Referenties gebruikt in Jesse's analyse/logboek |
| `images/` | Gegenereerde figuren (IRT-plot, CEFR-verdeling, samenvatting) |

---

### `protocol/`
Onderzoeksprotocol zoals opgesteld voor aanvang van de dataverzameling.

| Bestand | Beschrijving |
|---|---|
| `protocol.Rmd` | Bronbestand van het protocol |
| `protocol.html` | Gerenderde HTML-versie |
| `protocol_refs.bib` | Bibliografie behorend bij het protocol |

---

### `docs/`
Ondersteunende documenten en hulpmiddelen.

| Bestand | Beschrijving |
|---|---|
| `hulpmiddelen.Rmd` | Overzicht van gebruikte R-functies en packages |
| `hulpmiddelen.html` | Gerenderde versie |
| `references_hulp.bib` | Bijbehorende referenties |

---

## Reproduceerbaarheid

De eindpaper is te reproduceren door `protocol/protocol.Rmd` te volgen in combinatie met code te vinden in de publicatie (`publicatie/paper - duitse taalvaardigheid.Rmd`). Daarnaast zijn FAIR-principes gevolgd voor gemakkelijke hantering van protocollen. 

Benodigde R-packages staan vermeld in de YAML-header van het Rmd-bestand en ook beschreven in de methodologie. Aanbevolen R-versie: ≥ 4.3.

---

## Dataherkomst

Data verzameld via Microsoft Forms (mei 2026). Ruwe export staat in `ruwe_data/`. De opgeschoonde versie (`cleaned_scores.csv`) is afgeleid via IRT-scoring in `analyse/individual_scoring_jesse.Rmd` en staat in `publicatie/` als invoer voor de paper.
