module
public import QuarticLyapunov.Factorization
public import QuarticLyapunov.PositiveReal

/-! Explicit outer linear factors and their degree-preserving radial contraction. -/
@[expose] public noncomputable section
namespace QuarticLyapunov
open Complex
open scoped ComplexConjugate

def outerK (a s : ℝ) : ℂ := a+(s+1)*I
def outerL (a s : ℝ) : ℂ := a+(s-1)*I
def outerQ (a s : ℝ) (z : ℂ) : ℂ := outerK a s+outerL a s*z

def plane (x y : ℝ) : ℂ := x+y*I
def phase (x y : ℝ) : ℂ := plane x y / conj (plane x y)
def linearFactor (a s ρ x y : ℝ) : ℂ :=
  outerK a s*conj (plane x y)+ρ*outerL a s*plane x y

def factorU (a s ρ : ℝ) : ℝ := (a*(1+ρ))^2+(s*(1+ρ)+1-ρ)^2
def factorV (a ρ : ℝ) : ℝ := 8*a*ρ
def factorW (a s ρ : ℝ) : ℝ := (s*(1-ρ)+1+ρ)^2+(a*(1-ρ))^2

def factorForm (a s ρ x y : ℝ) : ℝ :=
  factorU a s ρ*x^2+factorV a ρ*x*y+factorW a s ρ*y^2

def contractedCoefficients (a s d t ρ : ℝ) : Coeff :=
  let u := factorU a s ρ
  let v := factorV a ρ
  let w := factorW a s ρ
  let u' := factorU d t ρ
  let v' := factorV d ρ
  let w' := factorW d t ρ
  ![u*u',u*v'+v*u',u*w'+v*v'+w*u',v*w'+w*v',w*w']

theorem contracted_product (a s d t ρ x y : ℝ) :
    quartic (contractedCoefficients a s d t ρ) x y =
      factorForm a s ρ x y * factorForm d t ρ x y := by
  simp [quartic,contractedCoefficients,factorForm]; ring

theorem factorForm_one (a s x y : ℝ) : factorForm a s 1 x y =
    4*((y+a*x)^2+s^2*x^2) := by
  unfold factorForm factorU factorV factorW; ring

theorem linearFactor_parts (a s ρ x y : ℝ) :
    (linearFactor a s ρ x y).re = a*(1+ρ)*x+(s*(1-ρ)+1+ρ)*y ∧
    (linearFactor a s ρ x y).im = (s*(1+ρ)+1-ρ)*x-a*(1-ρ)*y := by
  simp [linearFactor,outerK,outerL,plane,Complex.mul_re,Complex.mul_im]
  constructor <;> ring

theorem factorForm_normSq (a s ρ x y : ℝ) :
    factorForm a s ρ x y = Complex.normSq (linearFactor a s ρ x y) := by
  rw [Complex.normSq_apply,(linearFactor_parts a s ρ x y).1,(linearFactor_parts a s ρ x y).2]
  unfold factorForm factorU factorV factorW; ring

theorem outer_norm_lt {a s : ℝ} (hs : 0 < s) : ‖outerL a s‖ < ‖outerK a s‖ := by
  have h : Complex.normSq (outerK a s)-Complex.normSq (outerL a s)=4*s := by
    simp [outerK,outerL,Complex.normSq_apply]; ring
  rw [Complex.normSq_eq_norm_sq,Complex.normSq_eq_norm_sq] at h
  nlinarith [norm_nonneg (outerL a s),norm_nonneg (outerK a s)]

theorem outerQ_ne_zero {a s : ℝ} (hs : 0 < s) {z : ℂ} (hz : ‖z‖ ≤ 1) :
    outerQ a s z ≠ 0 := by
  intro he
  have hn : ‖outerL a s*z‖ < ‖outerK a s‖ := by
    rw [norm_mul]
    exact lt_of_le_of_lt (by nlinarith [norm_nonneg (outerL a s)]) (outer_norm_lt hs)
  have he' : outerL a s*z = -outerK a s := by unfold outerQ at he; linear_combination he
  rw [he',norm_neg] at hn
  exact (lt_irrefl _) hn

theorem plane_ne_zero {x y : ℝ} (h : x ≠ 0 ∨ y ≠ 0) : plane x y ≠ 0 := by
  intro he
  have hr := congrArg Complex.re he
  have hi := congrArg Complex.im he
  simp [plane] at hr hi
  exact h.elim (fun hx => hx hr) (fun hy => hy hi)

theorem phase_norm {x y : ℝ} (h : x ≠ 0 ∨ y ≠ 0) : ‖phase x y‖ = 1 := by
  simp [phase,norm_div,Complex.norm_conj,div_self (norm_ne_zero_iff.mpr (plane_ne_zero h))]

theorem linearFactor_eq (a s ρ x y : ℝ) (h : x ≠ 0 ∨ y ≠ 0) :
    linearFactor a s ρ x y = outerQ a s (ρ*phase x y)*conj (plane x y) := by
  have hz := plane_ne_zero h
  have hc : conj (plane x y) ≠ 0 := by simpa using hz
  unfold linearFactor outerQ phase
  field_simp <;> ring

theorem linearFactor_ne_zero {a s ρ x y : ℝ} (hs : 0 < s) (hρ : 0 ≤ ρ ∧ ρ ≤ 1)
    (h : x ≠ 0 ∨ y ≠ 0) : linearFactor a s ρ x y ≠ 0 := by
  rw [linearFactor_eq a s ρ x y h]
  apply mul_ne_zero
  · apply outerQ_ne_zero hs
    rw [norm_mul,Complex.norm_real,Real.norm_eq_abs,abs_of_nonneg hρ.1,phase_norm h,mul_one]
    exact hρ.2
  · simpa using plane_ne_zero h

theorem contracted_positive {a s d t ρ : ℝ} (hs : 0 < s) (ht : 0 < t)
    (hρ : 0 ≤ ρ ∧ ρ ≤ 1) : PositiveQuartic (contractedCoefficients a s d t ρ) := by
  intro x y hxy
  rw [contracted_product,factorForm_normSq,factorForm_normSq]
  exact mul_pos (Complex.normSq_pos.mpr (linearFactor_ne_zero hs hρ hxy))
    (Complex.normSq_pos.mpr (linearFactor_ne_zero ht hρ hxy))

end QuarticLyapunov
