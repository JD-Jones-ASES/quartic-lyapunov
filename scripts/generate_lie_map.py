#!/usr/bin/env python3
"""Generate the explicit derivative coefficient map and adjugate identities."""
from pathlib import Path
import sympy as s
ROOT=Path(__file__).resolve().parents[1]
b=s.symbols('b')
M=s.Matrix([[4-4*b,-1,0,0,0],[4,4-4*b,-2,0,0],[4+4*b,2,4-4*b,-3,0],[4,4+4*b,0,4-4*b,-4],[0,3,4+4*b,-2,4-4*b],[0,0,2,4+4*b,-4],[0,0,0,1,4+4*b]])
co=['((4-4*b)*c 0-c 1)','(4*c 0+(4-4*b)*c 1-2*c 2)','((4+4*b)*c 0+2*c 1+(4-4*b)*c 2-3*c 3)','(4*c 0+(4+4*b)*c 1+(4-4*b)*c 3-4*c 4)','(3*c 1+(4+4*b)*c 2-2*c 3+(4-4*b)*c 4)','(2*c 2+(4+4*b)*c 3-4*c 4)','(c 3+(4+4*b)*c 4)']
text='''module
public import QuarticLyapunov.Sextic

/-! The full derivative map and its injectivity at the algebraic endpoint. -/
@[expose] public noncomputable section
namespace QuarticLyapunov
open Polynomial

def negativeCoefficients (b : ℝ) (c : Coeff) : Fin 7 → ℝ :=
  !['''+',\n    '.join(co)+''']

def sexticPolynomial (b : ℝ) (c : Coeff) : ℝ[X] :=
  '''+' +\n    '.join(f'C (negativeCoefficients b c {i})*X^{i}' for i in range(7))+'''

theorem sextic_eval (b : ℝ) (c : Coeff) (z : ℝ) :
    (sexticPolynomial b c).eval z = -lie b c 1 z := by
  rw [lie_eq]
  simp [sexticPolynomial, negativeCoefficients, field, gradient]; ring

theorem sextic_degree (b : ℝ) (c : Coeff) :
    (sexticPolynomial b c).natDegree ≤ 6 := by
  unfold sexticPolynomial
  compute_degree!

theorem sextic_coeff (b : ℝ) (c : Coeff) (i : Fin 7) :
    (sexticPolynomial b c).coeff i = negativeCoefficients b c i := by
  fin_cases i <;> simp [sexticPolynomial]
'''
adj=M[:5,:].adjugate()
def poly(expr):
 return '('+str(s.expand(expr)).replace('**','^').replace('b','boundary')+')'
for i in range(5):
 terms=[f'{poly(adj[i,j])}*negativeCoefficients boundary c {j}' for j in range(5)]
 text+=f'\ntheorem rank_identity{i} (c : Coeff) : Endpoint.detM*c {i} =\n    '+' +\n    '.join(terms)+''' := by
  simp [Endpoint.detM, negativeCoefficients]; ring
'''
text+='''
theorem negativeCoefficients_injective : Function.Injective (negativeCoefficients boundary) := by
  intro c d he
  have hd : Endpoint.detM ≠ 0 := ne_of_gt Endpoint.detM_pos
  funext i
  fin_cases i
'''
for i in range(5):text+=f'''  · have hc := rank_identity{i} c
    have hh := rank_identity{i} d
    rw [he] at hc
    exact (mul_left_cancel₀ hd) (hc.trans hh.symm)
'''
text+='''
theorem negativeCoefficients_smul (k b : ℝ) (c : Coeff) :
    negativeCoefficients b (fun i => k*c i) = fun i => k*negativeCoefficients b c i := by
  funext i
  fin_cases i <;> simp [negativeCoefficients] <;> ring

end QuarticLyapunov
'''
(ROOT/'QuarticLyapunov/LieMap.lean').write_text(text)
