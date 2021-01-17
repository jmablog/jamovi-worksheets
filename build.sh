#!/bin/bash

pandocomatic -i input -o docs -c web.yaml --modified-only

pandocomatic -i input -o docx -c web.yaml --modified-only