Projektas prognozuoja **kitos valandos bendrą dviračių nuomų skaičių** (`cnt(t+1)`) pagal UCI *Bike Sharing Dataset* valandinius duomenis. Jupyter Notebook failuose atliekamas duomenų paruošimas, paprasto atskaitos metodo (*Baseline*) ir trijų intelektualiųjų metodų (**CatBoost, MLP, SVR**) palyginimas, chronologinis *rolling-origin* vertinimas, abliacija, atsparumo eksperimentas, klaidų analizė ir rezultatų vizualizacija.

**Pagrindinis eksperimentas:** CatBoost `iterations=500`, `depth=7`, `learning_rate=0.05`, `random_seed=42`. Žemiau pateikti rezultatai priklauso šiai parametrų versijai.

## Python versija

Rekomenduojama **Python 3.11 (64 bitų, Windows)**. Kitų versijų suderinamumas nebuvo atskirai patikrintas.

```bash
python --version
```

## Duomenų atsisiuntimas

Naudojamas UCI *Bike Sharing Dataset* `hour.csv` failas su 2011–2012 m. valandiniais dviračių nuomos duomenimis.

- [Duomenų rinkinio puslapis](https://archive.ics.uci.edu/dataset/275/bike+sharing+dataset)
- [Tiesioginis ZIP archyvas](https://archive.ics.uci.edu/static/public/275/bike+sharing+dataset.zip)

Išarchyvuokite `hour.csv` į `Egzaminui/` katalogą, kuriame yra Notebook failai. Pagrindinis palyginimo Notebook taip pat gali rasti šį failą vienu katalogu aukščiau.

## Virtualios aplinkos sukūrimas ir aktyvavimas

Komandas vykdykite projekto `Egzaminui/` kataloge.

**Windows PowerShell:**

```powershell
py -3.11 -m venv .prognoze_eksperimentas_26
.\.prognoze_eksperimentas_26\Scripts\Activate.ps1
```

**Windows cmd:**

```bat
py -3.11 -m venv .prognoze_eksperimentas_26
.prognoze_eksperimentas_26\Scripts\activate.bat
```

**Windows Git Bash:**

```bash
py -3.11 -m venv .prognoze_eksperimentas_26
source .prognoze_eksperimentas_26/Scripts/activate
```

**Linux / macOS (su Python 3.11):**

```bash
python3.11 -m venv .prognoze_eksperimentas_26
source .prognoze_eksperimentas_26/bin/activate
```

## Priklausomybių įdiegimas

Aktyvavę virtualią aplinką, įdiekite projekto bibliotekas:

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Naudojamos bibliotekos: `pandas`, `numpy`, `matplotlib`, `scikit-learn`, `catboost` ir `jupyter`.

## Notebook paleidimas

```bash
jupyter notebook
```

Atsidariusiame Jupyter lange pasirinkite `05_Modeliu_palyginimas.ipynb` ir paleiskite visas ląsteles (**Run All**). Atskiruose `02_CatBoost.ipynb`, `03_MLP.ipynb` ir `04_SVR.ipynb` galima išsamiau peržiūrėti kiekvieną metodą. Jeigu Notebook failai pavadinti kitaip, atidarykite atitinkamą faktinį failą.

## Viena komanda pagrindiniam eksperimentui pakartoti

Iš `Egzaminui/` katalogo, aktyvavus virtualią aplinką ir įdiegus priklausomybes:

```bash
jupyter nbconvert --to notebook --execute --inplace 05_Modeliu_palyginimas.ipynb
```

Komanda nuosekliai įvykdo pagrindinio palyginimo Notebook ląsteles ir išsaugo rezultatus tame pačiame Notebook. Jai reikalingas `nbconvert` (jeigu nėra: `python -m pip install nbconvert`). Vykdymo trukmė priklauso nuo kompiuterio.

## Projekto struktūra

Pagrindiniai projekto failai:

```text
IS_egzaminas/
└── Egzaminui/
    ├── README.md
    ├── requirements.txt
    ├── hour.csv                       # atsisiunčiamas atskirai
    ├── 02_CatBoost.ipynb
    ├── 03_MLP.ipynb
    ├── 04_SVR.ipynb
    └── 05_Modeliu_palyginimas.ipynb
```

Jeigu repozitorijoje taip pat yra `setup_egzaminui.sh`, jis skirtas virtualiai aplinkai paruošti **Windows Git Bash** aplinkoje. Atskiras `02_CatBoost_EXECUTED.ipynb`, jeigu įkeltas, yra CatBoost Notebook su išsaugotais vykdymo rezultatais.

## Metodai, vertinimo protokolas ir metrikos

**Tikslas:** prognozuoti bendrą kitos valandos nuomų skaičių `cnt(t+1)`.

**Metodai:** Baseline (istorinis atskaitos metodas), CatBoost (gradientinis stiprinimas), MLP (daugiasluoksnis perceptronas) ir SVR (atraminių vektorių regresija su RBF branduoliu).

**Požymiai:** kalendoriniai duomenys, prognozės sudarymo metu prieinami orų duomenys ir ankstesnės paklausos `lag` bei `rolling` požymiai. Istorinės valandos susiejamos pagal tikslų laiką, o ne vien pagal eilučių pozicijas. `casual` ir `registered` nenaudojami kaip įvestys, nes jų suma lygi tiksliniam `cnt`.

**Chronologinis skaidymas:**

- **DEV:** 2011-01-08–2012-12-01; modelių palyginimui naudojami **3 expanding rolling-origin** patikrinimai.
- **TEST:** 2012-12-02–2012-12-31 (paskutinės 30 dienų); skirtas galutiniam įvertinimui, ne hiperparametrams parinkti.
- Visi modeliai vertinami pagal tuos pačius laiko intervalus. Atsitiktinė sėkla pagrindiniame eksperimente: `SEED = 42`.

**Metrikos:** MAE, RMSE ir *Peak underestimation rate* – faktinių paklausos pikų dalis, kai prognozė mažesnė už tikrąją reikšmę. Piko riba nustatoma pagal mokymo duomenų 90-ąjį procentilį. Visų šių metrikų mažesnė reikšmė yra pageidautina.

### Tyrimo eiga

```mermaid
flowchart TD
    A[UCI hour.csv] --> B[Duomenų paruošimas ir požymiai]
    B --> C[Chronologinis DEV ir TEST skaidymas]
    C --> D[3 rolling-origin patikrinimai DEV]
    D --> E[Baseline / CatBoost / MLP / SVR]
    E --> F[MAE / RMSE / pikų neįvertinimas]
    F --> G[Modelio pasirinkimas pagal DEV]
    G --> H[Galutinis 30 dienų TEST]
    H --> I[Abliacija / atsparumas / klaidų analizė]
```

### CatBoost matematinis pagrindas

Gradientinio stiprinimo prognozė:

$$
F_M(x)=F_0(x)+\sum_{m=1}^{M}\eta h_m(x)
$$

Čia `M = iterations = 500` – medžių skaičius, `η = learning_rate = 0.05` – mokymosi žingsnis, o `depth = 7` – medžio gylis. Programoje `fit()` apmoko modelį, `predict()` apskaičiuoja prognozes.

## Rezultatai

Toliau pateikti pagrindinio eksperimento rezultatai su CatBoost `iterations=500`, `depth=7` ir `learning_rate=0.05`.

### DEV – trijų rolling-origin patikrinimų vidurkiai

| Metodas | MAE ↓ | RMSE ↓ | Pikų neįvertinimas ↓ |
|---|---:|---:|---:|
| Baseline | 54,299 | 87,825 | 0,661 |
| **CatBoost** | **24,341** | **36,543** | **0,581** |
| MLP | 38,865 | 57,314 | 0,681 |
| SVR | 33,565 | 50,454 | 0,726 |

### TEST – paskutinės 30 dienų

| Metodas | MAE ↓ | RMSE ↓ | Pikų neįvertinimas ↓ |
|---|---:|---:|---:|
| Baseline | 51,302 | 81,164 | 0,780 |
| **CatBoost** | **20,523** | **31,373** | 0,700 |
| MLP | 29,387 | 44,141 | **0,660** |
| SVR | 25,393 | 40,071 | 0,740 |

**Rezultatų interpretacija:** šiame eksperimente CatBoost pasiekė mažiausias DEV ir TEST MAE bei RMSE reikšmes. Tačiau TEST laikotarpiu MLP turėjo mažesnę pikų neįvertinimo dalį (0,660, palyginti su CatBoost 0,700). Išsamios prognozių kreivės, palyginimo grafikai ir didžiausių klaidų pavyzdžiai pateikiami `05_Modeliu_palyginimas.ipynb`.

## Abliacija ir atsparumo eksperimentas

**Abliacija:** iš CatBoost įvesties pašalinami istorinės paklausos (`lag`, `rolling`) požymiai ir vertinama, kaip tai paveikia prognozes DEV rolling-origin patikrinimuose.

| CatBoost požymiai | DEV MAE ↓ | DEV RMSE ↓ | Pikų neįvertinimas ↓ |
|---|---:|---:|---:|
| Visi požymiai | 24,341 | 36,543 | 0,581 |
| Be istorinės paklausos | 38,843 | 59,725 | 0,578 |

Pašalinus istorinės paklausos požymius, MAE ir RMSE padidėjo, nors pikų neįvertinimo dalis beveik nepasikeitė.

**Atsparumo eksperimentas:** į meteorologinius požymius įterpiamas triukšmas ir tikrinama, kaip kinta CatBoost prognozavimo klaidos. Atskirame CatBoost Notebook taip pat nagrinėjamas trūkstamų įvesties reikšmių scenarijus. Šie bandymai yra skirtingi.

## Apribojimai

Tyrime naudojami vienos dviračių dalijimosi sistemos **2011–2012 m.** duomenys. Rezultatai savaime negarantuoja tokio pat tikslumo kitame mieste ar kitu laikotarpiu. Prognozuojama bendra paklausa, o ne atskirų stočių apkrova. Praktiniam taikymui reikėtų stebėti duomenų pokyčius ir reguliariai iš naujo įvertinti modelį.

## Šaltiniai

- [UCI Bike Sharing Dataset](https://archive.ics.uci.edu/dataset/275/bike+sharing+dataset)
- [CatBoost dokumentacija](https://catboost.ai/en/docs/)
- [Scikit-learn dokumentacija](https://scikit-learn.org/stable/)

---
