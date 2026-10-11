module
public import QuarticLyapunov.Basic

/-! The endpoint is defined by its explicit polynomial and rational isolation. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

def lower : ℝ := 2128153533088618627125605907329 / 10^30
def upper : ℝ := 2128153533088618627125605907330 / 10^30

theorem lower_gt_two : 2 < lower := by norm_num [lower]
theorem lower_lt_upper : lower < upper := by norm_num [lower, upper]
theorem upper_lt_three : upper < 3 := by norm_num [upper]
theorem phi_lower_neg : phi (lower^2) < 0 := by norm_num [phi, lower]
theorem phi_upper_pos : 0 < phi (upper^2) := by norm_num [phi, upper]

theorem exists_boundary : ∃ b : ℝ, lower < b ∧ b < upper ∧ phi (b^2) = 0 := by
  have hc : Continuous (fun b : ℝ => phi (b^2)) := by unfold phi; fun_prop
  obtain ⟨b, hb, he⟩ := intermediate_value_Icc lower_lt_upper.le hc.continuousOn
    (show (0:ℝ) ∈ Set.Icc (phi (lower^2)) (phi (upper^2)) from
      ⟨phi_lower_neg.le, phi_upper_pos.le⟩)
  refine ⟨b, lt_of_le_of_ne hb.1 ?_, lt_of_le_of_ne hb.2 ?_, he⟩
  · intro h
    subst b
    linarith [phi_lower_neg]
  · intro h
    subst b
    linarith [phi_upper_pos]

/-- The positive endpoint selected from its rational algebraic isolating interval. -/
def boundary : ℝ := Classical.choose exists_boundary

theorem boundary_spec : lower < boundary ∧ boundary < upper ∧ phi (boundary^2) = 0 :=
  Classical.choose_spec exists_boundary

theorem boundary_gt_two : 2 < boundary := lower_gt_two.trans boundary_spec.1

theorem root_unique_above_one (u v : ℝ) (hu : 1 < u) (hv : 1 < v)
    (hpu : phi u = 0) (hpv : phi v = 0) : u = v := by
  let s := u-1
  let t := v-1
  have hs : 0 < s := sub_pos.mpr hu
  have ht : 0 < t := sub_pos.mpr hv
  let k := 16*s^4*t^4*(s+t)+4*s^4*t^4+234*s^3*t^3+
    435*s^2*t^2*(s+t)+672*s*t*(s^2+s*t+t^2)+
    288*(s^3+s^2*t+s*t^2+t^3)
  have hk : 0 < k := by dsimp [k]; positivity
  have hid : (s-t)*k = t^4*phi u-s^4*phi v := by
    dsimp [k,s,t,phi]; ring
  rw [hpu,hpv,mul_zero,mul_zero,sub_self] at hid
  have he := (mul_eq_zero.mp hid).resolve_right (ne_of_gt hk)
  dsimp [s,t] at he
  linarith

theorem boundary_unique (b : ℝ) (hb : 1 < b) (hp : phi (b^2) = 0) :
    b = boundary := by
  have hB := boundary_gt_two
  have he := root_unique_above_one (b^2) (boundary^2) (by nlinarith)
    (by nlinarith) hp boundary_spec.2.2
  nlinarith

end QuarticLyapunov
