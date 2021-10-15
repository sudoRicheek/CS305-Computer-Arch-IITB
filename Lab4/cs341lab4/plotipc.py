import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['text.usetex'] = True


programs = ["bfs", "matrix_multi", "matrix_multi_2", "quicksort"]
ipc = {x: [] for x in programs}
normalized_ipc = dict()

experiments = ["baseline", "direct-mapped", "fully-associative",
               "reduced-size", "doubled-size", "reduced-mshr", "doubled-mshr"]
labels = experiments[1:]

ipc["bfs"]              = [0.844404, 0.842032, 0.844037, 0.835378, 0.789770, 0.844328, 0.844402]
ipc["matrix_multi"]     = [0.684276, 0.678711, 0.684264, 0.684034, 0.650507, 0.683079, 0.682737]
ipc["matrix_multi_2"]   = [0.683893, 0.680293, 0.684298, 0.683902, 0.650657, 0.681273, 0.683352]
ipc["quicksort"]        = [0.794884, 0.792479, 0.792999, 0.766297, 0.755001, 0.783982, 0.796453]

for p in programs:
    normalized_ipc[p] = (np.array(ipc[p])/ipc[p][0])[1:]
# print(normalized_ipc)

programs_labels = [r"bfs", r"matrix\_multi", r"matrix\_multi\_2", r"quicksort"]
df = pd.DataFrame(columns=["programs"]+labels)
for i, p in enumerate(programs):
    df.loc[i] = [p] + normalized_ipc[p].tolist()
print(df)

df.plot(rot=1, kind="bar", colormap="seismic", figsize=(18,8), fontsize=16)
plt.xticks(range(len(programs_labels)), programs_labels)
plt.ylim(bottom=0.92, top=1.01)
plt.xlabel(r"Programs", fontsize=20)
plt.ylabel(r"Normalised IPC", fontsize=20)
plt.title(r"\textbf{Attained IPC Speedup (Normalised)}", fontsize=22)
plt.savefig("ipcspeedup.svg")
plt.legend(fontsize=16)
plt.show()