#!/usr/bin/env python3
"""Independent exact sextic certificate replay. Python standard library only.

Computes the actual negative Lie derivative from the two cubic field
components, then checks integer Gram identities and Sylvester minors.
No assertions, solver results, sampling, or floating point are proof steps.
"""
from fractions import Fraction as Q
from pathlib import Path
from copy import deepcopy
import json
import tempfile

P = [34, -296, 1247, -2850, 3606, -2358, 634]
G = [
    [34, -148, 218, -99],
    [-148, 811, -1326, 645],
    [218, -1326, 2316, -1179],
    [-99, 645, -1179, 634],
]
H = [
    [410, -350, -6768, 13622, -6402],
    [-350, 301, 5763, -11604, 5453],
    [-6768, 5763, 111827, -225043, 105770],
    [13622, -11604, -225043, 452900, -212865],
    [-6402, 5453, 105770, -212865, 100050],
]

SOS_ROWS = {
    'G': [
        ['1', '-74/17', '109/17', '-99/34'],
        ['0', '1', '-1282/567', '1213/945'],
        ['0', '0', '1', '-17079/18625'],
        ['0', '0', '0', '1'],
    ],
    'H': [
        ['1', '-35/41', '-3384/205', '6811/205', '-3201/205'],
        ['0', '1', '-597/91', '1006/91', '-71/13'],
        ['0', '0', '1', '-8807/4528', '4837/4528'],
        ['0', '0', '0', '1', '-35179/38297'],
        ['0', '0', '0', '0', '1'],
    ],
}
# These exact display strings identify the coefficient rows above. They are
# compared as data, never evaluated as Python or fed to a symbolic parser.
SOS_FORMS = {
    'G': [
        'x**3 - 74*x**2*y/17 + 109*x*y**2/17 - 99*y**3/34',
        'x**2*y - 1282*x*y**2/567 + 1213*y**3/945',
        'x*y**2 - 17079*y**3/18625',
        'y**3',
    ],
    'H': [
        'x**4 - 35*x**3*y/41 - 3384*x**2*y**2/205 + 6811*x*y**3/205 - 3201*y**4/205',
        'x**3*y - 597*x**2*y**2/91 + 1006*x*y**3/91 - 71*y**4/13',
        'x**2*y**2 - 8807*x*y**3/4528 + 4837*y**4/4528',
        'x*y**3 - 35179*y**4/38297',
        'y**4',
    ],
}

def require(condition, message):
    if not condition:
        raise RuntimeError(message)

def read_required_json(path):
    require(path.is_file(), f'Required JSON missing: {path.name}')
    return json.loads(path.read_text())

def rational(value):
    require(isinstance(value, str), 'Exact JSON rational must be a string')
    return Q(value)

def vector(values, size, label):
    require(isinstance(values, list) and len(values) == size, f'{label} dimension differs')
    return [rational(v) for v in values]

def matrix(values, size, label):
    require(isinstance(values, list) and len(values) == size, f'{label} dimension differs')
    return [vector(row, size, label) for row in values]

def determinant(matrix):
    rows = [[Q(x) for x in row] for row in matrix]
    n = len(rows)
    result = Q(1)
    for k in range(n):
        pivot = next((i for i in range(k, n) if rows[i][k]), None)
        if pivot is None:
            return Q(0)
        if pivot != k:
            rows[k], rows[pivot] = rows[pivot], rows[k]
            result = -result
        v = rows[k][k]
        result *= v
        for i in range(k + 1, n):
            factor = rows[i][k] / v
            for j in range(k + 1, n):
                rows[i][j] -= factor * rows[k][j]
            rows[i][k] = Q(0)
    return result

def gram_coefficients(matrix):
    n = len(matrix)
    require(all(len(row) == n for row in matrix), 'Gram matrix is not square')
    require(all(matrix[i][j] == matrix[j][i] for i in range(n) for j in range(n)),
            'Gram matrix is not symmetric')
    return [sum((Q(matrix[i][k-i]) for i in range(n) if 0 <= k-i < n), Q(0))
            for k in range(2*n-1)]

def negative_lie(coefficients, a, b):
    degree = len(coefficients) - 1
    # Ascending powers of y for each homogeneous cubic field component.
    fx = [b-a, Q(-1), -a-b, Q(-1)]
    fy = [Q(1), b-a, Q(1), -a-b]
    out = [Q(0) for _ in range(degree+3)]
    for k, coefficient in enumerate(coefficients):
        for j in range(4):
            if degree-k:
                out[k+j] -= Q(coefficient)*(degree-k)*fx[j]
            if k:
                out[k-1+j] -= Q(coefficient)*k*fy[j]
    return out

def verify_certificate(data):
    b = rational(data['b'])
    p = vector(data['p'], 7, 'p')
    q = vector(data['q'], 9, 'q')
    g = matrix(data['G'], 4, 'G')
    h = matrix(data['H'], 5, 'H')
    derivative = negative_lie(p, Q(1), b)
    require(q == derivative, 'Displayed derivative differs from actual Lie derivative')
    require(gram_coefficients(g) == p, 'V Gram identity failed')
    require(gram_coefficients(h) == derivative, 'Derivative Gram identity failed')
    for label, gram in [('G', g), ('H', h)]:
        minors = [determinant([row[:k] for row in gram[:k]])
                  for k in range(1, len(gram)+1)]
        require(all(m > 0 for m in minors), f'{label} is not positive definite by Sylvester')
        require(minors == vector(data[label+'_minors'], len(gram), label+' minors'),
                f'{label} recorded minors differ')
    # The certificate must prove the named example, not just some valid sextic.
    require(b == Q(9,4), 'JSON parameter differs from 9/4')
    require(p == list(map(Q, P)), 'JSON polynomial differs from the named example')
    require(g == G, 'JSON G differs from the displayed Gram matrix')
    require([[10*v for v in row] for row in h] == H,
            'JSON H differs from the displayed Gram matrix')
    expected = [Q(41), Q(-70), Q(-2647, 2), Q(3877), Q(15163, 2),
                Q(-43918), Q(66444), Q(-42573), Q(10005)]
    require(derivative == expected, 'Displayed derivative differs from actual Lie derivative')
    return g, h

def verify_sos(data, g, h):
    for label, target in [('G', g), ('H', [[10*v for v in row] for row in h])]:
        rows = [list(map(Q, row)) for row in SOS_ROWS[label]]
        n = len(rows)
        require(data[label]['forms'] == SOS_FORMS[label], f'{label} SOS forms differ')
        weights = vector(data[label]['weights'], n, label+' SOS weights')
        require(all(w > 0 for w in weights), f'{label} SOS weight is not positive')
        gram = [[sum((weights[k]*rows[k][i]*rows[k][j] for k in range(n)), Q(0))
                 for j in range(n)] for i in range(n)]
        require(gram == target, f'{label} SOS Gram identity failed')

def expect_rejection(label, operation, message):
    try:
        operation()
    except RuntimeError as error:
        require(message in str(error), f'{label}: unexpected rejection: {error}')
    else:
        raise RuntimeError(f'{label}: corrupted evidence was accepted')
    print(f'PASS control: {label}')

def negative_controls(certificate, sos):
    # Each mutant is independently copied from the valid certificate. These
    # tests exercise derivative, Gram and positivity checks, not only a hash.
    for label, key, index, message in [
        ('altered sextic coefficient rejected', 'p', 0, 'actual Lie derivative'),
        ('altered displayed derivative rejected', 'q', 0, 'actual Lie derivative'),
        ('altered primal Gram coefficient rejected', 'G', (0, 0), 'V Gram identity'),
        ('altered derivative Gram coefficient rejected', 'H', (0, 0), 'Derivative Gram identity'),
        ('altered recorded minor rejected', 'G_minors', 0, 'recorded minors differ'),
    ]:
        changed = deepcopy(certificate)
        if isinstance(index, tuple):
            i, j = index
            changed[key][i][j] = str(Q(changed[key][i][j])+1)
        else:
            changed[key][index] = str(Q(changed[key][index])+1)
        expect_rejection(label, lambda: verify_certificate(changed), message)
    changed = deepcopy(certificate)
    changed['b'] = str(Q(changed['b'])+Q(1,100))
    expect_rejection('altered field parameter rejected', lambda: verify_certificate(changed),
                     'actual Lie derivative')
    changed = deepcopy(certificate)
    changed['G'][0][2] = str(Q(changed['G'][0][2])+1000)
    changed['G'][2][0] = str(Q(changed['G'][2][0])+1000)
    changed['G'][1][1] = str(Q(changed['G'][1][1])-2000)
    expect_rejection('polynomial-preserving indefinite Gram rejected',
                     lambda: verify_certificate(changed), 'not positive definite')
    g, h = verify_certificate(certificate)
    changed_sos = deepcopy(sos)
    changed_sos['H']['weights'][0] = str(Q(changed_sos['H']['weights'][0])+1)
    expect_rejection('altered SOS weight rejected', lambda: verify_sos(changed_sos, g, h),
                     'H SOS Gram identity')
    changed_sos = deepcopy(sos)
    changed_sos['G']['forms'][0] += ' + y**3'
    expect_rejection('altered SOS form rejected', lambda: verify_sos(changed_sos, g, h),
                     'G SOS forms differ')
    with tempfile.TemporaryDirectory(prefix='quartic-sextic-control-') as directory:
        for name in ('sextic_certificate.json', 'sextic_sos.json'):
            expect_rejection(f'missing {name} rejected',
                             lambda: read_required_json(Path(directory)/name), 'Required JSON missing')

def verify():
    directory = Path(__file__).resolve().parent
    certificate = read_required_json(directory/'sextic_certificate.json')
    sos = read_required_json(directory/'sextic_sos.json')
    g, h = verify_certificate(certificate)
    verify_sos(sos, g, h)
    for label, matrix, expected_minors in [
        ('G', G, [34, 5670, 372500, 5858330]),
        ('H', H, [410, 910, 9056, 76594, 31770]),
    ]:
        minors = [determinant([row[:k] for row in matrix[:k]]) for k in range(1, len(matrix)+1)]
        require(minors == list(map(Q, expected_minors)), f'{label} minor replay failed')
        require(all(m > 0 for m in minors), f'{label} is not positive definite by Sylvester')
        print(f'PASS {label}: exact leading minors ' + ', '.join(map(str, minors)))
    print('PASS required JSON certificate, recorded minors and both exact SOS decompositions')
    negative_controls(certificate, sos)
    print('PASS actual Lie derivative, both Gram identities and deliberate corruption controls')
    print('CONCLUSION: V6 is positive definite and has strictly negative derivative at b=9/4.')

if __name__ == '__main__':
    verify()
