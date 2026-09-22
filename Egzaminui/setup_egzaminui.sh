```bash
#!/usr/bin/env bash
set -e

# Projekto aplankas – tas, kuriame yra šis skriptas
BASE="$(cd "$(dirname "$0")" && pwd)"

# Virtualios aplinkos pavadinimas
VENV="$BASE/.prognoze_eksperimentas_26"

echo "Projekto aplankas: $BASE"

cd "$BASE"

# Sukuriama virtuali Python aplinka
py -3.11 -m venv "$VENV"

# Aktyvuojama Windows virtuali aplinka per Git Bash
source "$VENV/Scripts/activate"

# Atnaujinamas pip
python -m pip install --upgrade pip

# Įdiegiamos projekto bibliotekos
python -m pip install -r requirements.txt

echo ""
echo "Paruosimas baigtas."
echo "Virtuali aplinka: .prognoze_eksperimentas_26"
echo "Jupyter Notebook paleidimas:"
echo "jupyter notebook"
```
