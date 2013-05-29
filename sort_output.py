import MapReduceJSON
import sys

"""
Nucleotides  in the Simple Python MapReduce Framework
"""

mr = MapReduceJSON.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    key = [record[-1], record[-2]]
    key.extend(record[0])
    mr.emit_intermediate(tuple(key), None)

def reducer(key, list_of_values):
    mr.emit(key)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
