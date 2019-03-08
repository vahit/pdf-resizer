#!/usr/sbin/env

FILE=${1:-}
UPSIDE=${2:-}
DOWNSIDE=${3:-}
OLD_DIR=$(pwd)
TEMP_DIR=$(mktemp -d)
cp ${FILE} ${TEMP_DIR} && cd ${TEMP_DIR}
mkdir ./PNG_DIR
convert -colorspace GRAY -interlace none -density 150 ${FILE} ./PNG_DIR/${FILE%pdf}png

mkdir ./RESIZED_PNG
for EACH_PNG in $(ls -v ./PNG_DIR); do
    convert ./PNG_DIR/${EACH_PNG} -crop ${UPSIDE} ./RESIZED_PNG/${EACH_PNG%.png}-a.png
    convert ./PNG_DIR/${EACH_PNG} -crop ${DOWNSIDE} ./RESIZED_PNG/${EACH_PNG%.png}-b.png
done

cd ./RESIZED_PNG
convert $(ls -v ../RESIZED_PNG) +repage ${FILE%.pdf}-resized.pdf
cp ${FILE%.pdf}-resized.pdf ${OLD_DIR}
