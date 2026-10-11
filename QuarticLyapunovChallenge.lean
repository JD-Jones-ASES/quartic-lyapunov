module
public import Mathlib

/-! Current proved endpoint and degree-separation contracts. The full parameter
classification remains under construction; see VERIFICATION.md. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

/-- The five unrestricted real coefficients in descending powers of x. -/
abbrev Coeff := Fin 5 → ℝ

/-- A general real homogeneous quartic on the plane. -/
def quartic (c : Coeff) (x y : ℝ) : ℝ :=
  c 0*x^4 + c 1*x^3*y + c 2*x^2*y^2 + c 3*x*y^3 + c 4*y^4

/-- The damping-one cubic vector field. -/
def field (b x y : ℝ) : ℝ × ℝ :=
  ((-(x^2+y^2)+b*(x^2-y^2))*x-(x^2+y^2)*y,
   (-(x^2+y^2)+b*(x^2-y^2))*y+(x^2+y^2)*x)

/-- Actual Lie derivative, defined using partial derivatives of the polynomial. -/
def lie (b : ℝ) (c : Coeff) (x y : ℝ) : ℝ :=
  deriv (fun s => quartic c s y) x * (field b x y).1 +
  deriv (fun s => quartic c x s) y * (field b x y).2

/-- Positive definiteness means positivity at every nonzero real pair. -/
def PositiveQuartic (c : Coeff) : Prop :=
  ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quartic c x y

/-- Strict derivative inequality at every nonzero real pair. -/
def StrictQuarticCertificate (b : ℝ) (c : Coeff) : Prop :=
  PositiveQuartic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie b c x y < 0

/-- Weak derivative inequality with the same strict positivity requirement. -/
def WeakQuarticCertificate (b : ℝ) (c : Coeff) : Prop :=
  PositiveQuartic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie b c x y ≤ 0

/-- The explicit algebraic boundary polynomial, evaluated at B squared. -/
def phi (u : ℝ) : ℝ :=
  16*u^6 - 92*u^5 + 125*u^4 - 134*u^3 - 103*u^2 - 200*u + 100

/-- General homogeneous quadratic with unrestricted real coefficients. -/
def quadratic (a d e x y : ℝ) : ℝ := a*x^2+d*x*y+e*y^2

/-- The actual Lie derivative of a quadratic. -/
def quadraticLie (b a d e x y : ℝ) : ℝ :=
  deriv (fun s => quadratic a d e s y) x*(field b x y).1 +
  deriv (fun s => quadratic a d e x s) y*(field b x y).2

/-- Exact weak endpoint, strict exclusion, and uniqueness among unrestricted quartics. -/
theorem endpoint_classification : ∃ B : ℝ, 2 < B ∧ phi (B^2)=0 ∧
    (∀ b : ℝ, 1 < b → phi (b^2)=0 → b=B) ∧
    ∃ c : Coeff, WeakQuarticCertificate B c ∧
      (¬ ∃ d : Coeff, StrictQuarticCertificate B d) ∧
      (∀ d : Coeff, WeakQuarticCertificate B d → ∃ k : ℝ, 0 < k ∧ d=fun i => k*c i) := by
  sorry

/-- A literal strict integer quartic at two, while no positive weak quadratic exists. -/
theorem degree_separation :
    StrictQuarticCertificate 2 ![2,-9,20,-20,8] ∧
    ¬ ∃ a d e : ℝ,
      (∀ x y : ℝ, x≠0 ∨ y≠0 → 0 < quadratic a d e x y) ∧
      (∀ x y : ℝ, x≠0 ∨ y≠0 → quadraticLie 2 a d e x y ≤ 0) := by
  sorry

end QuarticLyapunov
