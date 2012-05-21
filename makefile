# Available make commands are:
.PHONY:all check clean

# Default target is (no targets yet):
all:

# Programs to build are:
BIN=
TEST=hello

#========================
# Compiler
#========================
FC=mpif90
FCFLAGS+=-stand f03 -warn all -warn errors
FCFLAGS+=-O3 -xHost -fp-model precise
FCFLAGS+=-gen-dep=$(DEPDIR)/$*.d  -gen-depformat=make
FCFLAGS+=-module $(MODDIR)

#========================
# Libraries
#========================
# ESMF
LDLIBS+=$(HOME)/projects/esmf/esmf-5.2.0rp2/lib/libO/Linux.intel.64.openmpi.default/libesmf.a
FCFLAGS+=-I$(HOME)/projects/esmf/esmf-5.2.0rp2/mod/modO/Linux.intel.64.openmpi.default

# LAPACK
LAPACK_LIBS:=-mkl
LDLIBS+=$(LAPACK_LIBS)

# NetCDF
NETCDF_LIBS:=`pkg-config netcdf-fortran netcdf-c++ netcdf --libs`
LDLIBS+=$(NETCDF_LIBS)

#========================
# Utilities
#========================
RM=rm -rfv
LD=$(FC)

#========================
# Directories
# Only $(SRCDIR) is stable, other paths are removed in a make clean
#========================
SRCDIR=src
OBJDIR=obj
BINDIR=bin
TESTDIR=test
MODDIR=mod
DEPDIR=dep

#========================
# Rules
#========================
all:$(addprefix $(BINDIR)/,$(BIN))
check:$(addprefix $(TESTDIR)/,$(TEST))
	@for test in $^; do ./$$test > /dev/null; echo "$$test $$( [ $$? = 0 ] && echo "PASS" || echo "FAIL" )"; done
clean:
	$(RM) $(OBJDIR) $(BINDIR) $(TESTDIR) $(MODDIR) $(DEPDIR)

#========================
# Pattern rules
#========================
obj/%.o:src/%.f90
	@mkdir -pv $(dir $@) $(DEPDIR) $(MODDIR)
	$(FC) $(FCFLAGS) -c -o $@ $<
bin/%:obj/%.o
	@mkdir -pv $(dir $@) 
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
test/%:obj/%.o
	@mkdir -pv $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)

#========================
# Generated dependancies
#========================
# Default phony module rule for no dependancies
%.mod:
	@true
-include $(wildcard $(DEPDIR)/*.d)
