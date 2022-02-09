#!/bin/bash

/usr/local/MATLAB/R2015a/bin/activate_matlab.sh -propertiesFile /workdir/activate.ini

cd /workdir/matlab/train
/usr/local/MATLAB/R2015a/bin/matlab -nodisplay -nodesktop -r "train"
