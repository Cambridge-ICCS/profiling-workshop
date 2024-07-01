#include <stdlib.h>

  void f(void)
  {
     int* x = malloc(10 * sizeof(int));
     x[10] = 0;        // problem 1: heap block overrun (Invalid write)
     // x[9] = 0;      // solution 1: set 10th element instead of 11th
     // free(x);       // solution 2: free x before end of scope
  }                    // problem 2: memory leak -- x not freed

  int main(void)
  {
     f();
     return 0;
  }
