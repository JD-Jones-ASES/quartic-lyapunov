module
public import QuarticLyapunov.Classification

/-! The complete derivative-feasible cone at the algebraic endpoint. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

/-- Every quartic whose actual derivative is nonpositive at the endpoint is
a nonnegative multiple of the explicit positive endpoint quartic, and conversely. -/
theorem endpoint_derivative_cone (c : Coeff) :
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie boundary c x y ≤ 0) ↔
    ∃ k : ℝ, 0 ≤ k ∧ c = fun i => k*endpointCoefficients i := by
  constructor
  · exact endpoint_nonpositive_derivative_ray
  · rintro ⟨k,hk,rfl⟩ x y hxy
    rw [lie_smul]
    exact mul_nonpos_of_nonneg_of_nonpos hk (endpoint_weak.2 x y hxy)

/-- For a nonzero quartic, the endpoint derivative inequality already implies
strict positive definiteness. -/
theorem endpoint_derivative_forces_positive {c : Coeff} (hc : c ≠ 0)
    (hd : ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie boundary c x y ≤ 0) :
    PositiveQuartic c := by
  obtain ⟨k,hk,rfl⟩ := endpoint_nonpositive_derivative_ray hd
  have hk0 : k ≠ 0 := by
    intro he
    apply hc
    funext i
    simp [he]
  have hkp : 0 < k := lt_of_le_of_ne hk (Ne.symm hk0)
  intro x y hxy
  rw [quartic_smul]
  exact mul_pos hkp (endpoint_positive x y hxy)

/-- Every nonzero derivative-feasible quartic has the same derivative zero set
as the explicit endpoint cubic. -/
theorem endpoint_derivative_zero_iff {c : Coeff} (hc : c ≠ 0)
    (hd : ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie boundary c x y ≤ 0)
    (x y : ℝ) :
    lie boundary c x y = 0 ↔ endpointCubic x y = 0 := by
  obtain ⟨k, _, rfl⟩ := endpoint_nonpositive_derivative_ray hd
  have hk0 : k ≠ 0 := by
    intro he
    apply hc
    funext i
    simp [he]
  rw [lie_smul, mul_eq_zero]
  simp only [hk0, false_or]
  rw [← neg_eq_zero, endpoint_negative_lie_square, sq_eq_zero_iff]

end QuarticLyapunov
