#!/bin/bash

source ~/.bash_env
rm -rf /opt/bazarr/frontend/build /opt/bazarr/frontend/node_modules
cp -r /node_modules /opt/bazarr/frontend/node_modules
cd /opt/bazarr/frontend
npm run build
test -d /opt/bazarr/frontend/build
cd /opt/bazarr
python3 bazarr.py --no-update
