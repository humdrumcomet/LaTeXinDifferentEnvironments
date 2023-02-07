import matplotlib as mpl
import numpy as np

mpl.use('pgf')
mpl.pyplot.rcParams.update({
    "pgf.texsystem": "lualatex", "text.usetex": True,
    "pgf.rcfonts": False, "font.family": "serif",
    "pgf.preamble": "\n".join([
         r"\usepackage[T1]{fontenc}", r"\usepackage{siunitx}",
         r"\usepackage{chemformula}", r"\usepackage{amsmath}"
    ]),
})

a = np.linspace(1, 20, 100)
b = a**2
fig, ax = mpl.pyplot.subplots()
ax.semilogx(a, b)
ax.set_xlabel('$R_{o}$ (\\si{\\ohm})')
ax.set_ylabel('$V_{o}$')
ax.grid(visible=True, which='both', axis='both', alpha=0.5)
fig.savefig('examplePlot.tex'.format(filename), bbox_inches='tight', format='pgf')
