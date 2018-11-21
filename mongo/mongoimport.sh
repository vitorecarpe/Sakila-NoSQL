#!/bin/bash
echo "INICIO !!!"
for f in csv/*.csv
do
    echo "Processing file $f..."
    mongoimport.exe --db projeto_nosql --type csv --headerline --file "$f"
done
echo "TERMINADO !!!"