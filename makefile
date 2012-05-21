FC=mpif90
# Link with the fortran compiler
LD=$(FC)
# Diagnostics
FCFLAGS+=-stand f03 -warn all -warn errors
# Optimisation
FCFLAGS+=-O3 -xHost

# ESMF
ESMF_LIBS:=-L~/projects/esmf/esmf-5.2.0rp2/lib/libO/Linux.intel.64.openmpi.default/libesmf.a
LDLIBS+=$(ESMF_LIBS)

# LAPACK
LAPACK_LIBS:=-mkl
LDLIBS+=$(LAPACK_LIBS)

# NetCDF
NETCDF_LIBS:=`pkg-config netcdf-fortran netcdf-c++ netcdf --libs`
LDLIBS+=$(NETCDF_LIBS)

RM=rm -rfv

.PHONY:all check clean
all:bin/hello
check:
clean:
	$(RM) bin obj test

obj/%.o:src/%.f90
	@mkdir -pv $(dir $@)
	$(FC) $(FCFLAGS) -c -o $@ $<
bin/%:obj/%.o
	@mkdir -pv $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
test/%:obj/%.o
	@mkdir -pv $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
