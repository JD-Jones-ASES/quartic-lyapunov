module
public import QuarticLyapunov.Root

/-! Small rational interval rules used by the generated algebraic certificate. -/
public section
namespace QuarticLyapunov

theorem horner_pos {x z l h a b c : ℝ} (hx : l ≤ x ∧ x ≤ h)
    (hz : a ≤ z ∧ z ≤ b) (hl : 0 ≤ l) (ha : 0 ≤ a) :
    a*l+c ≤ z*x+c ∧ z*x+c ≤ b*h+c := by
  have hz0 : 0 ≤ z := ha.trans hz.1
  have hx0 : 0 ≤ x := hl.trans hx.1
  constructor
  · have h1 := mul_le_mul_of_nonneg_right hz.1 hl
    have h2 := mul_le_mul_of_nonneg_left hx.1 hz0
    linarith
  · have h1 := mul_le_mul_of_nonneg_right hz.2 hx0
    have hb : 0 ≤ b := hz0.trans hz.2
    have h2 := mul_le_mul_of_nonneg_left hx.2 hb
    linarith

theorem horner_neg {x z l h a b c : ℝ} (hx : l ≤ x ∧ x ≤ h)
    (hz : a ≤ z ∧ z ≤ b) (hl : 0 ≤ l) (hb : b ≤ 0) :
    a*h+c ≤ z*x+c ∧ z*x+c ≤ b*l+c := by
  have hx0 : 0 ≤ x := hl.trans hx.1
  have hz0 : z ≤ 0 := hz.2.trans hb
  constructor
  · have h1 := mul_le_mul_of_nonneg_right hz.1 (hx0.trans hx.2)
    have h2 := mul_le_mul_of_nonpos_left hx.2 hz0
    linarith
  · have h1 := mul_le_mul_of_nonneg_right hz.2 hx0
    have h2 := mul_le_mul_of_nonpos_left hx.1 hb
    linarith

theorem horner_mixed {x z l h a b c : ℝ} (hx : l ≤ x ∧ x ≤ h)
    (hz : a ≤ z ∧ z ≤ b) (hl : 0 ≤ l) (ha : a ≤ 0) (hb : 0 ≤ b) :
    a*h+c ≤ z*x+c ∧ z*x+c ≤ b*h+c := by
  have hx0 : 0 ≤ x := hl.trans hx.1
  constructor
  · have h1 := mul_le_mul_of_nonneg_right hz.1 hx0
    have h2 := mul_le_mul_of_nonpos_left hx.2 ha
    linarith
  · have h1 := mul_le_mul_of_nonneg_right hz.2 hx0
    have h2 := mul_le_mul_of_nonneg_left hx.2 hb
    linarith
end QuarticLyapunov
