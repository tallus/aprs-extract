#    Copyright Paul Munday 2013

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


import MapReduceFile
import sys
import re
"""
Outputs JSON arrays like this:
[[digipeater, latitude, longitude],date,count]
where date is extracted form file name and count is the number of occurences of [digipeater, latitude, longitude]
"""

mr = MapReduceFile.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    keyval = record.split(':',1)
    route = keyval[0].split()[1].split(',')
    val = keyval[1]
    # route as string contains an asterix
    if re.search(re.escape('*'),''.join(route)):
        # last value contains an asterix so this is in fact the digipeater (we hope)
        if re.search(re.escape('*'),route[-1]):
            digipeater = route[-1]
        else:
            # other wise first value is digipeater
            digipeater = route[1]
    else:                                               
        # received directly last hop is digipeater
        digipeater = route[-1]
    if re.search(re.escape('*'),digipeater):
        digipeater = digipeater[:-1]
    latlonmatch = re.compile("(=|!|/|@)([0-9]{4}.[0-9]{0,2}N|S).([0-9]{5}.[0-9]{0,2}W|E)")
    ll = re.search(latlonmatch, val)
    if ll:
        latitude = ll.group(2)
        longitude = ll.group(3)
        mr.emit_intermediate((digipeater, latitude, longitude), 1)

def reducer(key, list_of_values):
    mr.emit((key, date, len(list_of_values)))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  date = re.search('[0-9]{8}',sys.argv[1]).group()
  mr.execute(inputdata, mapper, reducer)
