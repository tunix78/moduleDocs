#!/bin/bash

# we need to get 3 input parameters, the directory that we can find all the module docs in, the source dir for the master docs and the target path to put all the docs into
if [[ $# != 4 ]]; then
    echo "Usage: $0 <base_dir> <src_modules_dir> <mstr_module_docs_dir> <tgt_module_docs_dir>"
    echo "Example: $0 /tmp src_modules mstr_moduleDocs tgt_module_docs"
    exit 1
fi

BASE_DIR=$1
SRC_MODULES_DIR=$1/$2
MSTR_MODULE_DOCS_DIR=$1/$3
TGT_MODULE_DOCS_DIR=$1/$4
MODULES_TO_CLONE=stackrModule
echo "Using ${BASE_DIR} as the base directory"
echo "Using ${SRC_MODULES_DIR} as the source of all our module documentation"
echo "Using ${MSTR_MODULE_DOCS_DIR} as the directory of the master documentation"
echo "Using ${TGT_MODULE_DOCS_DIR} as the target for all our compiled documentation"

# Create the source modules dir in case it doesn't exist
echo
echo "Creating the source module dir: " ${SRC_MODULES_DIR}
mkdir -p ${SRC_MODULES_DIR}

# Assumption is that the master documentation has a standard sphinx folder structure
echo
echo "Copying the master documentation to the target directory"
mkdir -p ${TGT_MODULE_DOCS_DIR}
cp -R ${MSTR_MODULE_DOCS_DIR}/docs ${TGT_MODULE_DOCS_DIR}/

# FIXME the cloning happens in the pipeline at the moment which ideally happens here
# clone all the modules that are part of the modules documentation dir
#cd ${SRC_MODULES_DIR}
#for module in ${MODULES_TO_CLONE}; do
#  echo "Cloning module " ${module}
#  rm -rf ${SRC_MODULES_DIR}/${module}
#  git clone git@github.com:tunix78/${module}.git
#done
#cd -

# we will assume that all terraform modules have the same structure (moduleName/docs/)
# this allows us to loop through each directory, copy the required files and put them into the module_docs_dir
echo
echo "Creating the basic module-docs folder structure"
find $SRC_MODULES_DIR -maxdepth 1 -mindepth 1 -type d | while read dir; do
  THE_DIR=`basename ${dir}`
  echo
  echo "Get basename from full directory path: ${THE_DIR}"

  echo
  echo "Directory to get RST files from: ${THE_DIR}"
  mkdir -p ${TGT_MODULE_DOCS_DIR}/docs/source/${THE_DIR}

  #echo
  #echo "  !!! Copy static content"
  #cp -R ${dir}/docs/source/_static/* ${TGT_MODULE_DOCS_DIR}/docs/source/_static/

  #echo
  #echo "  !!! Copy image content"
  #echo "TODO - Needs to be implemented still"

  #echo
  #echo "  !!! Copy template content"
  #cp -R ${dir}/docs/source/_templates/* ${TGT_MODULE_DOCS_DIR}/docs/source/_templates/

  echo
  echo "  !!! Copy actual restructured text files"
  cp -R ${dir}/docs/source/*.rst ${TGT_MODULE_DOCS_DIR}/docs/source/${THE_DIR}/

  echo
  echo
  ls -la ${TGT_MODULE_DOCS_DIR}/docs/source/${THE_DIR}/
  echo "-------------------------------"
done

echo
echo "Merged all module documentation into a single directory so sphinx can now run against that"
