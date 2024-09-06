# Build Fre-NCtools to create your own grid

```
cd FRE-NCtools-FEISTY
export FCFLAGS=-I/usr/include
export LIBS=-lnetcdf
autoreconf -i
mkdir build && cd build
mkdir ../../fre-nc/
../configure --prefix=/project/rdenechere/CEFI-regional-MOM6-FEISTY/work/fre-nc 
make
make install
export PATH=$PATH:/project/rdenechere/CEFI-regional-MOM6-FEISTY/work/fre-nc/bin/ 
```