from line_profiler import LineProfiler
import time

# Printing a greeting and waiting
def function1():
    for i in range(5):
        print("Hello number ", i)
        time.sleep(i)

#Printing a greeting and calling function1
def function2():
    for i in range(5):
        print("Good day, number ", i)
    function1()


# Create profiler and wrapper (wrapping the function)
profiler = LineProfiler()
profiler.add_function(function1)   # add additional function to profile
wrapper = profiler(function2)
# call wrapper (pass function arguments if necessary)
wrapper()
profiler.print_stats()
