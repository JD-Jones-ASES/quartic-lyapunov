module
public import QuarticLyapunov.SpectralFactors

/-! The logarithmic derivative connects the analytic contraction to the actual field. -/
@[expose] public noncomputable section
namespace QuarticLyapunov
open Complex
open scoped ComplexConjugate

def logTerm (a s : ℝ) (z : ℂ) : ℂ := z*outerL a s/outerQ a s z

def positiveRealFunction (B a s d t : ℝ) (z : ℂ) : ℂ :=
  1-B*z-I*(logTerm a s z+logTerm d t z)

def angularNegative (a s ρ x y : ℝ) : ℝ :=
  y*(2*factorU a s ρ*x+factorV a ρ*y)-
  x*(factorV a ρ*x+2*factorW a s ρ*y)

theorem logTerm_plane (a s ρ x y : ℝ) (hxy : x ≠ 0 ∨ y ≠ 0) :
    logTerm a s (ρ*phase x y) =
      (ρ*outerL a s*plane x y)/linearFactor a s ρ x y := by
  have hw := plane_ne_zero hxy
  have hc : conj (plane x y) ≠ 0 := by simpa using hw
  unfold logTerm
  rw [linearFactor_eq a s ρ x y hxy]
  unfold phase
  field_simp <;> ring

theorem logTerm_angular {a s ρ x y : ℝ} (hs : 0 < s) (hρ : 0 ≤ ρ ∧ ρ ≤ 1)
    (hxy : x ≠ 0 ∨ y ≠ 0) :
    4*factorForm a s ρ x y*(logTerm a s (ρ*phase x y)).im = angularNegative a s ρ x y := by
  rw [logTerm_plane a s ρ x y hxy,Complex.div_im]
  have hn : Complex.normSq (linearFactor a s ρ x y) ≠ 0 :=
    ne_of_gt (Complex.normSq_pos.mpr (linearFactor_ne_zero hs hρ hxy))
  rw [factorForm_normSq]
  field_simp
  rw [(linearFactor_parts a s ρ x y).1,(linearFactor_parts a s ρ x y).2]
  simp [outerL,plane,Complex.mul_re,Complex.mul_im,angularNegative,factorU,factorV,factorW]
  ring

theorem phase_radial {x y : ℝ} (hxy : x ≠ 0 ∨ y ≠ 0) :
    (x^2+y^2)*(phase x y).re = x^2-y^2 := by
  have hr : x^2+y^2 ≠ 0 := by
    have hp : 0 < x^2+y^2 := hxy.elim
      (fun h => add_pos_of_pos_of_nonneg (sq_pos_of_ne_zero h) (sq_nonneg y))
      (fun h => add_pos_of_nonneg_of_pos (sq_nonneg x) (sq_pos_of_ne_zero h))
    exact ne_of_gt hp
  simp [phase,plane,Complex.div_re,Complex.normSq_apply,Complex.mul_re,Complex.mul_im]
  field_simp <;> ring

theorem product_negative_lie (b a s d t ρ x y : ℝ) :
    -lie b (contractedCoefficients a s d t ρ) x y =
      4*((x^2+y^2)-b*(x^2-y^2))*factorForm a s ρ x y*factorForm d t ρ x y +
      (x^2+y^2)*(angularNegative a s ρ x y*factorForm d t ρ x y+
        angularNegative d t ρ x y*factorForm a s ρ x y) := by
  rw [lie_eq]
  simp [gradient,field,contractedCoefficients,factorForm,angularNegative]
  ring

theorem contracted_lie_identity {B a s d t ρ x y : ℝ} (hs : 0 < s) (ht : 0 < t)
    (hρ : 0 ≤ ρ ∧ ρ ≤ 1) (hxy : x ≠ 0 ∨ y ≠ 0) :
    -lie (ρ*B) (contractedCoefficients a s d t ρ) x y =
      4*(x^2+y^2)*quartic (contractedCoefficients a s d t ρ) x y *
        (positiveRealFunction B a s d t (ρ*phase x y)).re := by
  rw [product_negative_lie,contracted_product]
  have h1 := logTerm_angular (a := a) hs hρ hxy
  have h2 := logTerm_angular (a := d) ht hρ hxy
  have hp := phase_radial hxy
  simp only [positiveRealFunction,Complex.sub_re,Complex.one_re,Complex.mul_re,
    Complex.ofReal_re,Complex.ofReal_im,zero_mul,sub_zero,Complex.I_re,
    Complex.I_im,one_mul,Complex.add_im,zero_sub]
  linear_combination -(x^2+y^2)*factorForm d t ρ x y*h1 -
    (x^2+y^2)*factorForm a s ρ x y*h2 +
    (4*ρ*B*factorForm a s ρ x y*factorForm d t ρ x y)*hp

end QuarticLyapunov
