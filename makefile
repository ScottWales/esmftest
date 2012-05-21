.PHONY:all check clean
all:
check:
clean:
	$(RM) bin obj

obj/%.o:src/%.f90
	$(FC) $(FCFLAGS) -c -o $@ $<
bin/%:obj/%.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)
