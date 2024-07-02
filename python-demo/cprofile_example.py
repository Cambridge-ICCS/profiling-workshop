import cProfile
import time
import pstats

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


# Run and prepare the profiling results
cProfile.run('function2()', 'f_stats')
p = pstats.Stats("f_stats")

# Sort by time in function and called functions
p.strip_dirs().sort_stats("cumulative").print_stats()

# Sort by time only in each functions
p.strip_dirs().sort_stats("time").print_stats()
