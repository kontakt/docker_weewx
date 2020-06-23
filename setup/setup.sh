#!/bin/bash

set -e
set -x

cd /tmp/setup
python3 -m venv /home/venv
pip install -r requirements.txt
wget "http://www.weewx.com/downloads/released_versions/weewx-$WEEWX_VERSION.tar.gz"
tar xvfz weewx-$WEEWX_VERSION.tar.gz
patch weewx-$WEEWX_VERSION/bin/weeutil/logger.py logfix.patch
cd weewx-$WEEWX_VERSION
python3 ./setup.py build
python3 ./setup.py install --no-prompt