#!/bin/bash

pandocomatic -i input -o docs -c web.yaml --modified-only

pandocomatic -i input -o docs -c word.yaml --modified-only