#!/bin/bash

THEMEZ_DIR="./../themez"

mkdir -p "$THEMEZ_DIR"

for i in $(ls -d */); do
    jar cvfM "$THEMEZ_DIR/${i:0:-1}.jar" -C ${i:0:-1} .
done;

