#!/bin/bash

PROJECT_DIR="./WordCountApp"


OUTPUT_DIR="."

# Uruchomienie kontenera Docker z Maven i JDK do kompilacji projektu
docker run -it --rm --name maven-build-wordcount \
  -v "$PROJECT_DIR":/usr/src/mymaven \
  -w /usr/src/mymaven \
  maven:3.6.3-jdk-8 \
  mvn clean package

# Kopiowanie skompilowanego pliku .jar do folderu skryptu
# Zakładamy, że plik .jar zostaje wygenerowany w standardowej ścieżce target/wordcount-1.0-SNAPSHOT.jar
# Dostosuj nazwę pliku .jar jeśli jest inna
cp "$PROJECT_DIR/target/wordcount-1.0-SNAPSHOT-jar-with-dependencies.jar" "$OUTPUT_DIR"

echo "Kompilacja zakończona. Plik .jar został umieszczony w $OUTPUT_DIR"

