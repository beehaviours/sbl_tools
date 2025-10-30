#!/bin/bash
# ------------------------------------------------------------
# Script : sbl_timelapse_02.sh
# Objectif :
#   Extraire des images depuis des fichiers .sblv toutes les 15 minutes
#   entre deux dates/horaires spécifiées.
#
# Usage :
#   ./sbl_timelapse_02.sh <repertoire> <start: YYYYMMDD_HHMMSS> <end: YYYYMMDD_HHMMSS>
#
# Exemple :
#   ./sbl_timelapse_02.sh /data/sblv 20250929_080000 20250929_180000
#
# ------------------------------------------------------------

# --- Vérification des arguments ---
if [ "$#" -ne 3 ]; then
    echo "Usage : $0 <repertoire> <start: YYYYMMDD_HHMMSS> <end: YYYYMMDD_HHMMSS>"
    exit 1
fi

REPERTOIRE="/beegfs/superbeelive_data/raw_data/cam_videos"

OUTPUT_DIR="$1"
START="$2"
END="$3"
STEP_MINUTES=1   # pas de 15 minutes

# --- Vérification du répertoire ---
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Erreur : le répertoire '$OUTPUT_DIR' n'existe pas."
    exit 1
fi

# --- Conversion en timestamps ---
start_ts=$(date -d "${START:0:8} ${START:9:2}:${START:11:2}:${START:13:2}" +%s)
end_ts=$(date -d "${END:0:8} ${END:9:2}:${END:11:2}:${END:13:2}" +%s)

if [ "$end_ts" -le "$start_ts" ]; then
    echo "Erreur : la date de fin doit être postérieure à la date de début."
    exit 1
fi

echo "=== Extraction des frames toutes les ${STEP_MINUTES} minutes entre ${START} et ${END} ==="

# --- Boucle temporelle ---
current_ts=$start_ts
while [ "$current_ts" -le "$end_ts" ]; do
    current_date=$(date -d @"$current_ts" +"%Y%m%d_%H%M%S")
    day_part=${current_date:0:8}

    # Recherche des fichiers correspondant exactement à cette date/heure (minute près)
    FILE=$(find "$REPERTOIRE" -type f -name "M02C02_${day_part}_*.sblv" | sort | grep "${day_part}_${current_date:9:2}${current_date:11:2}" | head -n 1)

    if [ -n "$FILE" ]; then
        BASENAME=$(basename "$FILE" .sblv)
        OUTPUT_PNG="${OUTPUT_DIR}/${BASENAME}.png"

        echo "→ Extraction à ${current_date} depuis : $FILE"
        sblv_extract_one_frame "$FILE" "$OUTPUT_PNG"
    else
        echo "⚠️  Aucun fichier trouvé pour ${current_date}"
    fi

    # Incrément du temps
    current_ts=$(( current_ts + STEP_MINUTES * 60 ))
done

echo "✅ Extraction terminée."
