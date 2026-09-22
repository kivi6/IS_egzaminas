EGZAMINO PROJEKTAS – DVIRAČIŲ PAKLAUSOS PROGNOZĖ

1. Nukopijuokite visą šį katalogą į /Users/karol/Dekatop/Egzaminui
2. Į tą patį katalogą įdėkite hour.csv.
3. Terminale:
   cd /Users/karol/Dekatop/Egzaminui
   chmod +x setup_egzaminui.sh
   ./setup_egzaminui.sh
   source .prognoze_eksperimentas_26/bin/activate
   jupyter notebook
4. Paleiskite notebook nuo pirmos iki paskutinės celės (Kernel -> Restart & Run All).

Notebookai:
02_CatBoost.ipynb – pagrindinis gradientinio stiprinimo metodas
03_MLP.ipynb – daugiasluoksnis perceptronas
04_SVR.ipynb – RBF Support Vector Regression

Visuose naudojamas tas pats chronologinis skaidymas, baseline ir metrikos.



