
import sys

inf = open(sys.argv[1], 'rb');
outf = open(sys.argv[2], 'w');

outf.write("@000\n")
while True:
    pair = inf.read(2)
    if len(pair) == 0:
        break
    outf.write("%02x%02x\n" % (ord(pair[0]), ord(pair[1])))

outf.close()
inf.close()
