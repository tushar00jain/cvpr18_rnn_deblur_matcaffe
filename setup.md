## Docker

### Build

```bash
docker build -t dsd:0.0.1 .
```

### Debug

```bash
docker run --mac-address ${MAC} -it --gpus all --name dsd -p 8005:8005 -v /media/DataDrive/:/data -v $(pwd):/workdir tushar00jain/dsd:0.0.3 /bin/bash

find . -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \;
cd /usr/lib/x86_64-linux-gnu
ln -s libhdf5_serial.so.10.1.0 libhdf5.so
ln -s libhdf5_serial_hl.so.10.0.2 libhdf5_hl.so
cd -

apt-get install unzip
unzip -X -K R2015a.zip
cd R2015a
./install -mode silent -agreeToLicense yes -fileInstallationKey ${KEY}
/usr/local/MATLAB/R2015a/bin/activate_matlab.sh -propertiesFile /workdir/activate.ini

# https://askubuntu.com/questions/719028/version-glibcxx-3-4-21-not-found
ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6  /usr/local/MATLAB/R2015a/bin/glnxa64/../../sys/os/glnxa64/libstdc++.so.6

# https://github.com/BVLC/caffe/issues/3934
cd /usr/local/MATLAB/R2015a/bin/glnxa64
mv libopencv_imgproc.so.2.4 libopencv_imgproc.so.2.4.bak
mv libopencv_highgui.so.2.4 libopencv_highgui.so.2.4.bak
mv libopencv_core.so.2.4 libopencv_core.so.2.4.bak
ln /usr/lib/x86_64-linux-gnu/libopencv_core.so.2.4.9 libopencv_core.so.2.4
ln /usr/lib/x86_64-linux-gnu/libopencv_highgui.so.2.4.9 libopencv_highgui.so.2.4
ln /usr/lib/x86_64-linux-gnu/libopencv_imgproc.so.2.4.9 libopencv_imgproc.so.2.4
cd -

make all -j8
make matcaffe
```

> Train

```bash
cd /workdir/matlab/train
/usr/local/MATLAB/R2015a/bin/matlab -nodisplay -nodesktop -r "train"
```

> Debug Testing

```bash
cd /workdir/matlab/test
/usr/local/MATLAB/R2015a/bin/matlab -nodisplay -nodesktop -r "test"
```

### Run

> Train

```bash
docker run -d --mac-address ${MAC} -it --gpus all --name dsd -p 8005:8005 -v /media/Data/:/data -v $(pwd):/workdir tushar00jain/dsd:0.0.3 /workdir/train.sh
docker logs dsd --tail 100 -f
```

> Test

```bash
docker run -d --mac-address ${MAC} -it --gpus all --name dsd-test -p 8005:8005 -v /media/Data/:/data -v $(pwd):/workdir tushar00jain/dsd:0.0.3 /workdir/test.sh
docker logs dsd-test --tail 100 -f
```
