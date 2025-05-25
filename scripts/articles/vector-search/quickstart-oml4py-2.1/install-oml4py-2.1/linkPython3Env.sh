#! /usr/bin/bash
# to execute the commands use `source ./linkPython3Env.sh
echo "creating symbolic link for python3.12 environment"
cd /home/oracle/python
export PREFIX=/home/oracle/python/Python-3.12.6
cd $PREFIX
echo $PREFIX
export PYTHONHOME=$PREFIX
export PATH=$PYTHONHOME/bin:$PATH
export LD_LIBRARY_PATH=$PYTHONHOME/lib:$LD_LIBRARY_PATH
echo $PYTHONHOME
cd $PYTHONHOME/bin
ln -s python3.12 python3
