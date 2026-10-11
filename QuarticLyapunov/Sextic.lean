module
public import QuarticLyapunov.AtomicDual

/-! Elementary rigidity of a nonnegative sextic with three double roots. -/
public noncomputable section
namespace QuarticLyapunov
open Polynomial

theorem double_root_of_nonnegative (q : ℝ[X]) (hn : ∀ z : ℝ, 0 ≤ q.eval z)
    (r : ℝ) (hr : q.eval r = 0) : (X-C r)^2 ∣ q := by
  by_cases hq : q = 0
  · simp [hq]
  have hmin : IsLocalMin (fun z : ℝ => q.eval z) r :=
    Filter.Eventually.of_forall (fun z => by change q.eval r ≤ q.eval z; rw [hr]; exact hn z)
  have hd : q.derivative.eval r = 0 := hmin.hasDerivAt_eq_zero (q.hasDerivAt r)
  exact (le_rootMultiplicity_iff hq).mp
    ((one_lt_rootMultiplicity_iff_isRoot hq).mpr ⟨hr,hd⟩)

theorem nonnegative_sextic_three_roots (q : ℝ[X]) (hn : ∀ z : ℝ, 0 ≤ q.eval z)
    (hd : q.natDegree ≤ 6) (r s t : ℝ) (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t)
    (hr : q.eval r = 0) (hs : q.eval s = 0) (ht : q.eval t = 0) :
    q = ((X-C r)*(X-C s)*(X-C t))^2 * C q.leadingCoeff := by
  have h1 := double_root_of_nonnegative q hn r hr
  have h2 := double_root_of_nonnegative q hn s hs
  have h3 := double_root_of_nonnegative q hn t ht
  have hc12 : IsCoprime ((X-C r)^2) ((X-C s)^2) :=
    (isCoprime_X_sub_C_of_isUnit_sub (sub_ne_zero.mpr hrs).isUnit).pow
  have hc13 : IsCoprime ((X-C r)^2) ((X-C t)^2) :=
    (isCoprime_X_sub_C_of_isUnit_sub (sub_ne_zero.mpr hrt).isUnit).pow
  have hc23 : IsCoprime ((X-C s)^2) ((X-C t)^2) :=
    (isCoprime_X_sub_C_of_isUnit_sub (sub_ne_zero.mpr hst).isUnit).pow
  have hdvd : ((X-C r)*(X-C s)*(X-C t))^2 ∣ q := by
    simpa [mul_pow] using (hc13.mul_left hc23).mul_dvd (hc12.mul_dvd h1 h2) h3
  have hm : Monic (((X-C r)*(X-C s)*(X-C t))^2) :=
    (((monic_X_sub_C r).mul (monic_X_sub_C s)).mul (monic_X_sub_C t)).pow 2
  apply eq_mul_leadingCoeff_of_monic_of_dvd_of_natDegree_le hm hdvd
  have hnd : (((X-C r)*(X-C s)*(X-C t))^2 : ℝ[X]).natDegree = 6 := by compute_degree!
  rwa [hnd]

end QuarticLyapunov
