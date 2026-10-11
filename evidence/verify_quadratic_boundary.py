#!/usr/bin/env python3
"""Exact symbolic checks for the written general-damping quadratic theorem.

Uses SymPy only. All identities are reduced over Q[c,A,B] modulo
A^2-(2c+1) and B^2-2c. No floating point is used in the checks.
"""
import sympy as s

c, A, B, x, y = s.symbols('c A B x y', real=True)
a = c*A
b = (c+1)*B
R = x*x+y*y
U = ((c+1)*A-c*B)*x*x - 2*A*B*x*y + ((c+1)*A+c*B)*y*y
h = (A-B)*x*x+2*x*y-(A+B)*y*y
f1=(-a*R+b*(x*x-y*y))*x-R*y
f2=(-a*R+b*(x*x-y*y))*y+R*x
basis = s.groebner([A*A-(2*c+1),B*B-2*c], A,B,c,x,y)

def require_zero(expr, name):
    numerator = s.cancel(expr).as_numer_denom()[0]
    remainder = basis.reduce(s.expand(numerator))[1]
    if remainder != 0:
        raise RuntimeError(f'{name}: nonzero exact remainder {remainder}')
    print(f'PASS {name}')

require_zero(-s.diff(U,x)*f1-s.diff(U,y)*f2-2*c*(c+1)*h*h,
             'actual Lie derivative equals the positive cubic-parameter multiple of h squared')
require_zero(((c+1)*A-c*B)*((c+1)*A+c*B)-A*A*B*B-(c+1)**2,
             'quadratic determinant equals (c+1)^2')

# Real and imaginary parts of the first two equal-atom moments.
m1r=A*B/(2*(c+1));m1i=B/(2*(c+1))
m2r=c*(c-1)/(c+1)**2;m2i=A*(c-1)/(c+1)**2
require_zero(b*m1r-a, 'zeroth dual recurrence')
require_zero(b*m1i-c, 'first moment imaginary part')
require_zero(b*(m2r+1)-2*(a*m1r+m1i), 'first dual recurrence real part')
require_zero(b*m2i-2*(a*m1i-m1r), 'first dual recurrence imaginary part')
# Compute the second moments directly from the stated equal-atom angles.
cp2=A*A/(2*(c+1));sp2=1/(2*(c+1))
cq2=c/(c+1);sq2=1/(c+1)
require_zero((cp2-sp2)*(cq2-sq2)-m2r, 'equal-atom second cosine moment')
require_zero(A/(c+1)*(cq2-sq2)-m2i, 'equal-atom second sine moment')

u=2*c*(c+1)**2;a2=c*c*(2*c+1)
require_zero(4*u**3+(1-12*a2)*u**2+(12*a2*a2-20*a2)*u-4*a2*(a2+1)**2,
             'cubic elimination identity')
print('All finite exact checks passed. Written analytic proof and Lean coverage are distinct.')
