import os
import argparse

parser = argparse.ArgumentParser(description='Process files.')
parser.add_argument('-f', type=str, help='folder')
args = parser.parse_args()

filenames = [
    "bfs.trace.xz-bimodal-no-no-no-no-lru-1core.txt",
    "matrix_multi.trace.xz-bimodal-no-no-no-no-lru-1core.txt",
    "matrix_multi_2.trace.xz-bimodal-no-no-no-no-lru-1core.txt",
    "quicksort.trace.xz-bimodal-no-no-no-no-lru-1core.txt"
]

numbering = {
    "L1D": 0,
    "L1I": 1,
    "L2C": 2,
    "LLC": 3,
}
caches = ["L1D", "L1I", "L2C", "LLC"]

data_mpki = [[0 for _ in range(4)] for _ in range(4)]
data_aml = [[0 for _ in range(4)] for _ in range(4)]
data_ipc = [0.0 for _ in range(4)]
baseline_ipc = [0.844404, 0.684276, 0.683893, 0.794884]

for idx, filename in enumerate(filenames):
    with open(os.path.join(args.f, filename), 'r') as fp:
        for line in fp:
            splits = line.rstrip().split()
            if len(splits) < 5:
                continue
            if splits[0]=="CPU" and splits[1]=="0" and splits[2]=="cumulative":
                data_ipc[idx] = float(splits[4])
            if splits[0] in caches and splits[1]=="TOTAL":
                access = float(splits[3])
                misses = float(splits[7])
                data_mpki[numbering[splits[0]]][idx] = (misses/access)*1000
            if splits[0] in caches and splits[1]=="AVERAGE":
                aml = float(splits[4])
                data_aml[numbering[splits[0]]][idx] = aml


print(' & '.join("{0:.6f}".format(x) for x in data_ipc), "\\\\")
print(' & '.join(["$\\downarrow$" if x<=b else "$\\uparrow$" for b,x in zip(baseline_ipc, data_ipc)]), "\\\\")
print()
print()

for i, row in enumerate(data_mpki):
    print(caches[i], end=' & ')
    print(','.join("{0:.3f}".format(x) for x in row), "\\\\")
print()
print()

for i, row in enumerate(data_aml):
    print(caches[i], end=' & ')
    print(' & '.join("{0:.3f}".format(x) for x in row), "\\\\")