CC=gcc
FC=gfortran
FLAGS=-g
ASFLAG=-fsanitize=address

.PHONY: clean all

all: test-c.exe test-c-as.exe test-f90.exe test-f90-as.exe

test-c.exe: memory-c.c
	     $(CC) $(FLAGS) -o $@ $<

test-c-as.exe: memory-c.c
	     $(CC) $(FLAGS) $(ASFLAG) -o $@ $<

test-f90.exe: memory-f90.f90
	     $(FC) $(FLAGS) -o $@ $<

test-f90-as.exe: memory-f90.f90
	     $(FC) $(FLAGS) $(ASFLAG) -o $@ $<

clean:
	rm -f *.exe
