"""Exact algebraic endpoint replay for the damping-one quartic contract.

Run: python evidence/endpoint_certificate.py

All checks use rational arithmetic in Q[B] and rational interval bounds,
and remain active under Python optimization.
Decimal output is descriptive only.  See docs/Endpoint.md for the mathematical
meaning; this is a finite certificate replay, not a numerical SDP census.
"""

from fractions import Fraction
from itertools import permutations
import json

import sympy as sp


B_SYMBOL = sp.Symbol("B")
U_SYMBOL = sp.Symbol("u")
P_U = sp.Poly(
    16 * U_SYMBOL**6 - 92 * U_SYMBOL**5 + 125 * U_SYMBOL**4
    - 134 * U_SYMBOL**3 - 103 * U_SYMBOL**2 - 200 * U_SYMBOL + 100,
    U_SYMBOL,
)
F_B = sp.Poly(P_U.as_expr().subs(U_SYMBOL, B_SYMBOL**2), B_SYMBOL)
B_LO = Fraction(2128153533088618627125605907329, 10**30)
B_HI = B_LO + Fraction(1, 10**30)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def determinant(matrix, zero):
    """Small-matrix Leibniz determinant, independent of symbolic Matrix det."""
    total = zero
    for perm in permutations(range(len(matrix))):
        inversions = sum(perm[i] > perm[j] for i in range(len(perm))
                         for j in range(i + 1, len(perm)))
        term = (-1) ** inversions
        for i, j in enumerate(perm):
            term *= matrix[i][j]
        total += term
    return total


def solve(matrix, rhs):
    """Exact Gaussian elimination with nonzero pivot checks."""
    rows = [list(row) + [rhs[i]] for i, row in enumerate(matrix)]
    size = len(rows)
    for col in range(size):
        pivot = next(i for i in range(col, size) if rows[i][col])
        rows[col], rows[pivot] = rows[pivot], rows[col]
        divisor = rows[col][col]
        rows[col] = [entry / divisor for entry in rows[col]]
        for i in range(size):
            if i != col:
                multiple = rows[i][col]
                rows[i] = [x - multiple * y for x, y in zip(rows[i], rows[col])]
    return [row[-1] for row in rows]


def interval_add(left, right):
    return left[0] + right[0], left[1] + right[1]


def interval_mul(left, right):
    products = [x * y for x in left for y in right]
    return min(products), max(products)


def interval_value(element):
    """Horner enclosure of a reduced field element on the isolating interval."""
    value = (Fraction(0), Fraction(0))
    for coefficient in element.to_list():
        rational = Fraction(int(coefficient.numerator), int(coefficient.denominator))
        value = interval_add(interval_mul(value, (B_LO, B_HI)), (rational, rational))
    return value


def positive(element):
    return interval_value(element)[0] > 0


def in_range(element, lower, upper):
    enclosed_lower, enclosed_upper = interval_value(element)
    return lower < enclosed_lower <= enclosed_upper < upper


def leading_minors(matrix, zero):
    return [determinant([row[:n] for row in matrix[:n]], zero)
            for n in range(1, len(matrix) + 1)]


def decimal(element):
    lower, upper = interval_value(element)
    return float((lower + upper) / 2)


def replay():
    # The larger positive B is unambiguous and lies in this rational interval.
    require(P_U.count_roots(1, sp.oo) == 1, "R must have exactly one root above one")
    require(F_B.count_roots(sp.Rational(B_LO.numerator, B_LO.denominator),
                           sp.Rational(B_HI.numerator, B_HI.denominator)) == 1,
            "B isolating interval must contain exactly one root")
    require(F_B.is_irreducible, "R(B^2) must be irreducible for field arithmetic")
    field = sp.QQ.algebraic_field((F_B, B_SYMBOL))
    b, one, zero = field.unit, field.one, field.zero
    u = b * b
    numerator = 24*u**4 - 32*u**3 - 2*u**2 + 120*u - 50
    denominator = 16*u**4 - 32*u**3 + 93*u**2 - 65*u
    require(positive(denominator), "Dual parameter denominator must be positive")
    c = numerator / denominator
    t = c / b

    # Moments of cos(k theta), sin(k theta), where theta=2*polar_angle.
    re1, im1 = one/b, t
    re2, im2 = (2*re1 + im1)/b - one, (2*im1 - re1)/b
    re3, im3 = (2*re2 + 2*im2)/b - re1, (2*im2 - 2*re2)/b - im1
    # v[k] = ell(x^(6-k) y^k), obtained by elementary trig identities.
    v = [
        (10 + 15*re1 + 6*re2 + re3)/32,
        (5*im1 + 4*im2 + im3)/32,
        (2 + re1 - 2*re2 - re3)/32,
        (3*im1 - im3)/32,
        (2 - re1 - 2*re2 + re3)/32,
        (5*im1 - 4*im2 + im3)/32,
        (10 - 15*re1 + 6*re2 - re3)/32,
    ]
    hankel = [[v[i+j] for j in range(4)] for i in range(4)]
    hankel_minors = leading_minors(hankel, zero)
    require(all(positive(minor) for minor in hankel_minors[:3]),
            "Hankel leading block must be positive definite")
    require(hankel_minors[3] == zero, "Full Hankel determinant must vanish exactly")
    require(all(in_range(value, Fraction(lower, scale), Fraction(upper, scale))
                for value, (lower, upper, scale) in zip(hankel_minors, [
                    (476, 477, 1000), (25, 26, 1000), (34, 35, 100000)])),
            "Hankel leading minors must satisfy the documented rational bounds")
    require(v[0] + 3*v[2] + 3*v[4] + v[6] == one,
            "Dual functional must have the stated normalization")

    # h is the unique monic cubic in ker(H); q=h^2.
    h = solve([row[:3] for row in hankel[:3]], [-row[3] for row in hankel[:3]]) + [one]
    require(all(sum((hankel[i][j]*h[j] for j in range(4)), zero) == zero
                for i in range(4)), "Cubic vector must lie in the full Hankel kernel")
    q = [sum((h[i]*h[k-i] for i in range(4) if 0 <= k-i < 4), zero)
         for k in range(7)]
    lie_map = [
        [4-4*b, -one, zero, zero, zero],
        [4*one, 4-4*b, -2*one, zero, zero],
        [4+4*b, 2*one, 4-4*b, -3*one, zero],
        [4*one, 4+4*b, zero, 4-4*b, -4*one],
        [zero, 3*one, 4+4*b, -2*one, 4-4*b],
        [zero, zero, 2*one, 4+4*b, -4*one],
        [zero, zero, zero, one, 4+4*b],
    ]
    require(all(sum((v[i]*lie_map[i][j] for i in range(7)), zero) == zero
                for j in range(5)), "Dual functional must annihilate every Lie column")
    quartic = solve(lie_map[:5], q[:5])
    require(all(sum((lie_map[i][j]*quartic[j] for j in range(5)), zero) == q[i]
                for i in range(7)), "All seven Lie coefficients must equal the cubic square")

    # A strictly positive Gram certificate on (x^2,xy,y^2).
    gram = [
        [quartic[0], quartic[1]/2, one/40],
        [quartic[1]/2, quartic[2]-one/20, quartic[3]/2],
        [one/40, quartic[3]/2, quartic[4]],
    ]
    gram_minors = leading_minors(gram, zero)
    require(all(positive(minor) for minor in gram_minors),
            "Quartic Gram matrix must be positive definite")
    require(all(in_range(value, Fraction(lower, scale), Fraction(upper, scale))
                for value, (lower, upper, scale) in zip(gram_minors, [
                    (18, 19, 1000), (96, 97, 100000), (102, 103, 10000000)])),
            "Quartic Gram minors must satisfy the documented rational bounds")

    # Three sign changes isolate all roots of h(1,z); no complex-root test.
    root_intervals = [(-sp.Rational(1, 5), -sp.Rational(19, 100)),
                      (sp.Rational(46, 100), sp.Rational(47, 100)),
                      (sp.Rational(118, 100), sp.Rational(119, 100))]
    signs = []
    for lower, upper in root_intervals:
        values = [sum((h[i] * field.convert(endpoint)**i for i in range(4)), zero)
                  for endpoint in (lower, upper)]
        bounds = [interval_value(value) for value in values]
        require(bounds[0][1] < 0 < bounds[1][0]
                or bounds[1][1] < 0 < bounds[0][0],
                "Cubic must change sign across each documented isolating interval")
        signs.append([1 if bound[0] > 0 else -1 for bound in bounds])

    return {
        "status": "EXACT_ENDPOINT_CERTIFICATE_VERIFIED",
        "B_interval": [str(B_LO), str(B_HI)],
        "B_approx": float((B_LO+B_HI)/2),
        "t_approx": decimal(t),
        "h_coefficients_approx": [decimal(x) for x in h],
        "quartic_coefficients_approx": [decimal(x) for x in quartic],
        "H_leading_minors_approx": [decimal(x) for x in hankel_minors],
        "P_Gram_leading_minors_approx": [decimal(x) for x in gram_minors],
        "cubic_root_endpoint_signs": signs,
        "scope": "Exact endpoint primal/dual certificates; no Lean verification or novelty claim.",
    }


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2))
