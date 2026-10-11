module
public import QuarticLyapunov.SpectralDerivative

/-! Every weak quartic at B supplies strict quartics at all nonnegative smaller parameters. -/
public noncomputable section
namespace QuarticLyapunov
open Complex Metric Set
open scoped ComplexConjugate

theorem quartic_injective {c d : Coeff}
    (h : ∀ x y : ℝ, quartic c x y = quartic d x y) : c = d := by
  have h0 := h 1 0
  have h4 := h 0 1
  have h1 := h 1 1
  have h2 := h 1 (-1)
  have h3 := h 1 2
  norm_num [quartic] at h0 h1 h2 h3 h4
  funext i
  fin_cases i
  · change c 0 = d 0
    linarith
  · change c 1 = d 1
    linarith
  · change c 2 = d 2
    linarith
  · change c 3 = d 3
    linarith
  · change c 4 = d 4
    linarith

theorem quartic_smul (k : ℝ) (c : Coeff) (x y : ℝ) :
    quartic (fun i => k*c i) x y = k*quartic c x y := by
  unfold quartic; ring

theorem lie_smul (k b : ℝ) (c : Coeff) (x y : ℝ) :
    lie b (fun i => k*c i) x y = k*lie b c x y := by
  simp only [lie_eq,gradient]; ring

theorem phase_surjective {z : ℂ} (hz : ‖z‖ = 1) :
    ∃ x y : ℝ, (x ≠ 0 ∨ y ≠ 0) ∧ phase x y = z := by
  let w := Complex.sqrt z
  have hw2 : w^2=z := by
    simpa [w,Complex.sqrt] using Complex.cpow_nat_inv_pow z (by norm_num : (2:ℕ)≠0)
  have hnormsq : ‖w‖^2=1 := by rw [← norm_pow,hw2,hz]
  have hnorm : ‖w‖=1 := by nlinarith [norm_nonneg w]
  have hw : w ≠ 0 := by intro he; simp [he] at hnorm
  have hxy : w.re ≠ 0 ∨ w.im ≠ 0 := by
    by_contra hh
    push_neg at hh
    apply hw
    apply Complex.ext <;> simp [hh.1,hh.2]
  refine ⟨w.re,w.im,hxy,?_⟩
  have hp : plane w.re w.im=w := by simp [plane]
  have hc : conj w ≠ 0 := by simpa using hw
  have hu : w*conj w=1 := by simp [Complex.mul_conj,Complex.normSq_eq_norm_sq,hnorm]
  rw [phase,hp,div_eq_iff hc,← hw2]
  calc
    w = w*(w*conj w) := by rw [hu,mul_one]
    _ = w^2*conj w := by ring

theorem positiveRealFunction_diffCont {B a s d t : ℝ} (hs : 0 < s) (ht : 0 < t) :
    DiffContOnCl ℂ (positiveRealFunction B a s d t) (ball 0 1) := by
  have hQ (a s : ℝ) (hs : 0 < s) :
      ∀ z ∈ closedBall (0:ℂ) 1, outerQ a s z ≠ 0 := by
    intro z hz
    apply outerQ_ne_zero hs
    simpa [mem_closedBall,dist_zero_right] using hz
  constructor
  · intro z hz
    have hn1 := hQ a s hs z (ball_subset_closedBall hz)
    have hn2 := hQ d t ht z (ball_subset_closedBall hz)
    unfold positiveRealFunction logTerm outerQ
    fun_prop (disch := assumption)
  · rw [closure_ball (0:ℂ) one_ne_zero]
    unfold positiveRealFunction logTerm outerQ
    fun_prop (disch := aesop)

theorem contracted_weak_at_one {B a s d t : ℝ} (hs : 0 < s) (ht : 0 < t)
    (hweak : WeakQuarticCertificate B (contractedCoefficients a s d t 1))
    {z : ℂ} (hz : ‖z‖=1) : 0 ≤ (positiveRealFunction B a s d t z).re := by
  obtain ⟨x,y,hxy,hphase⟩ := phase_surjective hz
  have hid := contracted_lie_identity (B := B) (a := a) (d := d) hs ht
    (show (0:ℝ) ≤ 1 ∧ (1:ℝ) ≤ 1 by norm_num) hxy
  norm_num only [one_mul,Complex.ofReal_one] at hid
  rw [hphase] at hid
  have hr : 0 < x^2+y^2 := hxy.elim
    (fun h => add_pos_of_pos_of_nonneg (sq_pos_of_ne_zero h) (sq_nonneg y))
    (fun h => add_pos_of_nonneg_of_pos (sq_nonneg x) (sq_pos_of_ne_zero h))
  have hp := hweak.1 x y hxy
  have hd := hweak.2 x y hxy
  have hfac : 0 < 4*(x^2+y^2)*quartic (contractedCoefficients a s d t 1) x y := by positivity
  exact nonneg_of_mul_nonneg_left (by linarith [hid]) hfac

theorem quartic_contraction {B : ℝ} {c : Coeff} (hc : WeakQuarticCertificate B c)
    {ρ : ℝ} (hρ : 0 ≤ ρ ∧ ρ < 1) :
    ∃ d : Coeff, StrictQuarticCertificate (ρ*B) d := by
  obtain ⟨k,a,s,d,t,hk,hs,ht,hfac⟩ := positive_quartic_factorization hc.1
  have hcoeff : c = fun i => (k/16)*contractedCoefficients a s d t 1 i := by
    apply quartic_injective
    intro x y
    rw [quartic_smul,contracted_product,factorForm_one,factorForm_one,hfac]
    ring
  have hweak : WeakQuarticCertificate B (contractedCoefficients a s d t 1) := by
    refine ⟨contracted_positive hs ht (by norm_num),?_⟩
    intro x y hxy
    have hd := hc.2 x y hxy
    rw [hcoeff,lie_smul] at hd
    have hk16 : 0 < k/16 := by positivity
    nlinarith
  refine ⟨contractedCoefficients a s d t ρ,contracted_positive hs ht ⟨hρ.1,hρ.2.le⟩,?_⟩
  intro x y hxy
  have hnorm : ‖(ρ:ℂ)*phase x y‖ < 1 := by
    simpa [norm_mul,Complex.norm_real,Real.norm_eq_abs,abs_of_nonneg hρ.1,phase_norm hxy] using hρ.2
  have hpos := positive_real_in_disk (positiveRealFunction_diffCont (B := B) (a := a) (d := d) hs ht)
    (fun z hz => contracted_weak_at_one hs ht hweak hz)
    (by simp [positiveRealFunction,logTerm]) hnorm
  have hid := contracted_lie_identity (B := B) (a := a) (d := d) hs ht ⟨hρ.1,hρ.2.le⟩ hxy
  have hp := contracted_positive (a := a) (d := d) hs ht ⟨hρ.1,hρ.2.le⟩ x y hxy
  have hr : 0 < x^2+y^2 := hxy.elim
    (fun h => add_pos_of_pos_of_nonneg (sq_pos_of_ne_zero h) (sq_nonneg y))
    (fun h => add_pos_of_nonneg_of_pos (sq_nonneg x) (sq_pos_of_ne_zero h))
  have hh : 0 < 4*(x^2+y^2)*quartic (contractedCoefficients a s d t ρ) x y *
      (positiveRealFunction B a s d t (ρ*phase x y)).re := by positivity
  linarith

end QuarticLyapunov
