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

import sys
import json
import fileinput

def process(record, array):
    stat=record[0]
    key=tuple(stat)
    value=record[2]
    if key in array:
        array[key] = array[key] + value
    else:
        array[key] = value

if __name__ == '__main__':
    results = dict()
    for line in fileinput.input():
        record=json.loads(line)
        process(record, results)
    jenc = json.JSONEncoder()
    for key, value in  results.items():
        item=[key,value]
        print(jenc.encode(item))
