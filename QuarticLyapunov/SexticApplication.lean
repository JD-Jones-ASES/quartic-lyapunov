module
public import QuarticLyapunov.Application
public import QuarticLyapunov.Classification

/-! An exact strict sextic certificate beyond the weak quartic boundary. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

/-- The seven unrestricted real coefficients in descending powers of x. -/
abbrev SexticCoeff := Fin 7 → ℝ

/-- A general real homogeneous sextic on the plane. -/
def sextic (c : SexticCoeff) (x y : ℝ) : ℝ :=
  c 0*x^6 + c 1*x^5*y + c 2*x^4*y^2 + c 3*x^3*y^3 +
  c 4*x^2*y^4 + c 5*x*y^5 + c 6*y^6

/-- Actual Lie derivative, defined using partial derivatives of the sextic. -/
def sexticLie (b : ℝ) (c : SexticCoeff) (x y : ℝ) : ℝ :=
  deriv (fun s => sextic c s y) x * (field b x y).1 +
  deriv (fun s => sextic c x s) y * (field b x y).2

/-- Positive definiteness at every nonzero real pair. -/
def PositiveSextic (c : SexticCoeff) : Prop :=
  ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < sextic c x y

/-- Strict derivative inequality at every nonzero real pair. -/
def StrictSexticCertificate (b : ℝ) (c : SexticCoeff) : Prop :=
  PositiveSextic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → sexticLie b c x y < 0

/-- Weak derivative inequality with the same strict positivity requirement. -/
def WeakSexticCertificate (b : ℝ) (c : SexticCoeff) : Prop :=
  PositiveSextic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → sexticLie b c x y ≤ 0

/-- Explicit gradient of the arbitrary sextic. -/
def sexticGradient (c : SexticCoeff) (x y : ℝ) : ℝ × ℝ :=
  (6*c 0*x^5+5*c 1*x^4*y+4*c 2*x^3*y^2+3*c 3*x^2*y^3+
      2*c 4*x*y^4+c 5*y^5,
   c 1*x^5+2*c 2*x^4*y+3*c 3*x^3*y^2+4*c 4*x^2*y^3+
      5*c 5*x*y^4+6*c 6*y^5)

theorem sextic_partial_x (c : SexticCoeff) (x y : ℝ) :
    HasDerivAt (fun s => sextic c s y) (sexticGradient c x y).1 x := by
  unfold sextic sexticGradient
  convert (((((((hasDerivAt_pow 6 x).const_mul (c 0)).add
    (((hasDerivAt_pow 5 x).const_mul (c 1)).mul_const y)).add
    (((hasDerivAt_pow 4 x).const_mul (c 2)).mul_const (y^2))).add
    (((hasDerivAt_pow 3 x).const_mul (c 3)).mul_const (y^3))).add
    (((hasDerivAt_pow 2 x).const_mul (c 4)).mul_const (y^4))).add
    (((hasDerivAt_id x).const_mul (c 5)).mul_const (y^5))).add
    (hasDerivAt_const x (c 6*y^6)) using 1 <;>
    (try funext s) <;> simp only [Pi.add_apply] <;> norm_num <;> ring

theorem sextic_partial_y (c : SexticCoeff) (x y : ℝ) :
    HasDerivAt (fun s => sextic c x s) (sexticGradient c x y).2 y := by
  unfold sextic sexticGradient
  convert ((((((hasDerivAt_const y (c 0*x^6)).add
    ((hasDerivAt_id y).const_mul (c 1*x^5))).add
    ((hasDerivAt_pow 2 y).const_mul (c 2*x^4))).add
    ((hasDerivAt_pow 3 y).const_mul (c 3*x^3))).add
    ((hasDerivAt_pow 4 y).const_mul (c 4*x^2))).add
    ((hasDerivAt_pow 5 y).const_mul (c 5*x))).add
    ((hasDerivAt_pow 6 y).const_mul (c 6)) using 1 <;>
    (try funext s) <;> simp only [Pi.add_apply] <;> norm_num <;> ring

theorem sexticLie_eq (b : ℝ) (c : SexticCoeff) (x y : ℝ) :
    sexticLie b c x y = (sexticGradient c x y).1*(field b x y).1 +
      (sexticGradient c x y).2*(field b x y).2 := by
  rw [sexticLie, (sextic_partial_x c x y).deriv, (sextic_partial_y c x y).deriv]

theorem sextic_strict_weak {b : ℝ} {c : SexticCoeff} (h : StrictSexticCertificate b c) :
    WeakSexticCertificate b c := ⟨h.1, fun x y hxy => (h.2 x y hxy).le⟩

/-- The exact integer sextic at b = 9/4. -/
def sexticExampleCoefficients : SexticCoeff :=
  ![34, -296, 1247, -2850, 3606, -2358, 634]

theorem sextic_example_sos (x y : ℝ) :
    sextic sexticExampleCoefficients x y =
      34*(x^3-74/17*x^2*y+109/17*x*y^2-99/34*y^3)^2 +
      2835/17*(x^2*y-1282/567*x*y^2+1213/945*y^3)^2 +
      37250/567*(x*y^2-17079/18625*y^3)^2 + 585833/37250*y^6 := by
  simp [sextic, sexticExampleCoefficients]; ring

theorem sextic_example_derivative_sos (x y : ℝ) :
    -10*sexticLie (9/4) sexticExampleCoefficients x y =
      410*(x^4-35/41*x^3*y-3384/205*x^2*y^2+6811/205*x*y^3-3201/205*y^4)^2 +
      91/41*(x^3*y-597/91*x^2*y^2+1006/91*x*y^3-71/13*y^4)^2 +
      4528/455*(x^2*y^2-8807/4528*x*y^3+4837/4528*y^4)^2 +
      38297/4528*(x*y^3-35179/38297*y^4)^2 + 15885/38297*y^8 := by
  rw [sexticLie_eq]
  simp [sexticGradient, field, sexticExampleCoefficients]; ring

theorem sextic_example_positive : PositiveSextic sexticExampleCoefficients := by
  intro x y hxy
  rw [sextic_example_sos]
  by_cases hy : y = 0
  · subst y
    have hx : x ≠ 0 := hxy.resolve_right (not_not_intro rfl)
    have hx6 : 0 < (x^3)^2 := sq_pos_of_ne_zero (pow_ne_zero 3 hx)
    simpa using mul_pos (by norm_num : (0:ℝ)<34) hx6
  · have hy6 : 0 < y^6 := by simpa [← pow_mul] using pow_pos (sq_pos_of_ne_zero hy) 3
    positivity

theorem sextic_example_strict : StrictSexticCertificate (9/4) sexticExampleCoefficients := by
  refine ⟨sextic_example_positive, ?_⟩
  intro x y hxy
  have hid := sextic_example_derivative_sos x y
  by_cases hy : y = 0
  · subst y
    have hx : x ≠ 0 := hxy.resolve_right (not_not_intro rfl)
    have hx8 : 0 < (x^4)^2 := sq_pos_of_ne_zero (pow_ne_zero 4 hx)
    simp only [zero_pow (by decide : (2:ℕ) ≠ 0), zero_pow (by decide : (3:ℕ) ≠ 0),
      zero_pow (by decide : (4:ℕ) ≠ 0), zero_pow (by decide : (8:ℕ) ≠ 0),
      mul_zero, add_zero, sub_zero] at hid
    nlinarith
  · have hy8 : 0 < y^8 := by simpa [← pow_mul] using pow_pos (sq_pos_of_ne_zero hy) 4
    have hpos : 0 <
        410*(x^4-35/41*x^3*y-3384/205*x^2*y^2+6811/205*x*y^3-3201/205*y^4)^2 +
        91/41*(x^3*y-597/91*x^2*y^2+1006/91*x*y^3-71/13*y^4)^2 +
        4528/455*(x^2*y^2-8807/4528*x*y^3+4837/4528*y^4)^2 +
        38297/4528*(x*y^3-35179/38297*y^4)^2 + 15885/38297*y^8 := by positivity
    linarith

theorem boundary_lt_nine_fourths : boundary < (9/4 : ℝ) :=
  boundary_spec.2.1.trans (by norm_num [upper])

theorem no_weak_quartic_at_nine_fourths :
    ¬ ∃ c, WeakQuarticCertificate (9/4) c :=
  no_weak_above_boundary boundary_lt_nine_fourths

/-- Coefficients of the square of an arbitrary real homogeneous quadratic. -/
def quadraticSquareCoefficients (a d e : ℝ) : Coeff :=
  ![a^2, 2*a*d, d^2+2*a*e, 2*d*e, e^2]

theorem quadratic_square_value (a d e x y : ℝ) :
    quartic (quadraticSquareCoefficients a d e) x y = (quadratic a d e x y)^2 := by
  simp [quartic, quadraticSquareCoefficients, quadratic]; ring

theorem quadratic_square_lie (b a d e x y : ℝ) :
    lie b (quadraticSquareCoefficients a d e) x y =
      2*quadratic a d e x y*quadraticLie b a d e x y := by
  simp [lie_eq, gradient, quadraticSquareCoefficients, quadraticLie_eq, quadratic, field]
  ring

theorem quadratic_square_weak {b a d e : ℝ}
    (hp : ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quadratic a d e x y)
    (hd : ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → quadraticLie b a d e x y ≤ 0) :
    WeakQuarticCertificate b (quadraticSquareCoefficients a d e) := by
  constructor
  · intro x y hxy
    rw [quadratic_square_value]
    exact sq_pos_of_pos (hp x y hxy)
  · intro x y hxy
    rw [quadratic_square_lie]
    exact mul_nonpos_of_nonneg_of_nonpos
      (mul_nonneg (by norm_num) (hp x y hxy).le) (hd x y hxy)

theorem no_weak_quadratic_at_nine_fourths : ¬ ∃ a d e : ℝ,
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quadratic a d e x y) ∧
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → quadraticLie (9/4) a d e x y ≤ 0) := by
  rintro ⟨a, d, e, hp, hd⟩
  exact no_weak_quartic_at_nine_fourths
    ⟨quadraticSquareCoefficients a d e, quadratic_square_weak hp hd⟩

/-- Degree-six strict feasibility together with the degree-four and degree-two obstructions. -/
theorem sextic_degree_separation :
    StrictSexticCertificate (9/4) sexticExampleCoefficients ∧
    (¬ ∃ c, WeakQuarticCertificate (9/4) c) ∧
    (¬ ∃ a d e : ℝ,
      (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quadratic a d e x y) ∧
      (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → quadraticLie (9/4) a d e x y ≤ 0)) :=
  ⟨sextic_example_strict, no_weak_quartic_at_nine_fourths,
    no_weak_quadratic_at_nine_fourths⟩

end QuarticLyapunov
