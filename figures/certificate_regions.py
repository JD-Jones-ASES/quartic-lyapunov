#!/usr/bin/env python3
"""Certificate-region figure for the quartic-lyapunov project.

Reproduction: python certificate_regions.py
Dependencies: matplotlib (NumPy is a Matplotlib dependency).
Outputs: certificate_regions.png (300 dpi), certificate_regions.pdf (vector).

The chart records proved intervals, not numerical feasibility samples.
B1 and B2 are represented by display approximations to their proved exact
algebraic values. The strict sextic interval through 9/4 is a certified
lower interval and must never be presented as the exact sextic boundary.
"""
from pathlib import Path
from math import sqrt
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Patch
from matplotlib.lines import Line2D

OUT = Path(__file__).resolve().parent
B1 = 1.9001890993467045
B2 = 2.1281535330886186271
SIX = 9/4
C = 2*sqrt(2)
XMAX = 3.15

plt.rcParams.update({
    'font.family': 'DejaVu Sans',
    'font.size': 11,
    'mathtext.fontset': 'dejavusans',
    'pdf.fonttype': 42,
    'ps.fonttype': 42,
    'axes.unicode_minus': False,
    'savefig.facecolor': 'white',
    'hatch.linewidth': .7,
})
COL = {
    'ink': '#182D40',
    'muted': '#596B78',
    'feasible': '#207E89',
    'infeasible': '#EDC5CC',
    'infeasible_edge': '#B66A78',
    'unknown': '#FCF1D6',
    'unknown_edge': '#B79748',
    'grid': '#DCE4E8',
    'purple': '#755294',
    'card': '#F3F6F8',
}
fig = plt.figure(figsize=(14.4, 9.4), facecolor='white')
fig.text(.055, .951, 'Polynomial certificate regions at damping one',
         fontsize=23, weight='bold', color=COL['ink'], ha='left', va='top')
fig.text(.055, .904,
         'Exact boundaries, a certified sextic interval, and the rational counterexample',
         fontsize=12.5, color=COL['muted'], ha='left', va='top')

ax = fig.add_axes([.205, .393, .745, .447])
ax.set_xlim(0, XMAX)
ax.set_ylim(-.55, 4.58)
ax.set_yticks([4, 3, 2, 1, 0])
ax.set_yticklabels([
    'Degree 2\nstrict quadratics',
    'Degree 4\nstrict quartics',
    'Degree 6\nstrict sextics',
    'Some finite degree\nstrict polynomials',
    'Rational example\nstrict, $C^1$',
], fontsize=11.3, color=COL['ink'], ha='right', linespacing=1.5)
ax.tick_params(axis='y', length=0, pad=18)
ax.set_xticks([0, .5, 1, 1.5, 2, 2.5, 3])
ax.set_xticklabels(['0', '0.5', '1', '1.5', '2', '2.5', '3'],
                   fontsize=10.5, color=COL['muted'])
ax.tick_params(axis='x', colors=COL['muted'], length=4, pad=7)
ax.set_xlabel(r'Parameter magnitude $|b|$', fontsize=11.5,
              color=COL['ink'], labelpad=11)
for side in ['top', 'left', 'right']:
    ax.spines[side].set_visible(False)
ax.spines['bottom'].set_color('#A9B8C1')
ax.spines['bottom'].set_linewidth(.8)

# Threshold guides belong to the polynomial rows, not the isolated rational example.
for threshold, name in [(B1, r'$B_1$'), (B2, r'$B_2$'), (SIX, r'$9/4$'), (C, r'$C$')]:
    ax.plot([threshold, threshold], [.59, 4.27], color=COL['grid'],
            linewidth=.85, linestyle=(0, (3, 3)), zorder=0)
    ax.text(threshold, 4.43, name, fontsize=12.2, color=COL['ink'],
            ha='center', va='center')

HEIGHT = .41

def interval(y, left, right, status):
    kwargs = dict(facecolor=COL[status], edgecolor='none', linewidth=0)
    if status == 'unknown':
        kwargs.update(edgecolor=COL['unknown_edge'], hatch='////', linewidth=.55)
    ax.add_patch(Rectangle((left, y-HEIGHT/2), right-left, HEIGHT,
                           zorder=2, **kwargs))

for y, bound in [(4, B1), (3, B2), (1, C)]:
    interval(y, 0, bound, 'feasible')
    interval(y, bound, XMAX, 'infeasible')
    ax.plot(bound, y, 'o', markersize=8.5, markerfacecolor='white',
            markeredgecolor=COL['feasible'], markeredgewidth=1.65, zorder=4)

interval(2, 0, SIX, 'feasible')
interval(2, SIX, C, 'unknown')
interval(2, C, XMAX, 'infeasible')
ax.plot(SIX, 2, 'o', markersize=8.5, markerfacecolor=COL['feasible'],
        markeredgecolor='white', markeredgewidth=1.15, zorder=4)
ax.text((SIX+C)/2, 2, 'unclassified', fontsize=10.4,
        color='#745D25', ha='center', va='center', zorder=4,
        bbox=dict(boxstyle='square,pad=.17', facecolor=COL['unknown'], edgecolor='none'))

# Endpoint 0 is included in every polynomial row; a left-aligned bar is adequate.
# A separated point records an actual rational certificate without suggesting
# polynomial feasibility or an interval of rational results shown on this chart.
ax.plot([0, XMAX], [0, 0], color=COL['grid'], linewidth=.9, zorder=0)
ax.plot(3, 0, marker='D', markersize=9, markerfacecolor=COL['purple'],
        markeredgecolor='white', markeredgewidth=.9, zorder=4)
ax.annotate(r'$b=3$', xy=(3, 0), xytext=(2.79, .18),
            fontsize=11, color=COL['purple'], ha='right', va='center',
            arrowprops=dict(arrowstyle='-', color=COL['purple'], linewidth=.8,
                            shrinkA=3, shrinkB=6))

legend = [
    Patch(facecolor=COL['feasible'], edgecolor='none', label='Proved feasible'),
    Patch(facecolor=COL['infeasible'], edgecolor='none', label='Proved infeasible'),
    Patch(facecolor=COL['unknown'], edgecolor=COL['unknown_edge'], hatch='////',
          linewidth=.5, label='Unclassified for sextics'),
]
fig.legend(handles=legend, loc='upper center', bbox_to_anchor=(.574, .326),
           ncol=3, frameon=False, fontsize=11, handlelength=2.1,
           handleheight=1.0, columnspacing=2.3, labelcolor=COL['ink'])

# Full values are separated from the close guides B2 and 9/4.
card_x = [.055, .285, .515, .745]
card_w = .205
card_titles = ['Quadratic endpoint', 'Quartic endpoint', 'Certified sextic point', 'All-degree boundary']
card_values = [
    r'$B_1\approx 1.90018909935$',
    r'$B_2\approx 2.12815353309$',
    r'$9/4=2.25$',
    r'$C=2\sqrt{2}\approx 2.828427$',
]
for x, title, value in zip(card_x, card_titles, card_values):
    fig.add_artist(Rectangle((x, .224), card_w, .069,
                             transform=fig.transFigure, facecolor=COL['card'],
                             edgecolor='none', zorder=0))
    fig.text(x+.012, .278, title, fontsize=10, color=COL['muted'], va='top')
    fig.text(x+.012, .247, value, fontsize=12.6, color=COL['ink'], va='center')

notes = [
    ('Endpoint markers', 'Open circles exclude strict endpoints; the filled circle includes the sextic point.'),
    ('Weak certificates', r'Quadratics include $B_1$ and quartics include $B_2$. The all-degree endpoint $C$ is excluded even in the weak case.'),
    ('Sextic limit', r'The exact boundary $B_3$ is unclassified; the strict certificate at $9/4$ proves $B_3>9/4$.'),
    ('Rational example', r'At $b=3$, a strict $C^1$ rational certificate exists, while every local real-analytic weak certificate is excluded.'),
]
for i, (label, value) in enumerate(notes):
    y = .191 - .031*i
    fig.text(.055, y, label, fontsize=10.4, weight='bold', color=COL['ink'], va='center')
    fig.text(.19, y, value, fontsize=10.35, color=COL['muted'], va='center')
fig.text(.055, .04,
         'Quartic classification and displayed pointwise sextic certificate: Lean; other analytic regions: written.',
         fontsize=9.2, color=COL['muted'], ha='left', va='center')

metadata = {
    'Title': 'Polynomial certificate regions at damping one',
    'Author': 'JD Jones / quartic-lyapunov',
    'Subject': 'Exact quadratic and quartic boundaries, certified sextics, and the all-degree polynomial cutoff',
    'Keywords': 'Lyapunov, polynomial, quartic, sextic, exact certificates',
}
fig.savefig(OUT/'certificate_regions.pdf', format='pdf', metadata=metadata)
fig.savefig(OUT/'certificate_regions.png', dpi=300,
            metadata={'Title': metadata['Title'], 'Description': metadata['Subject']})
plt.close(fig)
print('Created certificate_regions.pdf and certificate_regions.png')
