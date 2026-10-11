module
public import QuarticLyapunov.Sextic

/-! The full derivative map and its injectivity at the algebraic endpoint. -/
@[expose] public noncomputable section
namespace QuarticLyapunov
open Polynomial

def negativeCoefficients (b : ℝ) (c : Coeff) : Fin 7 → ℝ :=
  ![((4-4*b)*c 0-c 1),
    (4*c 0+(4-4*b)*c 1-2*c 2),
    ((4+4*b)*c 0+2*c 1+(4-4*b)*c 2-3*c 3),
    (4*c 0+(4+4*b)*c 1+(4-4*b)*c 3-4*c 4),
    (3*c 1+(4+4*b)*c 2-2*c 3+(4-4*b)*c 4),
    (2*c 2+(4+4*b)*c 3-4*c 4),
    (c 3+(4+4*b)*c 4)]

def sexticPolynomial (b : ℝ) (c : Coeff) : ℝ[X] :=
  C (negativeCoefficients b c 0)*X^0 +
    C (negativeCoefficients b c 1)*X^1 +
    C (negativeCoefficients b c 2)*X^2 +
    C (negativeCoefficients b c 3)*X^3 +
    C (negativeCoefficients b c 4)*X^4 +
    C (negativeCoefficients b c 5)*X^5 +
    C (negativeCoefficients b c 6)*X^6

theorem sextic_eval (b : ℝ) (c : Coeff) (z : ℝ) :
    (sexticPolynomial b c).eval z = -lie b c 1 z := by
  rw [lie_eq]
  simp [sexticPolynomial, negativeCoefficients, field, gradient]; ring

theorem sextic_degree (b : ℝ) (c : Coeff) :
    (sexticPolynomial b c).natDegree ≤ 6 := by
  unfold sexticPolynomial
  compute_degree!

theorem sextic_coeff (b : ℝ) (c : Coeff) (i : Fin 7) :
    (sexticPolynomial b c).coeff i = negativeCoefficients b c i := by
  fin_cases i <;> simp [sexticPolynomial]

theorem rank_identity0 (c : Coeff) : Endpoint.detM*c 0 =
    (256*boundary^4 - 1024*boundary^3 + 1184*boundary^2 - 896*boundary + 520)*negativeCoefficients boundary c 0 +
    (-64*boundary^3 + 192*boundary^2 - 112*boundary + 80)*negativeCoefficients boundary c 1 +
    (32*boundary^2 - 64*boundary + 16)*negativeCoefficients boundary c 2 +
    (24 - 24*boundary)*negativeCoefficients boundary c 3 +
    (24)*negativeCoefficients boundary c 4 := by
  simp [Endpoint.detM, negativeCoefficients]; ring

theorem rank_identity1 (c : Coeff) : Endpoint.detM*c 1 =
    (128*boundary^3 - 640*boundary^2 + 736*boundary - 480)*negativeCoefficients boundary c 0 +
    (256*boundary^4 - 1024*boundary^3 + 1216*boundary^2 - 768*boundary + 320)*negativeCoefficients boundary c 1 +
    (-128*boundary^3 + 384*boundary^2 - 320*boundary + 64)*negativeCoefficients boundary c 2 +
    (96*boundary^2 - 192*boundary + 96)*negativeCoefficients boundary c 3 +
    (96 - 96*boundary)*negativeCoefficients boundary c 4 := by
  simp [Endpoint.detM, negativeCoefficients]; ring

theorem rank_identity2 (c : Coeff) : Endpoint.detM*c 2 =
    (256*boundary^4 - 512*boundary^3 - 384*boundary^2 + 640*boundary + 80)*negativeCoefficients boundary c 0 +
    (-128*boundary^3 - 128*boundary^2 + 800*boundary - 480)*negativeCoefficients boundary c 1 +
    (256*boundary^4 - 1024*boundary^3 + 1472*boundary^2 - 896*boundary + 160)*negativeCoefficients boundary c 2 +
    (-192*boundary^3 + 576*boundary^2 - 624*boundary + 240)*negativeCoefficients boundary c 3 +
    (192*boundary^2 - 384*boundary + 240)*negativeCoefficients boundary c 4 := by
  simp [Endpoint.detM, negativeCoefficients]; ring

theorem rank_identity3 (c : Coeff) : Endpoint.detM*c 3 =
    (128*boundary^3 - 1408*boundary^2 + 736*boundary + 480)*negativeCoefficients boundary c 0 +
    (256*boundary^4 - 512*boundary^3 - 320*boundary^2 + 1152*boundary - 320)*negativeCoefficients boundary c 1 +
    (-384*boundary^3 + 384*boundary^2 + 448*boundary - 576)*negativeCoefficients boundary c 2 +
    (256*boundary^4 - 1024*boundary^3 + 1632*boundary^2 - 1280*boundary + 416)*negativeCoefficients boundary c 3 +
    (-256*boundary^3 + 768*boundary^2 - 864*boundary + 416)*negativeCoefficients boundary c 4 := by
  simp [Endpoint.detM, negativeCoefficients]; ring

theorem rank_identity4 (c : Coeff) : Endpoint.detM*c 4 =
    (256*boundary^4 - 864*boundary^2 - 384*boundary + 520)*negativeCoefficients boundary c 0 +
    (-64*boundary^3 - 832*boundary^2 + 912*boundary + 80)*negativeCoefficients boundary c 1 +
    (256*boundary^4 - 512*boundary^3 + 32*boundary^2 + 704*boundary - 496)*negativeCoefficients boundary c 2 +
    (-320*boundary^3 + 576*boundary^2 - 216*boundary - 104)*negativeCoefficients boundary c 3 +
    (256*boundary^4 - 1024*boundary^3 + 1536*boundary^2 - 1280*boundary + 536)*negativeCoefficients boundary c 4 := by
  simp [Endpoint.detM, negativeCoefficients]; ring

theorem negativeCoefficients_injective : Function.Injective (negativeCoefficients boundary) := by
  intro c d he
  have hd : Endpoint.detM ≠ 0 := ne_of_gt Endpoint.detM_pos
  funext i
  fin_cases i
  · have hc := rank_identity0 c
    have hh := rank_identity0 d
    rw [he] at hc
    exact (mul_left_cancel₀ hd) (hc.trans hh.symm)
  · have hc := rank_identity1 c
    have hh := rank_identity1 d
    rw [he] at hc
    exact (mul_left_cancel₀ hd) (hc.trans hh.symm)
  · have hc := rank_identity2 c
    have hh := rank_identity2 d
    rw [he] at hc
    exact (mul_left_cancel₀ hd) (hc.trans hh.symm)
  · have hc := rank_identity3 c
    have hh := rank_identity3 d
    rw [he] at hc
    exact (mul_left_cancel₀ hd) (hc.trans hh.symm)
  · have hc := rank_identity4 c
    have hh := rank_identity4 d
    rw [he] at hc
    exact (mul_left_cancel₀ hd) (hc.trans hh.symm)

theorem negativeCoefficients_smul (k b : ℝ) (c : Coeff) :
    negativeCoefficients b (fun i => k*c i) = fun i => k*negativeCoefficients b c i := by
  funext i
  fin_cases i <;> simp [negativeCoefficients] <;> ring

end QuarticLyapunov
