module
public import QuarticLyapunov.LieMap

/-! The weak endpoint coefficient vectors form exactly one positive ray. -/
@[expose] public noncomputable section
namespace QuarticLyapunov
open Polynomial

def cubicPolynomial : ℝ[X] := C Endpoint.h0 + C Endpoint.h1*X + C Endpoint.h2*X^2+X^3

theorem cubicPolynomial_eval (z : ℝ) : cubicPolynomial.eval z = endpointCubic 1 z := by
  simp [cubicPolynomial,endpointCubic,Endpoint.h3]

theorem cubicPolynomial_factor (a : EndpointAtoms) :
    cubicPolynomial = (X-C a.r)*(X-C a.s)*(X-C a.t) := by
  have er : Endpoint.h0+Endpoint.h1*a.r+Endpoint.h2*a.r^2+a.r^3=0 := by
    simpa [endpointCubic,Endpoint.h3] using a.hr
  have es : Endpoint.h0+Endpoint.h1*a.s+Endpoint.h2*a.s^2+a.s^3=0 := by
    simpa [endpointCubic,Endpoint.h3] using a.hs
  have et : Endpoint.h0+Endpoint.h1*a.t+Endpoint.h2*a.t^2+a.t^3=0 := by
    simpa [endpointCubic,Endpoint.h3] using a.ht
  have he := cubic_vieta (ne_of_lt a.hrs) (ne_of_lt (a.hrs.trans a.hst))
    (ne_of_lt a.hst) er es et
  unfold cubicPolynomial
  rw [he.1,he.2.1,he.2.2]
  simp only [map_neg,map_add,map_mul]
  ring

theorem endpoint_sextic : sexticPolynomial boundary endpointCoefficients = cubicPolynomial^2 := by
  apply Polynomial.funext
  intro z
  rw [sextic_eval,endpoint_negative_lie_square,eval_pow,cubicPolynomial_eval]

theorem endpoint_unique {c : Coeff} (hc : WeakQuarticCertificate boundary c) :
    ∃ k : ℝ, 0 < k ∧ c = fun i => k*endpointCoefficients i := by
  let a := endpointAtoms
  let q := sexticPolynomial boundary c
  have hn : ∀ z : ℝ, 0 ≤ q.eval z := by
    intro z
    dsimp [q]
    rw [sextic_eval]
    exact neg_nonneg.mpr (hc.2 1 z (Or.inl one_ne_zero))
  have hsum : a.w₁*q.eval a.r+a.w₂*q.eval a.s+a.w₃*q.eval a.t=0 := by
    simp only [q,sextic_eval]
    exact atomic_dual_annihilates a c
  have hn1 := mul_nonneg a.hw₁.le (hn a.r)
  have hn2 := mul_nonneg a.hw₂.le (hn a.s)
  have hn3 := mul_nonneg a.hw₃.le (hn a.t)
  have hr : q.eval a.r=0 := by
    have hh : a.w₁*q.eval a.r=0 := by linarith
    exact (mul_eq_zero.mp hh).resolve_left (ne_of_gt a.hw₁)
  have hs : q.eval a.s=0 := by
    have hh : a.w₂*q.eval a.s=0 := by linarith
    exact (mul_eq_zero.mp hh).resolve_left (ne_of_gt a.hw₂)
  have ht : q.eval a.t=0 := by
    have hh : a.w₃*q.eval a.t=0 := by linarith
    exact (mul_eq_zero.mp hh).resolve_left (ne_of_gt a.hw₃)
  have hpoly := nonnegative_sextic_three_roots q hn (sextic_degree boundary c)
    a.r a.s a.t (ne_of_lt a.hrs) (ne_of_lt (a.hrs.trans a.hst)) (ne_of_lt a.hst) hr hs ht
  rw [← cubicPolynomial_factor a, ← endpoint_sextic] at hpoly
  have hcoeff : c = fun i => q.leadingCoeff*endpointCoefficients i := by
    apply negativeCoefficients_injective
    rw [negativeCoefficients_smul]
    funext i
    have hh := congrArg (fun p : ℝ[X] => p.coeff i) hpoly
    simpa only [q,sextic_coeff, coeff_mul_C, mul_comm] using hh
  refine ⟨q.leadingCoeff, ?_, hcoeff⟩
  have hp := hc.1 1 0 (Or.inl one_ne_zero)
  have hep := endpoint_positive 1 0 (Or.inl one_ne_zero)
  rw [hcoeff] at hp
  simp only [quartic, one_pow, zero_pow (by decide : (2:ℕ)≠0),
    zero_pow (by decide : (3:ℕ)≠0), zero_pow (by decide : (4:ℕ)≠0),
    mul_zero, mul_one, add_zero] at hp hep
  exact pos_of_mul_pos_left hp hep.le

end QuarticLyapunov
