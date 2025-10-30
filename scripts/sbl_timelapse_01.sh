#!/bin/bash
# ------------------------------------------------------------
# Script : extract_sblv_frames.sh
# Objectif : Rechercher et traiter les fichiers .sblv correspondant
#             à une date donnée dans un répertoire spécifié.
#
# Usage :
#   ./extract_sblv_frames.sh <module> <camera> <date> <repertoire_sortie>
#
# Exemple :
#   ./extract_sblv_frames.sh 2 1 20250929 /tmp/
#
# Cela traitera tous les fichiers :
#   M<module>C<camera>_20250929_HHMMSS.sblv
# ------------------------------------------------------------

# --- Vérification des arguments ---
if [ "$#" -ne 4 ]; then
    echo "Usage : $0 <module> <camera> <date (YYYYMMDD)> <repertoire>"
    exit 1
fi

REPERTOIRE="/beegfs/superbeelive_data/raw_data/cam_videos"
MODULE="$1"
CAMERA="$2"
DATE="$3"
OUTPUT_FOLDER="$4"

# --- Vérification de l'existence du répertoire ---
if [ ! -d "$OUTPUT_FOLDER" ]; then
    echo "Erreur : le répertoire '$OUTPUT_FOLDER' n'existe pas."
    exit 1
fi

# --- Recherche et tri des fichiers ---
# Le motif recherché : M??C??_${DATE}_??????.sblv
# (?? : 2 chiffres, ?????? : heure/min/sec)
FILES=$(find "$REPERTOIRE" -type f -name "M${MODULE}C${CAMERA}_${DATE}_??????.sblv" | sort)

if [ -z "$FILES" ]; then
    echo "Aucun fichier trouvé pour la date $DATE dans $REPERTOIRE."
    exit 0
fi

# --- Boucle de traitement ---
echo "Traitement des fichiers trouvés..."
for FILE in $FILES; do
    BASENAME=$(basename "$FILE" .sblv)
    OUTPUT="${OUTPUT_FOLDER}/${BASENAME}.png"

    echo "→ Extraction depuis : $FILE"
    echo "  -> Vers : $OUTPUT"
    sblv_extract_one_frame "$FILE" "$OUTPUT"
done

echo "✅ Traitement terminé."
