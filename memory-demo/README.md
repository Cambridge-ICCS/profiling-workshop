# Memory Leaks

Each of the following codes, `memory-c.c` and `memory-f90.f90`, provide simplified examples of memory bugs in code.

Each example has comments marking the problem and a suggested solution e.g.,

```c
     x[10] = 0;        // problem 1: heap block overrun (Invalid write)
     // x[9] = 0;      // solution 1: set 10th element instead of 11th
     // free(x);       // solution 2: free x before end of scope
  }                    // problem 2: memory leak -- x not freed
```

## Dependencies

To build the examples in this folder you will need the GNU compilers `gcc` and `gfortran`.

You can change the compiler to e.g., Intel oneapi compilers by specifying `CC=icx FC=ifx` when running `make`. For example,

```bash
make CC=icx FC=ifx
```

**Note**: Support for memory sanitizers in Intel may not be complete for fortran.

## Build

To compile the examples, run:

```bash
make
```

This will build all examples. The output should look something like,

```
gcc -g -o test-c.exe memory-c.c
gcc -g -fsanitize=address -o test-c-as.exe memory-c.c
gfortran -g -o test-f90.exe memory-f90.f90
gfortran -g -fsanitize=address -o test-f90-as.exe memory-f90.f90
```

Running `ls` you should see the binaries (`*.exe`):

```
Makefile  memory-c.c  memory-f90.f90  README.md  test-c-as.exe  test-c.exe  test-f90-as.exe  test-f90.exe
```

The binaries with a `-as` suffix were compiled with `-fsanitize=address`.

## Example

### `valgrind`

Let's take the C example `test-c.exe`. Running this with `valgrind` will give the following:

```
$ valgrind --leak-check=full ./test-c.exe
==115822== Memcheck, a memory error detector
==115822== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==115822== Using Valgrind-3.18.1 and LibVEX; rerun with -h for copyright info
==115822== Command: ./test-c.exe
==115822== 
==115822== Invalid write of size 4
==115822==    at 0x10916B: f (memory-c.c:6)
==115822==    by 0x109180: main (memory-c.c:13)
==115822==  Address 0x4aa3068 is 0 bytes after a block of size 40 alloc'd
==115822==    at 0x4848899: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==115822==    by 0x10915E: f (memory-c.c:5)
==115822==    by 0x109180: main (memory-c.c:13)
==115822== 
==115822== 
==115822== HEAP SUMMARY:
==115822==     in use at exit: 40 bytes in 1 blocks
==115822==   total heap usage: 1 allocs, 0 frees, 40 bytes allocated
==115822== 
==115822== 40 bytes in 1 blocks are definitely lost in loss record 1 of 1
==115822==    at 0x4848899: malloc (in /usr/libexec/valgrind/vgpreload_memcheck-amd64-linux.so)
==115822==    by 0x10915E: f (memory-c.c:5)
==115822==    by 0x109180: main (memory-c.c:13)
==115822== 
==115822== LEAK SUMMARY:
==115822==    definitely lost: 40 bytes in 1 blocks
==115822==    indirectly lost: 0 bytes in 0 blocks
==115822==      possibly lost: 0 bytes in 0 blocks
==115822==    still reachable: 0 bytes in 0 blocks
==115822==         suppressed: 0 bytes in 0 blocks
==115822== 
==115822== For lists of detected and suppressed errors, rerun with: -s
==115822== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
```

### `-fsanitize=address`

Let's take the C example `test-c-as.exe`. Running this "normally" gives:

```
$ ./test-c-as.exe

=================================================================
==116227==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x604000000038 at pc 0x58bcd5b1c202 bp 0x7ffd06e683b0 sp 0x7ffd06e683a0
WRITE of size 4 at 0x604000000038 thread T0
    #0 0x58bcd5b1c201 in f /home/melt/sync/cambridge/projects/side/profiling-workshop/memory-demo/memory-c.c:6
    #1 0x58bcd5b1c217 in main /home/melt/sync/cambridge/projects/side/profiling-workshop/memory-demo/memory-c.c:13
    #2 0x7548482f5d8f in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58
    #3 0x7548482f5e3f in __libc_start_main_impl ../csu/libc-start.c:392
    #4 0x58bcd5b1c0e4 in _start (/home/melt/sync/cambridge/projects/side/profiling-workshop/memory-demo/test-c-as.exe+0x10e4)

0x604000000038 is located 0 bytes to the right of 40-byte region [0x604000000010,0x604000000038)
allocated by thread T0 here:
    #0 0x7548485a9887 in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:145
    #1 0x58bcd5b1c1be in f /home/melt/sync/cambridge/projects/side/profiling-workshop/memory-demo/memory-c.c:5
    #2 0x58bcd5b1c217 in main /home/melt/sync/cambridge/projects/side/profiling-workshop/memory-demo/memory-c.c:13
    #3 0x7548482f5d8f in __libc_start_call_main ../sysdeps/nptl/libc_start_call_main.h:58

SUMMARY: AddressSanitizer: heap-buffer-overflow /home/melt/sync/cambridge/projects/side/profiling-workshop/memory-demo/memory-c.c:6 in f
Shadow bytes around the buggy address:
  0x0c087fff7fb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c087fff7fc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c087fff7fd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c087fff7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c087fff7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0c087fff8000: fa fa 00 00 00 00 00[fa]fa fa fa fa fa fa fa fa
  0x0c087fff8010: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c087fff8020: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c087fff8030: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c087fff8040: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c087fff8050: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==116227==ABORTING
```
