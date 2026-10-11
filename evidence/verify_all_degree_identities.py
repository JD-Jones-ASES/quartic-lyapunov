#!/usr/bin/env python3
"""Exact finite algebra supporting the written all-degree theorem.

This script is NOT a verification of the analytic existence proof.
It checks derivative signs, first coefficients, moment cancellation,
optimization, quantile-bound algebra, and the rational b=3 example.
All proof checks use exact symbolic arithmetic and remain active under -O.
"""
import sympy as s


def zero(expression, label):
    value = s.simplify(s.expand_complex(expression))
    if value != 0:
        value = s.factor(value)
    if value != 0:
        raise RuntimeError(f"{label}: nonzero remainder {value}")
    print(f"PASS {label}")


u, v, a, t, r, N = s.symbols('u v a t r N', positive=True, real=True)
z = s.symbols('z')
norm = s.sqrt(u*u+v*v)
gamma = (u-s.I*v)/norm
q = v*v-u*u+2*s.I*u*v*(1+gamma*z)/(1-gamma*z)
zero(gamma*s.conjugate(gamma)-1, 'quadrant rotation has unit modulus')
zero(q.subs(z, 0)-(v+s.I*u)**2, 'quadrant-map value at zero')
zero(s.diff(q,z).subs(z,0)/(2*(v+s.I*u))-2*u*v/norm,
     'quadrant-map first derivative has the required positive real value')

# Exact real/imaginary cancellation for arbitrary complex moments/coefficient.
cr, ci, mr, mi, b, delta = s.symbols('cr ci mr mi b delta', real=True)
coefficient, moment = cr+s.I*ci, mr+s.I*mi
other = s.I*moment-b*delta/2
zero(s.im(coefficient*moment)+s.re(coefficient*other)+b*delta*cr/2,
     'dual moment cancellation with reversed-angle moment convention')

J=(t+a)*s.sqrt(1+t*t)/t
zero(s.diff(J,t)-(t**3-a)/(t*t*s.sqrt(1+t*t)),
     'quadrant bound derivative and unique minimizer')
zero(J.subs(a,t**3)-(1+t*t)**s.Rational(3,2),
     'minimum is (1+a^(2/3))^(3/2)')

err=2*s.pi*r/(N*(1-r*r))
margin=a*(1-r)/(1+r)
zero(err.subs(N,4*s.pi*r/(a*(1-r)**2))-margin/2,
     'quantile degree bound retains half the Poisson margin')

x,y=s.symbols('x y', real=True)
R=x*x+y*y
A=R-x*y
D=R+x*y
W=R*(A/D)**3
fx=2*x**3-x*x*y-4*x*y*y-y**3
fy=x**3+2*x*x*y+x*y*y-4*y**3
E=R*(x*x-y*y)**2+6*x**4*y*y
numerator=s.together(-s.diff(W,x)*fx-s.diff(W,y)*fy-2*R*A*A*E/D**4).as_numer_denom()[0]
zero(numerator, 'actual rational Lie derivative at b=3')
zero(A*D-(x**4+x*x*y*y+y**4), 'rational denominator positivity identity')
zero(E-(x**6+5*x**4*y*y-x*x*y**4+y**6), 'positive derivative numerator identity')
if not s.Integer(3)**2 > 8:
    raise RuntimeError('integer example is not beyond the all-degree boundary')
print('PASS b=3 is strictly beyond 2*sqrt(2) by exact integer comparison')
print('Finite algebra passed. The all-degree classification remains a written analytic theorem, not a Lean theorem.')
