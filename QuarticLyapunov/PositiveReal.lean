module
public import QuarticLyapunov.Basic

/-! Strict positivity inside a disk from nonnegative real boundary values. -/
public noncomputable section
namespace QuarticLyapunov
open Complex Metric Set

theorem positive_real_in_disk {F : ℂ → ℂ}
    (hF : DiffContOnCl ℂ F (ball 0 1))
    (hb : ∀ z : ℂ, ‖z‖ = 1 → 0 ≤ (F z).re)
    (h0 : 0 < (F 0).re) {z : ℂ} (hz : ‖z‖ < 1) : 0 < (F z).re := by
  let g : ℂ → ℂ := fun w => Complex.exp (-F w)
  have hg : DiffContOnCl ℂ g (ball 0 1) := by
    exact ⟨fun w hw => ((hF.differentiableOn w hw).neg.cexp),
      (hF.continuousOn.neg.cexp)⟩
  have hnorm : ∀ w ∈ closedBall (0:ℂ) 1, ‖g w‖ ≤ 1 := by
    intro w hw
    apply Complex.norm_le_of_forall_mem_frontier_norm_le isBounded_ball hg
    · intro u hu
      rw [frontier_ball (0:ℂ) (by norm_num : (1:ℝ) ≠ 0)] at hu
      have hu' : ‖u‖ = 1 := by simpa [mem_sphere,dist_zero_right] using hu
      simpa [g,Complex.norm_exp,Complex.neg_re] using
        (Real.exp_le_one_iff.mpr (neg_nonpos.mpr (hb u hu')))
    · simpa [closure_ball (0:ℂ) (by norm_num : (1:ℝ) ≠ 0)] using hw
  have hzball : z ∈ ball (0:ℂ) 1 := by simpa [mem_ball,dist_zero_right] using hz
  have hle := hnorm z (ball_subset_closedBall hzball)
  have hre : 0 ≤ (F z).re := by
    have he : Real.exp (-(F z).re) ≤ 1 := by simpa [g,Complex.norm_exp] using hle
    exact neg_nonpos.mp (Real.exp_le_one_iff.mp he)
  by_contra hh
  have he : (F z).re = 0 := le_antisymm (le_of_not_gt hh) hre
  have hgz : ‖g z‖ = 1 := by simp [g,Complex.norm_exp,he]
  have hm : IsMaxOn (norm ∘ g) (ball (0:ℂ) 1) z := by
    intro w hw
    change ‖g w‖ ≤ ‖g z‖
    rw [hgz]
    exact hnorm w (ball_subset_closedBall hw)
  have hconst := Complex.norm_eqOn_of_isPreconnected_of_isMaxOn
    (convex_ball (0:ℂ) 1).isPreconnected isOpen_ball hg.differentiableOn hzball hm
  have hh0 := hconst (show (0:ℂ) ∈ ball 0 1 by simp)
  have hnorm0 : ‖g 0‖ < 1 := by
    simpa [g,Complex.norm_exp] using Real.exp_lt_one_iff.mpr (neg_neg_of_pos h0)
  simp only [Function.comp_apply,Function.const_apply,hgz] at hh0
  linarith

end QuarticLyapunov
