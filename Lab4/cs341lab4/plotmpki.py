import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['text.usetex'] = True

cache = "LLC"

programs = ["bfs", "matrix_multi", "matrix_multi_2", "quicksort"]
experiments = ["baseline", "direct-mapped", "fully-associative",
               "reduced-size", "doubled-size", "reduced-mshr", "doubled-mshr"]

df = pd.read_csv(f"mpki{cache.lower()}.csv", index_col=0).transpose()


df.loc[:, experiments[1:]] = df.loc[:, experiments[1:]].sub(df[experiments[0]], axis=0)
df.loc[:, experiments[1:]] = df.loc[:, experiments[1:]].div(df[experiments[0]], axis=0)*(-100)
df = df[experiments[1:]]

programs_labels = [r"bfs", r"matrix\_multi", r"matrix\_multi\_2", r"quicksort"]

df.plot(rot=1, kind="bar", colormap="seismic", figsize=(18,8), fontsize=16)
plt.xticks(range(len(programs_labels)), programs_labels)
plt.xlabel(r"Programs", fontsize=20)
plt.ylabel(r"MPKI Improvment/Degradation \%  (symlog scale)", fontsize=20)
plt.title(r"\textbf{MPKI improvement/degradation for }"f"{cache}", fontsize=22)
plt.yscale('symlog')
plt.savefig(f"mpki{cache.lower()}.svg")
plt.legend(fontsize=16)
plt.show()