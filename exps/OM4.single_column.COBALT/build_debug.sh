#bash!
cd /project/rdenechere/CEFI-regional-MOM6-FEISTY/builds
./linux-build.bash -m monkfish -p linux-gnu -t prod -f mom6sis2
cd /project/rdenechere/CEFI-regional-MOM6-FEISTY/exps/OM4.single_column.COBALT
yes | cp -i /project/rdenechere/CEFI-regional-MOM6-FEISTY/builds/build/monkfish-linux-gnu/ocean_ice/prod/MOM6SIS2 .
gdb MOM6SIS2

