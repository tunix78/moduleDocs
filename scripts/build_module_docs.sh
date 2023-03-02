#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Usage: $0 <module_docs_dir>"
    echo "Example: $0 /tmp/module_docs"
    exit 1
fi

MODULE_DOCS_DIR=$1
echo "Using ${MODULE_DOCS_DIR} as the directory to run the build in"

cd ${MODULE_DOCS_DIR}
sphinx-build -b html docs/source/ docs/build/html