module
public import QuarticLyapunov

public noncomputable section
namespace QuarticLyapunov

/-- Exact weak endpoint, strict exclusion, and uniqueness among unrestricted quartics. -/
theorem endpoint_classification : ∃ B : ℝ, 2 < B ∧ phi (B^2)=0 ∧
    (∀ b : ℝ, 1 < b → phi (b^2)=0 → b=B) ∧
    ∃ c : Coeff, WeakQuarticCertificate B c ∧
      (¬ ∃ d : Coeff, StrictQuarticCertificate B d) ∧
      (∀ d : Coeff, WeakQuarticCertificate B d → ∃ k : ℝ, 0 < k ∧ d=fun i => k*c i) := by
  refine ⟨boundary,boundary_gt_two,boundary_spec.2.2,?_,endpointCoefficients,
    endpoint_weak,no_strict_at_boundary,?_⟩
  · exact fun b hb hp => boundary_unique b hb hp
  · exact fun d hd => endpoint_unique hd

/-- A literal strict integer quartic at two, while no positive weak quadratic exists. -/
theorem degree_separation :
    StrictQuarticCertificate 2 ![2,-9,20,-20,8] ∧
    ¬ ∃ a d e : ℝ,
      (∀ x y : ℝ, x≠0 ∨ y≠0 → 0 < quadratic a d e x y) ∧
      (∀ x y : ℝ, x≠0 ∨ y≠0 → quadraticLie 2 a d e x y ≤ 0) := by
  exact ⟨example_strict,no_weak_quadratic_at_two⟩

end QuarticLyapunov
