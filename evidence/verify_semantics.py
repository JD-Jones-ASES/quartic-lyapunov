#!/usr/bin/env python3
"""Independent exact check of mathematical semantics and a stronger Lie-rank identity.

Reads no project data and imports no project module. SymPy is used for exact
polynomial identities only. These finite checks do not certify Lean compilation
or the analytic maximum-principle argument.
"""
import json
import sympy as s


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def zero(expr, label):
    require(s.cancel(s.expand(expr)) == 0, label)


x,y,b,a,d,t,rho=s.symbols('x y b a d t rho', real=True)
u,v=s.symbols('u v', real=True)
sv=s.symbols('sv', real=True)
c=s.symbols('c0:5', real=True)
R=x*x+y*y
f=(-R+b*(x*x-y*y))*x-R*y
g=(-R+b*(x*x-y*y))*y+R*x
V=sum(c[j]*x**(4-j)*y**j for j in range(5))
lie=s.diff(V,x)*f+s.diff(V,y)*g
M=s.Matrix([[4-4*b,-1,0,0,0],[4,4-4*b,-2,0,0],
 [4+4*b,2,4-4*b,-3,0],[4,4+4*b,0,4-4*b,-4],
 [0,3,4+4*b,-2,4-4*b],[0,0,2,4+4*b,-4],[0,0,0,1,4+4*b]])
for j in range(7):
    zero(s.expand(-lie).coeff(x,6-j).coeff(y,j)-(M*s.Matrix(c))[j],
         'actual derivative coefficient '+str(j))
quarter=V.xreplace({x:-y,y:x})
quarter_lie=(s.diff(quarter,x)*f+s.diff(quarter,y)*g).subs(b,-b)
zero(quarter_lie-lie.xreplace({x:-y,y:x}), 'signed-parameter quarter-turn')


def factor(a,sv,rho):
    U=(a*(1+rho))**2+(sv*(1+rho)+1-rho)**2
    W=(sv*(1-rho)+1+rho)**2+(a*(1-rho))**2
    return U*x*x+8*a*rho*x*y+W*y*y


F=factor(a,sv,rho)
K=a+(sv+1)*s.I
L=a+(sv-1)*s.I
w=x+s.I*y
lin=K*s.conjugate(w)+rho*L*w
zero(F-s.expand_complex(lin*s.conjugate(lin)), 'contracted factor is squared norm')
zero(F.subs(rho,1)-4*((y+a*x)**2+sv**2*x*x), 'factor at radius one')
zero(F.subs(rho,0)-(a*a+(sv+1)**2)*R, 'factor at radius zero')
zero(K*s.conjugate(K)-L*s.conjugate(L)-4*sv, 'strict outer-factor norm gap')
# For h= rho L w/lin, its imaginary part is its numerator times the
# conjugate denominator divided by |lin|^2. Check after clearing that
# nonzero denominator; zero-freeness itself follows from the previous gap.
num=rho*L*w
im_numerator=s.im(s.expand(num*s.conjugate(lin)))
angular=y*s.diff(F,x)-x*s.diff(F,y)
zero(4*im_numerator-angular, 'angular/logarithmic derivative sign and factor four')
G=factor(d,t,rho)
P=F*G
lieP=s.diff(P,x)*f.subs(b,rho*b)+s.diff(P,y)*g.subs(b,rho*b)
angularG=y*s.diff(G,x)-x*s.diff(G,y)
zero(-lieP-(4*(R-rho*b*(x*x-y*y))*F*G+R*(angular*G+angularG*F)),
     'contracted quartic actual Lie identity')

phi=lambda z:16*z**6-92*z**5+125*z**4-134*z**3-103*z**2-200*z+100
S,T=s.symbols('S T', real=True)
k=(16*S**4*T**4*(S+T)+4*S**4*T**4+234*S**3*T**3+
   435*S**2*T**2*(S+T)+672*S*T*(S*S+S*T+T*T)+
   288*(S**3+S*S*T+S*T*T+T**3))
zero((S-T)*k-(T**4*phi(S+1)-S**4*phi(T+1)), 'root uniqueness identity')
expected=262144*(48*b**10+544*b**8+1799*b**6+1897*b**4+1205*b*b+300)
zero((M.T*M).det()-expected, 'full Lie-map Gram determinant')
top=-256*(4*b**5-20*b**4+35*b**3-35*b*b+25*b-10)
bottom=top.subs(b,-b)
zero(M[:5,:].det()-top, 'first five rows determinant')
zero(M[2:,:].det()-bottom, 'last five rows determinant')
zero(top+bottom-2560*(4*b**4+7*b*b+2), 'positive sum of two maximal minors')

print(json.dumps({
 'status':'INDEPENDENT_SEMANTIC_IDENTITIES_VERIFIED',
 'checks':['all seven actual Lie coefficients','quarter-turn conjugacy',
 'contracted factor squared norm','factor endpoints zero and one',
 'outer-factor gap','angular logarithmic sign','contracted actual Lie identity',
 'root uniqueness identity','full-rank identity for every real parameter',
 'two maximal minors with strictly positive sum'],
 'gram_determinant':str(expected),
 'sum_of_first_and_last_maximal_minors':'2560*(4*b**4+7*b**2+2)',
 'all_parameter_rank_conclusion':'M(b) has rank five for every real b, because each displayed even-power term is nonnegative and the constant is positive.',
 'scope':'Exact symbolic identities; not Lean or independent-kernel verification.'
},indent=2))
