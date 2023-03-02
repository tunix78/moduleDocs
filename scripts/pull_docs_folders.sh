#!/bin/bash

# we need to get 3 input parameters, the directory that we can find all the module docs in, the source dir for the master docs and the target path to put all the docs into
if [[ $# != 3 ]]; then
    echo "Usage: $0 <all_modules_dir> <src_module_docs_dir> <module_docs_dir>"
    echo "Example: $0 ~/mytemp/all_modules ~/terraform/moduleDocs /tmp/module_docs"
    exit 1
fi

ALL_MODULES_DIR=$1
SRC_MODULE_DOCS_DIR=$2
MODULE_DOCS_DIR=$3
echo "Using ${ALL_MODULES_DIR} as the source of all our module documentation"
echo "Using ${SRC_MODULE_DOCS_DIR} as the source of the master documentation"
echo "Using ${MODULE_DOCS_DIR} as the target for all our compiled documentation"

# Assumption is that the source master documentation has a standard sphinx folder structure
echo
echo "Copying the master documentation to the target directory"
mkdir -p ${MODULE_DOCS_DIR}
cp -R ${SRC_MODULE_DOCS_DIR}/docs ${MODULE_DOCS_DIR}/

# clone all the modules that are part of the modules documentation dir
# this could be automated to just loop through all the repos in the project (AZDO) and clone those
cd ${ALL_MODULES_DIR}
# imagine a loop with a git clone cmd here
cd -

# we will assume that all terraform modules have the same structure (moduleName/docs/)
# this allows us to loop through each directory, copy the required files and put them into the module_docs_dir
echo
echo "Creating the basic module-docs folder structure"
find $ALL_MODULES_DIR -maxdepth 1 -mindepth 1 -type d | while read dir; do
  THE_DIR=`basename ${dir}`
  echo
  echo "Get basename from full directory path: ${THE_DIR}"

  echo
  echo "Directory to get RST files from: ${THE_DIR}"
  mkdir -p ${MODULE_DOCS_DIR}/docs/source/${THE_DIR}

  echo
  echo "  !!! Copy static content"
  cp -R ${dir}/docs/source/_static/* ${MODULE_DOCS_DIR}/docs/source/_static/

  echo
  echo "  !!! Copy image content"
  echo "TODO - Needs to be implemented still"

  echo
  echo "  !!! Copy template content"
  cp -R ${dir}/docs/source/_templates/* ${MODULE_DOCS_DIR}/docs/source/_templates/

  echo
  echo "  !!! Copy actual restructured text files"
  cp -R ${dir}/docs/source/*.rst ${MODULE_DOCS_DIR}/docs/source/${THE_DIR}/

  echo
  echo
  ls -la ${MODULE_DOCS_DIR}/docs/source/${THE_DIR}/
  echo "-------------------------------"
done

echo
echo "Merged all module documentation into a single directory so sphinx can now run against that"
