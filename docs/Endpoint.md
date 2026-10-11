# Exact quartic endpoint certificate

This file supplies the finite algebraic endpoint used in [PROOF.md](../Proof.md).
It concerns only damping one, nonnegative parameter, and homogeneous quartics.
The replay uses exact rational arithmetic; the decimals below are orientation.

## Algebraic parameter

Let

\[
 R(u)=16u^6-92u^5+125u^4-134u^3-103u^2-200u+100.
\]

There is exactly one root \(u_*>1\). For example, the coefficients of
\(R(v+1)=16v^6+4v^5-95v^4-234v^3-435v^2-672v-288\)
have one sign change, and the polynomial changes sign between \(9/2\)
and \(23/5\). Set \(B=\sqrt{u_*}\). Its isolating interval is

\[
 \frac{2128153533088618627125605907329}{10^{30}}
 <B<
 \frac{2128153533088618627125605907330}{10^{30}}.
\]

Thus \(B\approx2.128153533088618627125605907330\). Define

\[
 c=\frac{24u_*^4-32u_*^3-2u_*^2+120u_*-50}
 {16u_*^4-32u_*^3+93u_*^2-65u_*},\qquad t=c/B.
\]

The denominator is positive. All subsequent entries belong to
\(\mathbb Q(B)\), with exact reduction modulo \(R(B^2)\).

## Real moment matrix

Define six real quantities

\[
 a_1=1/B,\quad d_1=t,\qquad
 a_2=(2a_1+d_1)/B-1,\quad d_2=(2d_1-a_1)/B,
\]
\[
 a_3=(2a_2+2d_2)/B-a_1,\qquad
 d_3=(2d_2-2a_2)/B-d_1.
\]

Define the linear functional \(\ell\) on homogeneous sextics by
\(\ell(x^{6-k}y^k)=v_k\), where

\[
 32(v_0,\ldots,v_6)=
 (10+15a_1+6a_2+a_3,\;
 5d_1+4d_2+d_3,\;
 2+a_1-2a_2-a_3,\;
 3d_1-d_3,\;
 2-a_1-2a_2+a_3,\;
 5d_1-4d_2+d_3,\;
 10-15a_1+6a_2-a_3).
\]

Let \(H=(v_{i+j})_{0\le i,j\le3}\), and let \(A\) be its upper left
\(3\times3\) block. The three leading principal minors of \(H\) lie in
the following rational intervals:

| Minor | Exact enclosing interval |
| --- | --- |
| 1 | \((476/1000,477/1000)\) |
| 2 | \((25/1000,26/1000)\) |
| 3 | \((34/100000,35/100000)\) |

Also \(\det H=0\). Consequently \(A\) is positive definite and \(H\)
is positive semidefinite of rank three, by the Schur complement. The
normalization is \(v_0+3v_2+3v_4+v_6=1\).

## Exact primal construction

Write the vector field as in the contract and let \(M\) carry the
coefficients of a quartic to those of its **negative** Lie derivative:

\[
 M=\begin{pmatrix}
 4-4B&-1&0&0&0\\
 4&4-4B&-2&0&0\\
 4+4B&2&4-4B&-3&0\\
 4&4+4B&0&4-4B&-4\\
 0&3&4+4B&-2&4-4B\\
 0&0&2&4+4B&-4\\
 0&0&0&1&4+4B
 \end{pmatrix}.
\]

The exact identity \(v^TM=0\) holds. Put

\[
 (h_0,h_1,h_2)^T=-A^{-1}(v_3,v_4,v_5)^T,\qquad h_3=1,
\]
\[
 h(x,y)=\sum_{j=0}^3h_jx^{3-j}y^j,\qquad
 q_k=\sum_{i+j=k}h_i h_j.
\]

Then \(Hh=0\). Let \(M_0\) be the first five rows of \(M\), and define
\(p=M_0^{-1}(q_0,\ldots,q_4)^T\). Both inverses exist. Exact field
arithmetic verifies **all seven** entries of

\[
 Mp=(q_0,\ldots,q_6)^T.
\]

Thus for \(P_*(x,y)=\sum_{j=0}^4p_jx^{4-j}y^j\),

\[
 -\nabla P_*\cdot f_B=h(x,y)^2.
\]

The approximate coefficient vectors are

```text
h = (0.1070705229598924, 0.2221255737236934, -1.446080986961182, 1)
p = (0.0181350117459670, -0.0933004071821697, 0.2230012901529149,
     -0.2352258863493871, 0.0987184510993113).
```

Positivity of the quartic is certified algebraically. In the basis
\(z=(x^2,xy,y^2)^T\), one has \(P_*=z^TGz\), with

\[
 G=\begin{pmatrix}
 p_0&p_1/2&1/40\\
 p_1/2&p_2-1/20&p_3/2\\
 1/40&p_3/2&p_4
 \end{pmatrix}.
\]

Its leading principal minors lie respectively in
\((18/1000,19/1000)\), \((96/100000,97/100000)\), and
\((102/10^7,103/10^7)\). Hence \(G\) is positive definite, and
\(P_*(x,y)>0\) whenever \((x,y)\ne(0,0)\).

## An elementary positive dual functional

The monic cubic \(h(1,z)\) has a sign change in each of

\[
 (-1/5,-19/100),\quad (46/100,47/100),\quad (118/100,119/100).
\]

Its signs at those pairs of endpoints are respectively \((-1,+1)\),
\((+1,-1)\), and \((-1,+1)\). Thus it has exactly three distinct real
roots \(r_1,r_2,r_3\). This conclusion uses exact rational enclosures,
the intermediate value theorem, and the degree bound, not a numerical
root finder.

Identify \(\ell\) with the functional on univariate polynomials of degree
at most six satisfying \(\ell(z^k)=v_k\). The identity \(Hh=0\) says
\(\ell(z^j h(1,z))=0\) for \(0\le j\le3\). Let \(L_i\) be the
quadratic Lagrange polynomial with \(L_i(r_j)=\delta_{ij}\). Define
\(w_i=\ell(L_i^2)\). Since \(A\) is positive definite and \(L_i\ne0\),
each \(w_i>0\). Also \(L_i^2-L_i\) is divisible by \(h(1,z)\), so
\(w_i=\ell(L_i)\). Dividing any polynomial of degree at most six by the
monic cubic gives

\[
 \ell(Q)=\sum_{i=1}^3w_iQ(r_i).
\]

For homogeneous sextics this reads
\(\ell(Q)=\sum_iw_iQ(1,r_i)\). In particular \(\ell(Q)>0\) for every
strictly positive homogeneous sextic. Since \(v^TM=0\), a quartic cannot
have a strictly negative Lie derivative at \(b=B\).

There is also an equality classification. If a positive definite quartic
has a weakly negative Lie derivative at \(B\), its nonnegative sextic
\(Q=-\nabla P\cdot f_B\) vanishes at all three \((1,r_i)\). Each root
of \(Q(1,z)\) has even multiplicity. Thus \(Q=k h^2\) for \(k\ge0\).
The rank-five matrix \(M\) then implies \(P=kP_*\), and positive
definiteness forces \(k>0\). The weak endpoint certificate is therefore
unique up to positive scaling.

## Verification

Run `python evidence/endpoint_certificate.py` and `python evidence/independent_replay.py`. The finite replays use exact rational arithmetic. Current Lean coverage is recorded in [VERIFICATION.md](../VERIFICATION.md).
