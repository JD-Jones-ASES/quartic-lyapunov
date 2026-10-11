module
public import QuarticLyapunov.Basic

/-! An exact strict quartic certificate where even weak quadratics fail. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

def exampleCoefficients : Coeff := ![2, -9, 20, -20, 8]

theorem example_sos (x y : ℝ) :
    quartic exampleCoefficients x y =
      2*(x^2-9/4*x*y+3/2*y^2)^2 +
      31/8*(x*y-26/31*y^2)^2 + 24/31*y^4 := by
  simp [quartic, exampleCoefficients]; ring

theorem example_derivative_sos (x y : ℝ) :
    -lie 2 exampleCoefficients x y =
      (x^3+2*x^2*y-21/2*x*y^2+13/2*y^3)^2 +
      3*(x^2*y-23/6*x*y^2+8/3*y^3)^2 +
      74/3*(x*y^2-205/296*y^3)^2 + 693/1184*y^6 := by
  rw [lie_eq]
  simp [gradient, field, exampleCoefficients]; ring

theorem example_positive : PositiveQuartic exampleCoefficients := by
  intro x y hxy
  rw [example_sos]
  by_cases hy : y = 0
  · subst y
    have hx : x ≠ 0 := hxy.resolve_right (not_not_intro rfl)
    simpa using mul_pos (by norm_num : (0:ℝ)<2) (pow_pos (sq_pos_of_ne_zero hx) 2)
  · have hy4 : 0 < y^4 := by simpa [← pow_mul] using pow_pos (sq_pos_of_ne_zero hy) 2
    nlinarith [sq_nonneg (x^2-9/4*x*y+3/2*y^2),
      sq_nonneg (x*y-26/31*y^2)]

theorem example_strict : StrictQuarticCertificate 2 exampleCoefficients := by
  refine ⟨example_positive, ?_⟩
  intro x y hxy
  have hid := example_derivative_sos x y
  by_cases hy : y = 0
  · subst y
    have hx : x ≠ 0 := hxy.resolve_right (not_not_intro rfl)
    have hx6 : 0 < (x^3)^2 := sq_pos_of_ne_zero (pow_ne_zero 3 hx)
    simp only [zero_pow (by decide : (2:ℕ) ≠ 0), zero_pow (by decide : (3:ℕ) ≠ 0),
      zero_pow (by decide : (6:ℕ) ≠ 0), mul_zero, add_zero, sub_zero] at hid
    linarith
  · have hy6 : 0 < y^6 := by simpa [← pow_mul] using pow_pos (sq_pos_of_ne_zero hy) 3
    nlinarith [sq_nonneg (x^3+2*x^2*y-21/2*x*y^2+13/2*y^3),
      sq_nonneg (x^2*y-23/6*x*y^2+8/3*y^3),
      sq_nonneg (x*y^2-205/296*y^3)]

/-- General homogeneous quadratic with unrestricted real coefficients. -/
def quadratic (a d e x y : ℝ) : ℝ := a*x^2+d*x*y+e*y^2

/-- The actual Lie derivative of a quadratic. -/
def quadraticLie (b a d e x y : ℝ) : ℝ :=
  deriv (fun s => quadratic a d e s y) x*(field b x y).1 +
  deriv (fun s => quadratic a d e x s) y*(field b x y).2

theorem quadraticLie_eq (b a d e x y : ℝ) :
    quadraticLie b a d e x y =
      (2*a*x+d*y)*(field b x y).1 + (d*x+2*e*y)*(field b x y).2 := by
  have hx : HasDerivAt (fun s => quadratic a d e s y) (2*a*x+d*y) x := by
    unfold quadratic
    convert ((((hasDerivAt_pow 2 x).const_mul a).add
      (((hasDerivAt_id x).const_mul d).mul_const y)).add
      (hasDerivAt_const x (e*y^2))) using 1 <;>
      (try funext s) <;> (try simp only [Pi.add_apply]) <;> norm_num <;> ring
  have hy : HasDerivAt (fun s => quadratic a d e x s) (d*x+2*e*y) y := by
    unfold quadratic
    convert (((hasDerivAt_const y (a*x^2)).add
      ((hasDerivAt_id y).const_mul (d*x))).add
      ((hasDerivAt_pow 2 y).const_mul e)) using 1 <;>
      (try funext s) <;> (try simp only [Pi.add_apply]) <;> norm_num <;> ring
  rw [quadraticLie, hx.deriv, hy.deriv]

theorem quadratic_dual (a d e : ℝ) :
    24*(-quadraticLie 2 a d e 4 (-1)) +
    20*(-quadraticLie 2 a d e 3 2) +
    1051*(-quadraticLie 2 a d e 1 1) = -640*a := by
  simp only [quadraticLie_eq, field]; ring

theorem no_weak_quadratic_at_two : ¬ ∃ a d e : ℝ,
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quadratic a d e x y) ∧
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → quadraticLie 2 a d e x y ≤ 0) := by
  rintro ⟨a,d,e,hp,hd⟩
  have ha := hp 1 0 (Or.inl one_ne_zero)
  simp only [quadratic, one_pow, mul_one, mul_zero, zero_pow (by decide : (2:ℕ) ≠ 0),
    add_zero] at ha
  have h1 := hd 4 (-1) (Or.inl (by norm_num))
  have h2 := hd 3 2 (Or.inl (by norm_num))
  have h3 := hd 1 1 (Or.inl one_ne_zero)
  linarith [quadratic_dual a d e]

end QuarticLyapunov
