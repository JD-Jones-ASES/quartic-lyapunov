"""Fraction-only independent replay of the normalized quartic endpoint.

Run: python evidence/independent_replay.py

No SymPy and no import from endpoint_certificate. Polynomial arithmetic,
Euclidean inverses, Gaussian elimination and interval evaluation use only
fractions.Fraction. Checks remain active under python -O. The analytic root
uniqueness argument is reproduced by its exact shifted coefficients below.
"""

from fractions import Fraction as Q
import json


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def trim(p):
    p = list(p)
    while p and p[-1] == 0:
        p.pop()
    return p


def add(p, q):
    return trim([(p[i] if i < len(p) else Q(0))
                 + (q[i] if i < len(q) else Q(0))
                 for i in range(max(len(p), len(q)))])


def scale(p, c):
    return trim([a * c for a in p])


def multiply(p, q):
    if not p or not q:
        return []
    out = [Q(0)] * (len(p) + len(q) - 1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            out[i + j] += a * b
    return trim(out)


def divide(p, q):
    require(bool(q), "polynomial division by zero")
    remainder = trim(p)
    quotient = [Q(0)] * max(0, len(p) - len(q) + 1)
    while remainder and len(remainder) >= len(q):
        power = len(remainder) - len(q)
        coefficient = remainder[-1] / q[-1]
        quotient[power] += coefficient
        remainder = add(remainder, [Q(0)] * power + scale(q, -coefficient))
    return trim(quotient), remainder


MODULUS = [Q(x) for x in [100, 0, -200, 0, -103, 0, -134, 0,
                          125, 0, -92, 0, 16]]
LOWER = Q(2128153533088618627125605907329, 10**30)
UPPER = LOWER + Q(1, 10**30)


class A:
    """A polynomial residue modulo P(B^2), in increasing coefficient order."""

    def __init__(self, coefficients=()):
        if isinstance(coefficients, A):
            self.p = coefficients.p
        elif isinstance(coefficients, (int, Q)):
            self.p = tuple(trim([Q(coefficients)]))
        else:
            self.p = tuple(divide([Q(x) for x in coefficients], MODULUS)[1])

    def __bool__(self):
        return bool(self.p)

    def __eq__(self, other):
        return self.p == A(other).p

    def __add__(self, other):
        return A(add(self.p, A(other).p))

    __radd__ = __add__

    def __neg__(self):
        return A(scale(self.p, -1))

    def __sub__(self, other):
        return self + -A(other)

    def __rsub__(self, other):
        return A(other) + -self

    def __mul__(self, other):
        return A(multiply(self.p, A(other).p))

    __rmul__ = __mul__

    def inverse(self):
        require(bool(self), "inverse of zero")
        old_r, r = MODULUS[:], list(self.p)
        old_t, t = [], [Q(1)]
        while r:
            quotient, remainder = divide(old_r, r)
            old_r, r = r, remainder
            old_t, t = t, add(old_t, scale(multiply(quotient, t), -1))
        require(len(old_r) == 1, "residue not invertible modulo modulus")
        inverse = A(scale(old_t, 1 / old_r[0]))
        require(self * inverse == 1, "Euclidean inverse identity failed")
        return inverse

    def __truediv__(self, other):
        return self * A(other).inverse()

    def __rtruediv__(self, other):
        return A(other) * self.inverse()

    def __pow__(self, power):
        require(isinstance(power, int) and power >= 0, "invalid power")
        result, factor = A(1), self
        while power:
            if power % 2:
                result *= factor
            factor *= factor
            power //= 2
        return result


def evaluate(p, x):
    value = Q(0)
    for coefficient in reversed(p):
        value = value * x + coefficient
    return value


def enclosure(value):
    lower = upper = Q(0)
    for coefficient in reversed(A(value).p):
        endpoints = [lower * LOWER, lower * UPPER,
                     upper * LOWER, upper * UPPER]
        lower, upper = min(endpoints) + coefficient, max(endpoints) + coefficient
    return lower, upper


def positive(value):
    return enclosure(value)[0] > 0


def determinant(matrix):
    """Gaussian determinant, independent of the primary Leibniz determinant."""
    rows = [[A(x) for x in row] for row in matrix]
    result = A(1)
    for col in range(len(rows)):
        pivot = next((i for i in range(col, len(rows)) if rows[i][col]), None)
        if pivot is None:
            return A(0)
        if pivot != col:
            rows[col], rows[pivot] = rows[pivot], rows[col]
            result = -result
        divisor = rows[col][col]
        result *= divisor
        for i in range(col + 1, len(rows)):
            factor = rows[i][col] / divisor
            for j in range(col, len(rows)):
                rows[i][j] -= factor * rows[col][j]
    return result


def solve(matrix, rhs):
    """Cramer's rule: sizes are three and five; inverse identities are checked."""
    divisor = determinant(matrix)
    require(bool(divisor), "singular linear system")
    solution = []
    for col in range(len(matrix)):
        replaced = [list(row) for row in matrix]
        for i in range(len(matrix)):
            replaced[i][col] = rhs[i]
        solution.append(determinant(replaced) / divisor)
    require(all(sum((A(x) * y for x, y in zip(row, solution)), A(0)) == target
                for row, target in zip(matrix, rhs)), "linear solve failed")
    return solution


def minor_signs(matrix):
    return [positive(determinant([row[:k] for row in matrix[:k]]))
            for k in range(1, len(matrix) + 1)]


def replay(return_data=False):
    require(evaluate(MODULUS, LOWER) < 0 < evaluate(MODULUS, UPPER),
            "root bracket sign check failed")
    require(LOWER > 1, "root bracket not above one")
    p_u = MODULUS[::2]
    shifted = []
    # Horner composition P(1+v), independently identifying Descartes' signs.
    for coefficient in reversed(p_u):
        shifted = add(multiply(shifted, [Q(1), Q(1)]), [coefficient])
    require(shifted == list(map(Q, [-288, -672, -435, -234, -95, 4, 16])),
            "shifted polynomial identity failed")
    signs = [1 if x > 0 else -1 for x in reversed(shifted) if x]
    require(sum(signs[i] != signs[i+1] for i in range(len(signs)-1)) == 1,
            "Descartes uniqueness sign count failed")

    b, one, zero = A([0, 1]), A(1), A(0)
    u = b*b
    denominator = 16*u**4 - 32*u**3 + 93*u**2 - 65*u
    require(positive(denominator), "auxiliary denominator is not positive")
    c = (24*u**4 - 32*u**3 - 2*u**2 + 120*u - 50) / denominator
    re1, im1 = 1/b, c/b
    re2, im2 = (2+c-u)/u, (2*c-1)/u
    re3, im3 = (2+6*c-3*u)/(u*b), (2*u-6+c*(2-u))/(u*b)
    v = [(10+15*re1+6*re2+re3)/32,
         (5*im1+4*im2+im3)/32,
         (2+re1-2*re2-re3)/32,
         (3*im1-im3)/32,
         (2-re1-2*re2+re3)/32,
         (5*im1-4*im2+im3)/32,
         (10-15*re1+6*re2-re3)/32]
    require(v[0]+3*v[2]+3*v[4]+v[6] == 1, "moment normalization failed")
    hankel = [[v[i+j] for j in range(4)] for i in range(4)]
    require(minor_signs(hankel)[:3] == [True]*3, "H leading block not positive")
    require(determinant(hankel) == 0, "H determinant is nonzero")
    h = solve([row[:3] for row in hankel[:3]], [-v[i+3] for i in range(3)]) + [one]
    require(all(sum((v[i+j]*h[j] for j in range(4)), zero) == 0
                for i in range(4)), "cubic kernel identity failed")
    q = [sum((h[i]*h[k-i] for i in range(4) if 0 <= k-i < 4), zero)
         for k in range(7)]

    # Independently generate negative Lie derivative from monomial exponents.
    # f=(b-1)x^3+(-1-b)xy^2-x^2y-y^3;
    # g=x^3+xy^2+(b-1)x^2y+(-1-b)y^3.
    f_terms = [(3, 0, -1+b), (1, 2, -1-b), (2, 1, -one), (0, 3, -one)]
    g_terms = [(3, 0, one), (1, 2, one), (2, 1, -1+b), (0, 3, -1-b)]
    lie = [[zero for _ in range(5)] for _ in range(7)]
    for j in range(5):
        if 4-j:
            for _, ey, coefficient in f_terms:
                lie[j+ey][j] -= (4-j)*coefficient
        if j:
            for _, ey, coefficient in g_terms:
                lie[j-1+ey][j] -= j*coefficient
    require(all(sum((v[i]*lie[i][j] for i in range(7)), zero) == 0
                for j in range(5)), "dual annihilation failed")
    quartic = solve(lie[:5], q[:5])
    residual = [sum((lie[i][j]*quartic[j] for j in range(5)), zero)-q[i]
                for i in range(7)]
    require(all(x == 0 for x in residual), "seven Lie identities failed")
    gram = [[quartic[0], quartic[1]/2, one/40],
            [quartic[1]/2, quartic[2]-one/20, quartic[3]/2],
            [one/40, quartic[3]/2, quartic[4]]]
    require(minor_signs(gram) == [True]*3, "quartic Gram matrix not positive")
    require(gram[0][0] == quartic[0] and 2*gram[0][1] == quartic[1]
            and gram[1][1]+2*gram[0][2] == quartic[2]
            and 2*gram[1][2] == quartic[3] and gram[2][2] == quartic[4],
            "Gram reconstruction failed")
    for left, right in [(Q(-1, 5), Q(-19, 100)),
                        (Q(46, 100), Q(47, 100)),
                        (Q(118, 100), Q(119, 100))]:
        values = [sum((h[i]*x**i for i in range(4)), zero) for x in (left, right)]
        bounds = [enclosure(value) for value in values]
        require(bounds[0][1] < 0 < bounds[1][0]
                or bounds[1][1] < 0 < bounds[0][0], "cubic root sign check failed")

    # Negative controls: genuine identity and sign corruptions are rejected.
    require(sum((lie[0][j]*quartic[j] for j in range(5)), zero) != q[0]+1,
            "mutated square coefficient escaped detection")
    require(not positive(-gram[0][0]), "reversed positivity escaped detection")
    if return_data:
        return {"v": v, "h": h, "p": quartic, "H": hankel, "G": gram, "M": lie}
    return {"status": "INDEPENDENT_FRACTION_REPLAY_VERIFIED",
            "checks": "root bracket, Descartes shift, verified Euclidean inverses, "
                      "dual moments, H rank, cubic square, seven Lie equations, "
                      "quartic positive Gram, three real cubic roots, negative controls",
            "arithmetic": "Python Fraction only; no SymPy or primary replay import",
            "scope": "Exact algebraic certificate; no Lean verification or novelty claim"}


if __name__ == "__main__":
    print(json.dumps(replay(), indent=2))
