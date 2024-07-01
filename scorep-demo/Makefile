FC=mpif90
FLAGS=-g -cpp -O2

.PHONY: clean all

all: simple.exe simple-inst.exe

simple.exe: simple-mpi.f90
	     $(FC) $(FLAGS) -o $@ $<

simple-inst.exe: simple-mpi.f90
	     scorep-$(FC) $(FLAGS) -o $@ $<

clean:
	rm -f *.exe
