module
public import QuarticLyapunov.EndpointUnique
public import QuarticLyapunov.Contraction

/-! Complete strict and weak parameter classifications. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

theorem strict_below_boundary {b : ℝ} (hb : 0 ≤ b) (hB : b < boundary) :
    ∃ c, StrictQuarticCertificate b c := by
  have hpos : 0 < boundary := lt_trans (by norm_num) boundary_gt_two
  have hr : 0 ≤ b/boundary ∧ b/boundary < 1 :=
    ⟨div_nonneg hb hpos.le,(div_lt_one hpos).mpr hB⟩
  simpa [div_mul_cancel₀ b (ne_of_gt hpos)] using quartic_contraction endpoint_weak hr

theorem no_weak_above_boundary {b : ℝ} (hb : boundary < b) :
    ¬ ∃ c, WeakQuarticCertificate b c := by
  rintro ⟨c,hc⟩
  have hB : 0 < boundary := lt_trans (by norm_num) boundary_gt_two
  have hp : 0 < b := hB.trans hb
  have hr : 0 ≤ boundary/b ∧ boundary/b < 1 :=
    ⟨div_nonneg hB.le hp.le,(div_lt_one hp).mpr hb⟩
  have hh := quartic_contraction hc hr
  rw [div_mul_cancel₀ boundary (ne_of_gt hp)] at hh
  exact no_strict_at_boundary hh

theorem strict_iff {b : ℝ} (hb : 0 ≤ b) :
    (∃ c, StrictQuarticCertificate b c) ↔ b < boundary := by
  refine ⟨?_,strict_below_boundary hb⟩
  rintro ⟨c,hc⟩
  by_contra hn
  rcases eq_or_lt_of_le (le_of_not_gt hn) with he|he
  · subst b
    exact no_strict_at_boundary ⟨c,hc⟩
  · exact no_weak_above_boundary he ⟨c,strict_weak hc⟩

theorem weak_iff {b : ℝ} (hb : 0 ≤ b) :
    (∃ c, WeakQuarticCertificate b c) ↔ b ≤ boundary := by
  refine ⟨?_,?_⟩
  · intro hc
    by_contra hh
    exact no_weak_above_boundary (lt_of_not_ge hh) hc
  · intro h
    rcases lt_or_eq_of_le h with h|h
    · obtain ⟨c,hc⟩ := strict_below_boundary hb h
      exact ⟨c,strict_weak hc⟩
    · subst b
      exact ⟨endpointCoefficients,endpoint_weak⟩

/-- Quarter-turn of the polynomial coefficients. -/
def quarterTurn (c : Coeff) : Coeff := ![c 4,-c 3,c 2,-c 1,c 0]

theorem quarterTurn_value (c : Coeff) (x y : ℝ) :
    quartic (quarterTurn c) x y = quartic c (-y) x := by
  simp [quartic,quarterTurn]; ring

theorem quarterTurn_lie (b : ℝ) (c : Coeff) (x y : ℝ) :
    lie (-b) (quarterTurn c) x y = lie b c (-y) x := by
  simp [lie_eq,gradient,field,quarterTurn]; ring

theorem quarterTurn_nonzero {x y : ℝ} (h : x ≠ 0 ∨ y ≠ 0) : -y ≠ 0 ∨ x ≠ 0 :=
  h.elim Or.inr (fun hy => Or.inl (neg_ne_zero.mpr hy))

theorem strict_quarterTurn {b : ℝ} {c : Coeff} (h : StrictQuarticCertificate b c) :
    StrictQuarticCertificate (-b) (quarterTurn c) := by
  constructor
  · intro x y hxy
    rw [quarterTurn_value]
    exact h.1 (-y) x (quarterTurn_nonzero hxy)
  · intro x y hxy
    rw [quarterTurn_lie]
    exact h.2 (-y) x (quarterTurn_nonzero hxy)

theorem weak_quarterTurn {b : ℝ} {c : Coeff} (h : WeakQuarticCertificate b c) :
    WeakQuarticCertificate (-b) (quarterTurn c) := by
  constructor
  · intro x y hxy
    rw [quarterTurn_value]
    exact h.1 (-y) x (quarterTurn_nonzero hxy)
  · intro x y hxy
    rw [quarterTurn_lie]
    exact h.2 (-y) x (quarterTurn_nonzero hxy)

theorem strict_iff_abs (b : ℝ) : (∃ c, StrictQuarticCertificate b c) ↔ |b| < boundary := by
  by_cases hb : 0 ≤ b
  · simpa [abs_of_nonneg hb] using strict_iff hb
  · rw [abs_of_neg (lt_of_not_ge hb)]
    constructor
    · rintro ⟨c,hc⟩
      exact (strict_iff (by linarith : 0 ≤ -b)).mp ⟨quarterTurn c,strict_quarterTurn hc⟩
    · intro h
      obtain ⟨c,hc⟩ := (strict_iff (by linarith : 0 ≤ -b)).mpr h
      exact ⟨quarterTurn c,by simpa using strict_quarterTurn hc⟩

theorem weak_iff_abs (b : ℝ) : (∃ c, WeakQuarticCertificate b c) ↔ |b| ≤ boundary := by
  by_cases hb : 0 ≤ b
  · simpa [abs_of_nonneg hb] using weak_iff hb
  · rw [abs_of_neg (lt_of_not_ge hb)]
    constructor
    · rintro ⟨c,hc⟩
      exact (weak_iff (by linarith : 0 ≤ -b)).mp ⟨quarterTurn c,weak_quarterTurn hc⟩
    · intro h
      obtain ⟨c,hc⟩ := (weak_iff (by linarith : 0 ≤ -b)).mpr h
      exact ⟨quarterTurn c,by simpa using weak_quarterTurn hc⟩

end QuarticLyapunov
