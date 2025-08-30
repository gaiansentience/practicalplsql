#! /usr/bin/bash
# to execute the commands use `source ./setPython3Env.sh
echo "setting python3.12 environment and navigating to oml4py/exports"
cd /home/oracle/python
export PREFIX=/home/oracle/python/Python-3.12.6
cd $PREFIX
export PYTHONHOME=$PREFIX
export PATH=$PYTHONHOME/bin:$PATH
export LD_LIBRARY_PATH=$PYTHONHOME/lib:$LD_LIBRARY_PATH
cd /home/oracle/oml4py/exports
pwd
