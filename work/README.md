# Build Fre-NCtools to create your own grid

```
cd FRE-NCtools-FEISTY
export FCFLAGS=-I/usr/include
export LIBS=-lnetcdf
autoreconf -i
mkdir build && cd build
../configure --prefix=/project/MOM6_OBGC_examples/work/FRE-NCtools-FEISTY
make
```