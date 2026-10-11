module
public import QuarticLyapunov.EndpointIdentities
public import QuarticLyapunov.EndpointSigns

/-! The explicit positive quartic whose negative Lie derivative is a cubic square. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

/-- Algebraic coefficient vector in the fixed monic-cubic-square normalization. -/
def endpointCoefficients : Coeff :=
  ![Endpoint.p0, Endpoint.p1, Endpoint.p2, Endpoint.p3, Endpoint.p4]

/-- The monic binary cubic whose square is the endpoint negative derivative. -/
def endpointCubic (x y : ℝ) : ℝ :=
  Endpoint.h0*x^3+Endpoint.h1*x^2*y+Endpoint.h2*x*y^2+Endpoint.h3*y^3

theorem endpoint_sos (x y : ℝ) : quartic endpointCoefficients x y =
    Endpoint.d0*(x^2+Endpoint.l10*x*y+Endpoint.l20*y^2)^2 +
    Endpoint.d1*(x*y+Endpoint.l21*y^2)^2+Endpoint.d2*y^4 := by
  simp only [quartic, endpointCoefficients, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val, Matrix.head_cons, Matrix.tail_cons,
    Matrix.empty_val']
  linear_combination -(x^4)*Endpoint.sos0 - (x^3*y)*Endpoint.sos1 -
    (x^2*y^2)*Endpoint.sos2 - (x*y^3)*Endpoint.sos3 - (y^4)*Endpoint.sos4

theorem endpoint_negative_lie_square (x y : ℝ) :
    -lie boundary endpointCoefficients x y = (endpointCubic x y)^2 := by
  rw [lie_eq]
  simp only [gradient, field, endpointCoefficients, endpointCubic,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val,
    Matrix.head_cons, Matrix.tail_cons, Matrix.empty_val']
  linear_combination (x^6)*Endpoint.lie0 + (x^5*y)*Endpoint.lie1 +
    (x^4*y^2)*Endpoint.lie2 + (x^3*y^3)*Endpoint.lie3 +
    (x^2*y^4)*Endpoint.lie4 + (x*y^5)*Endpoint.lie5 + (y^6)*Endpoint.lie6

theorem endpoint_positive : PositiveQuartic endpointCoefficients := by
  intro x y hxy
  rw [endpoint_sos]
  have hd0 := Endpoint.d0_pos
  have hd1 := Endpoint.d1_pos
  have hd2 := Endpoint.d2_pos
  by_cases hy : y = 0
  · subst y
    have hx := hxy.resolve_right (not_not_intro rfl)
    have hh : 0 < (x^2)^2 := sq_pos_of_ne_zero (pow_ne_zero 2 hx)
    simpa using mul_pos hd0 hh
  · have hy4 : 0 < y^4 := by
      simpa [← pow_mul] using pow_pos (sq_pos_of_ne_zero hy) 2
    have hlast := mul_pos hd2 hy4
    have ha := mul_nonneg hd0.le (sq_nonneg (x^2+Endpoint.l10*x*y+Endpoint.l20*y^2))
    have hb := mul_nonneg hd1.le (sq_nonneg (x*y+Endpoint.l21*y^2))
    linarith

theorem endpoint_weak : WeakQuarticCertificate boundary endpointCoefficients := by
  refine ⟨endpoint_positive, ?_⟩
  intro x y _
  have he := endpoint_negative_lie_square x y
  nlinarith [sq_nonneg (endpointCubic x y)]

end QuarticLyapunov
