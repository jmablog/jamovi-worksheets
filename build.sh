#!/bin/bash

pandocomatic -i input -o docs -c html.yaml --modified-only
pandocomatic -i input -o docs -c github.yaml --modified-only
pandocomatic -i input -o docs -c word.yaml --modified-only