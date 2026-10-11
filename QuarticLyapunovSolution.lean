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

/-- The complete strict quartic classification, including both parameter signs. -/
theorem strict_classification (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) (b : ℝ) :
    (∃ c : Coeff, StrictQuarticCertificate b c) ↔ |b| < B := by
  rw [boundary_unique B hB hphi]
  exact strict_iff_abs b

/-- The complete weak quartic classification, with endpoint attainment. -/
theorem weak_classification (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) (b : ℝ) :
    (∃ c : Coeff, WeakQuarticCertificate b c) ↔ |b| ≤ B := by
  rw [boundary_unique B hB hphi]
  exact weak_iff_abs b

/-- The literal algebraic coefficient vector is weak and generates the complete endpoint ray. -/
theorem endpoint_explicit (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) :
    WeakQuarticCertificate B (explicitEndpoint B) ∧
    (∀ c : Coeff, WeakQuarticCertificate B c →
      ∃ k : ℝ, 0 < k ∧ c=fun i => k*explicitEndpoint B i) := by
  rw [boundary_unique B hB hphi,explicitEndpoint_eq]
  exact ⟨endpoint_weak,fun c hc => endpoint_unique hc⟩

/-- The negative endpoint derivative is a monic cubic square with three distinct real lines. -/
theorem endpoint_geometry (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) :
    ∃ h₀ h₁ h₂ r s t : ℝ, r < s ∧ s < t ∧
      (∀ x y : ℝ, -lie B (explicitEndpoint B) x y =
        (h₀*x^3+h₁*x^2*y+h₂*x*y^2+y^3)^2) ∧
      h₀+h₁*r+h₂*r^2+r^3=0 ∧ h₀+h₁*s+h₂*s^2+s^3=0 ∧
      h₀+h₁*t+h₂*t^2+t^3=0 := by
  rw [boundary_unique B hB hphi,explicitEndpoint_eq]
  let a := endpointAtoms
  refine ⟨Endpoint.h0,Endpoint.h1,Endpoint.h2,a.r,a.s,a.t,a.hrs,a.hst,?_,?_,?_,?_⟩
  · intro x y
    simpa [endpointCubic,Endpoint.h3] using endpoint_negative_lie_square x y
  · simpa [endpointCubic,Endpoint.h3] using a.hr
  · simpa [endpointCubic,Endpoint.h3] using a.hs
  · simpa [endpointCubic,Endpoint.h3] using a.ht

/-- Weak quartic feasibility contracts to strict feasibility without increasing degree. -/
theorem degree_preserving_contraction (B ρ : ℝ) (hρ₀ : 0 ≤ ρ) (hρ₁ : ρ < 1) :
    (∃ c : Coeff, WeakQuarticCertificate B c) →
    ∃ c : Coeff, StrictQuarticCertificate (ρ*B) c := by
  rintro ⟨c,hc⟩
  exact quartic_contraction hc ⟨hρ₀,hρ₁⟩

/-- Exact rational isolation of the positive boundary; decimals are not proof inputs. -/
theorem boundary_isolation (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) :
    (2128153533088618627125605907329:ℝ)/10^30 < B ∧
    B < (2128153533088618627125605907330:ℝ)/10^30 := by
  rw [boundary_unique B hB hphi]
  exact ⟨boundary_spec.1,boundary_spec.2.1⟩

/-- The whole cone of quartics with nonpositive endpoint derivative, including zero. -/
theorem endpoint_cone_classification (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0)
    (c : Coeff) :
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie B c x y ≤ 0) ↔
      ∃ k : ℝ, 0 ≤ k ∧ c = fun i => k * explicitEndpoint B i := by
  rw [boundary_unique B hB hphi, explicitEndpoint_eq]
  exact endpoint_derivative_cone c

/-- A strict integer sextic at nine fourths, where weak quadratics and quartics are impossible. -/
theorem sextic_separation :
    StrictSexticCertificate (9/4) ![34, -296, 1247, -2850, 3606, -2358, 634] ∧
    (¬ ∃ c : Coeff, WeakQuarticCertificate (9/4) c) ∧
    (¬ ∃ a d e : ℝ,
      (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quadratic a d e x y) ∧
      (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → quadraticLie (9/4) a d e x y ≤ 0)) := by
  exact sextic_degree_separation

end QuarticLyapunov
