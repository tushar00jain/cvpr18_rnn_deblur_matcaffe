## Docker

### Build

```bash
docker build -t dsd:0.0.1 .
```

### Debug

```bash
docker run -it --gpus all --name dsd -p 8005:8005 -v /media/DataDrive/:/data -v $(pwd):/workdir dsd:0.0.1 /bin/bash

find . -type f -exec sed -i -e 's^"hdf5.h"^"hdf5/serial/hdf5.h"^g' -e 's^"hdf5_hl.h"^"hdf5/serial/hdf5_hl.h"^g' '{}' \;
cd /usr/lib/x86_64-linux-gnu
ln -s libhdf5_serial.so.10.1.0 libhdf5.so
ln -s libhdf5_serial_hl.so.10.0.2 libhdf5_hl.so
cd -

apt-get install unzip
unzip -X -K matlab_R2015a_glnxa64.zip -d matlab_2015a_installer
cd matlab_2015a_installer
./install -mode silent -agreeToLicense yes -fileInstallationKey
```

> Train (TODO)

```bash
```

> Debug Testing

```bash
```

### Run

> Train (TODO)

```bash
```

> Test

```
docker logs dsd --tail 100 -f
```
