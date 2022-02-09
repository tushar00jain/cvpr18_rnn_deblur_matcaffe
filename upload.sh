#!/usr/bin/env bash

FILE=SOTIS-v1_iter_$1

LOCAL=matlab/train/model
REMOTE=s3://sotis-oqx7lxgt/cvpr18_rnn_deblur_matcaffe

aws s3 cp $LOCAL/$FILE.solverstate $REMOTE/$FILE.solverstate
aws s3 cp $LOCAL/$FILE.caffemodel $REMOTE/$FILE.caffemodel
aws s3 cp $LOCAL/solver.mat $REMOTE/solver.mat
