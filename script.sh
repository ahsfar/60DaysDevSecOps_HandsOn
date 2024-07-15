#!/bin/bash

for i in {1..60}; do
  mkdir "day$i"
  echo "This is day$i" > "day$i/README.md"
done

