module
public import QuarticLyapunov.Endpoint

/-! Three distinct real roots of the endpoint cubic, with exact rational isolation. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

private theorem root_between {f : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hc : Continuous f) (ha : f a < 0) (hb : 0 < f b) :
    ∃ r : ℝ, a < r ∧ r < b ∧ f r = 0 := by
  obtain ⟨r, hr, he⟩ := intermediate_value_Icc hab.le hc.continuousOn ⟨ha.le,hb.le⟩
  refine ⟨r, lt_of_le_of_ne hr.1 ?_, lt_of_le_of_ne hr.2 ?_, he⟩
  · intro h; subst r; linarith
  · intro h; subst r; linarith

theorem endpoint_three_roots : ∃ r₁ r₂ r₃ : ℝ,
    (-1/5 < r₁ ∧ r₁ < -19/100) ∧
    (46/100 < r₂ ∧ r₂ < 47/100) ∧
    (118/100 < r₃ ∧ r₃ < 119/100) ∧
    endpointCubic 1 r₁ = 0 ∧ endpointCubic 1 r₂ = 0 ∧ endpointCubic 1 r₃ = 0 := by
  have hc : Continuous (endpointCubic 1) := by unfold endpointCubic; fun_prop
  have h0 : endpointCubic 1 (-1/5) < 0 := by
    convert Endpoint.cubic_sign0_neg using 1 <;> unfold endpointCubic <;> ring
  have h1 : 0 < endpointCubic 1 (-19/100) := by
    convert Endpoint.cubic_sign1_pos using 1 <;> unfold endpointCubic <;> ring
  have h2 : 0 < endpointCubic 1 (46/100) := by
    convert Endpoint.cubic_sign2_pos using 1 <;> unfold endpointCubic <;> ring
  have h3 : endpointCubic 1 (47/100) < 0 := by
    convert Endpoint.cubic_sign3_neg using 1 <;> unfold endpointCubic <;> ring
  have h4 : endpointCubic 1 (118/100) < 0 := by
    convert Endpoint.cubic_sign4_neg using 1 <;> unfold endpointCubic <;> ring
  have h5 : 0 < endpointCubic 1 (119/100) := by
    convert Endpoint.cubic_sign5_pos using 1 <;> unfold endpointCubic <;> ring
  obtain ⟨r₁, h₁a, h₁b, h₁⟩ := root_between (by norm_num : (-1/5:ℝ) < -19/100) hc h0 h1
  obtain ⟨r₂, h₂a, h₂b, h₂⟩ := root_between (by norm_num : (46/100:ℝ) < 47/100) hc.neg
    (neg_neg_of_pos h2) (neg_pos.mpr h3)
  obtain ⟨r₃, h₃a, h₃b, h₃⟩ := root_between (by norm_num : (118/100:ℝ) < 119/100) hc h4 h5
  exact ⟨r₁,r₂,r₃,⟨h₁a,h₁b⟩,⟨h₂a,h₂b⟩,⟨h₃a,h₃b⟩,h₁,neg_eq_zero.mp h₂,h₃⟩

/-- A monic cubic with three distinct roots has its expected Vieta coefficients. -/
theorem cubic_vieta {a b c r s t : ℝ} (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (hr : a+b*r+c*r^2+r^3 = 0) (hs : a+b*s+c*s^2+s^3 = 0)
    (ht : a+b*t+c*t^2+t^3 = 0) :
    c = -(r+s+t) ∧ b = r*s+r*t+s*t ∧ a = -r*s*t := by
  have h12 : b+c*(r+s)+(r^2+r*s+s^2) = 0 := by
    have h : (r-s)*(b+c*(r+s)+(r^2+r*s+s^2)) = 0 := by nlinarith [hr,hs]
    exact (mul_eq_zero.mp h).resolve_left (sub_ne_zero.mpr hrs)
  have h23 : b+c*(s+t)+(s^2+s*t+t^2) = 0 := by
    have h : (s-t)*(b+c*(s+t)+(s^2+s*t+t^2)) = 0 := by nlinarith [hs,ht]
    exact (mul_eq_zero.mp h).resolve_left (sub_ne_zero.mpr hst)
  have hc : c = -(r+s+t) := by
    have h : (r-t)*(c+r+s+t) = 0 := by nlinarith [h12,h23]
    have hh := (mul_eq_zero.mp h).resolve_left (sub_ne_zero.mpr hrt)
    linarith
  have hb : b = r*s+r*t+s*t := by rw [hc] at h12; nlinarith [h12]
  refine ⟨hc,hb,?_⟩
  rw [hc,hb] at hr
  nlinarith [hr]
end QuarticLyapunov
