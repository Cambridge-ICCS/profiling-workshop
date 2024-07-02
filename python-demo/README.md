# Python Profiling Demo

## cProfile

The [cprofile_example.py](https://github.com/Cambridge-ICCS/profiling-workshop/blob/main/python-demo/cprofile_example.py) script contains a simple example of using cProfile to profile two functions.

Run it as `python3 cprofile_example.py` and look at the output. You will see the cumulative time for each function (time in the function itself as well as the functions it calls) as well as the time online spent in the function itself. Try playing around with the code by adding additional `time.sleep` calls in either of the functions, and see how the output changes.

## LineProfiler

The [lineprofiler_example.py](https://github.com/Cambridge-ICCS/profiling-workshop/blob/main/python-demo/lineprofiler_example.py) script gives you an example of how to profile a Python code line by line, rather than function by function.

To use the LineProfiler, you will need to `pip install line_profiler`. Run the code as `python3 lineprofiler_example.py` and look at the output, which gives you the time spent in each line of the functions. Play around with the code by adding functions or parameters, and adding additional `time.sleep` or other calls.
