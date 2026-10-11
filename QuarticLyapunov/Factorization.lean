module
public import QuarticLyapunov.Basic

/-! Positive binary quartics split into two positive quadratic factors. -/
public noncomputable section
namespace QuarticLyapunov
open Polynomial

private theorem quadratic_gap_positive (a b : ℝ)
    (h : ∀ z : ℝ, z^2+a*z+b ≠ 0) : 0 < b-a^2/4 := by
  by_contra hh
  have hn : 0 ≤ a^2/4-b := by linarith
  have hs := Real.sq_sqrt hn
  have hz := h (-a/2+Real.sqrt (a^2/4-b))
  apply hz
  nlinarith

theorem positive_quartic_factorization {c : Coeff} (hc : PositiveQuartic c) :
    ∃ k a s d t : ℝ, 0 < k ∧ 0 < s ∧ 0 < t ∧
      ∀ x y : ℝ, quartic c x y =
        k*((y+a*x)^2+s^2*x^2)*((y+d*x)^2+t^2*x^2) := by
  have hk : 0 < c 4 := by simpa [quartic] using hc 0 1 (Or.inr one_ne_zero)
  have hk0 := ne_of_gt hk
  let f : ℝ[X] := X^4+C (c 3/c 4)*X^3+C (c 2/c 4)*X^2+C (c 1/c 4)*X+C (c 0/c 4)
  have hf : IsMonicOfDegree f 4 := by
    constructor
    · dsimp [f]; compute_degree!
    · dsimp [f]; monicity!
  obtain ⟨f₁,f₂,hf₁,hf₂,he⟩ := hf.eq_isMonicOfDegree_two_mul_isMonicOfDegree
  obtain ⟨a,b,h₁⟩ := isMonicOfDegree_two_iff.mp hf₁
  obtain ⟨d,e,h₂⟩ := isMonicOfDegree_two_iff.mp hf₂
  have heval (z : ℝ) : quartic c 1 z = c 4*(z^2+a*z+b)*(z^2+d*z+e) := by
    have hh := congrArg (Polynomial.eval z) he
    simp only [f,h₁,h₂,eval_add,eval_mul,eval_pow,eval_X,eval_C] at hh
    unfold quartic
    field_simp at hh ⊢
    nlinarith [hh]
  have hno1 : ∀ z : ℝ, z^2+a*z+b ≠ 0 := by
    intro z hz
    have hp := hc 1 z (Or.inl one_ne_zero)
    rw [heval,hz] at hp
    simp at hp
  have hno2 : ∀ z : ℝ, z^2+d*z+e ≠ 0 := by
    intro z hz
    have hp := hc 1 z (Or.inl one_ne_zero)
    rw [heval,hz] at hp
    simp at hp
  have hgap1 := quadratic_gap_positive a b hno1
  have hgap2 := quadratic_gap_positive d e hno2
  refine ⟨c 4,a/2,Real.sqrt (b-a^2/4),d/2,Real.sqrt (e-d^2/4),hk,
    Real.sqrt_pos.mpr hgap1,Real.sqrt_pos.mpr hgap2,?_⟩
  intro x y
  rw [Real.sq_sqrt hgap1.le,Real.sq_sqrt hgap2.le]
  by_cases hx : x = 0
  · simp [hx,quartic]; ring
  · have hh := heval (y/x)
    unfold quartic at hh ⊢
    field_simp at hh
    field_simp
    nlinarith [hh]

end QuarticLyapunov
