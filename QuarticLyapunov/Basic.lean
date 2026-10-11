module
public import Mathlib

/-! Polynomial semantics for homogeneous quartic Lyapunov certificates. -/
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

/-- Explicit gradient of the quartic. -/
def gradient (c : Coeff) (x y : ℝ) : ℝ × ℝ :=
  (4*c 0*x^3+3*c 1*x^2*y+2*c 2*x*y^2+c 3*y^3,
   c 1*x^3+2*c 2*x^2*y+3*c 3*x*y^2+4*c 4*y^3)

theorem partial_x (c : Coeff) (x y : ℝ) :
    HasDerivAt (fun s => quartic c s y) (gradient c x y).1 x := by
  unfold quartic gradient
  convert (((((hasDerivAt_pow 4 x).const_mul (c 0)).add
    (((hasDerivAt_pow 3 x).const_mul (c 1)).mul_const y)).add
    (((hasDerivAt_pow 2 x).const_mul (c 2)).mul_const (y^2))).add
    (((hasDerivAt_id x).const_mul (c 3)).mul_const (y^3))).add
    (hasDerivAt_const x (c 4*y^4)) using 1 <;> (try funext s) <;> simp only [Pi.add_apply] <;> norm_num <;> ring

theorem partial_y (c : Coeff) (x y : ℝ) :
    HasDerivAt (fun s => quartic c x s) (gradient c x y).2 y := by
  unfold quartic gradient
  convert ((((hasDerivAt_const y (c 0*x^4)).add
    ((hasDerivAt_id y).const_mul (c 1*x^3))).add
    ((hasDerivAt_pow 2 y).const_mul (c 2*x^2))).add
    ((hasDerivAt_pow 3 y).const_mul (c 3*x))).add
    ((hasDerivAt_pow 4 y).const_mul (c 4)) using 1 <;> (try funext s) <;> simp only [Pi.add_apply] <;> norm_num <;> ring

theorem lie_eq (b : ℝ) (c : Coeff) (x y : ℝ) :
    lie b c x y = (gradient c x y).1*(field b x y).1 +
      (gradient c x y).2*(field b x y).2 := by
  rw [lie, (partial_x c x y).deriv, (partial_y c x y).deriv]

theorem strict_weak {b : ℝ} {c : Coeff} (h : StrictQuarticCertificate b c) :
    WeakQuarticCertificate b c := ⟨h.1, fun x y hxy => (h.2 x y hxy).le⟩

end QuarticLyapunov
