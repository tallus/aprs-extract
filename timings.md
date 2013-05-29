Timings
=======

Split file relevant data out of log file.

% time ./extract.sh -ld dump/ data/aprsis-20120107.log
./extract.sh -ld dump/ data/aprsis-20120107.log  2.71s user 0.54s system 92% cpu 3.510 total
% ls -lh dump 
total 228M
-rw-rw-r-- 1 paul paul  76M May 28 23:17 aprsis-20120107.latlon
-rw-rw-r-- 1 paul paul  22M May 28 23:17 aprsis-20120107.mice
-rw-rw-r-- 1 paul paul 131M May 28 23:17 aprsis-20120107.qar

% ls -lh data 
total 292M
-r-------- 1 paul paul 292M May 24 22:36 aprsis-20120107.log



Run extract.py on log file
% time python extract.py data/aprsis-20120107.log >/dev/null
python extract.py data/aprsis-20120107.log > /dev/null  66.18s user 0.36s system 99% cpu 1:06.78 total
Run extract.py only on lines matching qAR or qAr
% time python extract.py clean/aprsis-20120107.qar >/dev/null 
python extract.py clean/aprsis-20120107.qar > /dev/null  29.10s user 0.15s system 99% cpu 29.355 total

Run extract.py only on lines matching qAR or qAr
% time python extract.py clean/aprsis-20120107.latlon >20120107.json
python extract.py clean/aprsis-20120107.latlon > 20120107.json  15.98s user 0.12s system 99% cpu 16.165 total


% time python sort_output.py 20120107.json > 20120107.histogram.json
python sort_output.py 20120107.json > 20120107.histogram.json  0.62s user 0.02s system 87% cpu 0.731 total



