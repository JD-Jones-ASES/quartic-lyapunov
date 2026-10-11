module
public import QuarticLyapunov.CubicRoots

/-! A positive three-point representation of the endpoint dual. -/
public noncomputable section
namespace QuarticLyapunov

/-- The first five moments evaluate the square of a general quadratic. -/
def momentSquare (a b c : ℝ) : ℝ :=
  Endpoint.v0*a^2+2*Endpoint.v1*a*b+Endpoint.v2*(b^2+2*a*c)+
    2*Endpoint.v3*b*c+Endpoint.v4*c^2

theorem momentSquare_pos (a b c : ℝ) (hc : c ≠ 0) : 0 < momentSquare a b c := by
  have he : momentSquare a b c =
      Endpoint.md0*(a+Endpoint.ml10*b+Endpoint.ml20*c)^2+
      Endpoint.md1*(b+Endpoint.ml21*c)^2+Endpoint.md2*c^2 := by
    unfold momentSquare
    linear_combination -(a^2)*Endpoint.msos0 - (2*a*b)*Endpoint.msos1 -
      (2*a*c)*Endpoint.msos2 - (b^2)*Endpoint.msos3 -
      (2*b*c)*Endpoint.msos4 - (c^2)*Endpoint.msos5
  rw [he]
  have ha := mul_nonneg Endpoint.md0_pos.le (sq_nonneg (a+Endpoint.ml10*b+Endpoint.ml20*c))
  have hb := mul_nonneg Endpoint.md1_pos.le (sq_nonneg (b+Endpoint.ml21*c))
  have hd := mul_pos Endpoint.md2_pos (sq_pos_of_ne_zero hc)
  linarith

/-- Elementary Vandermonde weights matching three prescribed moments. -/
def atomWeight (v₀ v₁ v₂ r s t : ℝ) : ℝ :=
  (v₂-(s+t)*v₁+s*t*v₀)/((r-s)*(r-t))

theorem atom_first_moments (v₀ v₁ v₂ r s t : ℝ)
    (hrs : r ≠ s) (hrt : r ≠ t) (hst : s ≠ t) :
    let w₁ := atomWeight v₀ v₁ v₂ r s t
    let w₂ := atomWeight v₀ v₁ v₂ s r t
    let w₃ := atomWeight v₀ v₁ v₂ t r s
    w₁+w₂+w₃=v₀ ∧ w₁*r+w₂*s+w₃*t=v₁ ∧ w₁*r^2+w₂*s^2+w₃*t^2=v₂ := by
  dsimp [atomWeight]
  have hsr := Ne.symm hrs
  have htr := Ne.symm hrt
  have hts := Ne.symm hst
  constructor
  · field_simp <;> ring
  constructor <;> field_simp <;> ring


/-- Moment of a finite three-point measure. -/
def atomMoment (r s t w₁ w₂ w₃ : ℝ) (n : ℕ) : ℝ := w₁*r^n+w₂*s^n+w₃*t^n

theorem atom_recurrence {a b c r s t w₁ w₂ w₃ : ℝ}
    (hr : a+b*r+c*r^2+r^3=0) (hs : a+b*s+c*s^2+s^3=0)
    (ht : a+b*t+c*t^2+t^3=0) (n : ℕ) :
    atomMoment r s t w₁ w₂ w₃ (n+3) + c*atomMoment r s t w₁ w₂ w₃ (n+2) +
    b*atomMoment r s t w₁ w₂ w₃ (n+1) + a*atomMoment r s t w₁ w₂ w₃ n = 0 := by
  simp only [atomMoment, pow_add]
  linear_combination (w₁*r^n)*hr+(w₂*s^n)*hs+(w₃*t^n)*ht

/-- Positive atomic representation, derived from the exact endpoint data. -/
structure EndpointAtoms where
  r : ℝ
  s : ℝ
  t : ℝ
  w₁ : ℝ
  w₂ : ℝ
  w₃ : ℝ
  hrs : r < s
  hst : s < t
  hw₁ : 0 < w₁
  hw₂ : 0 < w₂
  hw₃ : 0 < w₃
  hr : endpointCubic 1 r = 0
  hs : endpointCubic 1 s = 0
  ht : endpointCubic 1 t = 0
  m0 : atomMoment r s t w₁ w₂ w₃ 0 = Endpoint.v0
  m1 : atomMoment r s t w₁ w₂ w₃ 1 = Endpoint.v1
  m2 : atomMoment r s t w₁ w₂ w₃ 2 = Endpoint.v2
  m3 : atomMoment r s t w₁ w₂ w₃ 3 = Endpoint.v3
  m4 : atomMoment r s t w₁ w₂ w₃ 4 = Endpoint.v4
  m5 : atomMoment r s t w₁ w₂ w₃ 5 = Endpoint.v5
  m6 : atomMoment r s t w₁ w₂ w₃ 6 = Endpoint.v6

/-- Existence uses exact isolated roots and a positive definite moment form. -/
theorem exists_endpointAtoms : Nonempty EndpointAtoms := by
  obtain ⟨r,s,t,hrange,srange,trange,hr,hs,ht⟩ := endpoint_three_roots
  have hrs : r < s := by linarith [hrange.2,srange.1]
  have hst : s < t := by linarith [srange.2,trange.1]
  have hrt : r < t := hrs.trans hst
  let w₁ := atomWeight Endpoint.v0 Endpoint.v1 Endpoint.v2 r s t
  let w₂ := atomWeight Endpoint.v0 Endpoint.v1 Endpoint.v2 s r t
  let w₃ := atomWeight Endpoint.v0 Endpoint.v1 Endpoint.v2 t r s
  have hh := atom_first_moments Endpoint.v0 Endpoint.v1 Endpoint.v2 r s t
    (ne_of_lt hrs) (ne_of_lt hrt) (ne_of_lt hst)
  have m0 : atomMoment r s t w₁ w₂ w₃ 0 = Endpoint.v0 := by simpa [atomMoment] using hh.1
  have m1 : atomMoment r s t w₁ w₂ w₃ 1 = Endpoint.v1 := by simpa [atomMoment] using hh.2.1
  have m2 : atomMoment r s t w₁ w₂ w₃ 2 = Endpoint.v2 := hh.2.2
  have er : Endpoint.h0+Endpoint.h1*r+Endpoint.h2*r^2+r^3=0 := by
    simpa [endpointCubic,Endpoint.h3] using hr
  have es : Endpoint.h0+Endpoint.h1*s+Endpoint.h2*s^2+s^3=0 := by
    simpa [endpointCubic,Endpoint.h3] using hs
  have et : Endpoint.h0+Endpoint.h1*t+Endpoint.h2*t^2+t^3=0 := by
    simpa [endpointCubic,Endpoint.h3] using ht
  have m3 : atomMoment r s t w₁ w₂ w₃ 3 = Endpoint.v3 := by
    have hh := atom_recurrence (w₁ := w₁) (w₂ := w₂) (w₃ := w₃) er es et 0
    norm_num only [Nat.reduceAdd] at hh
    rw [m2,m1,m0] at hh
    have hk := Endpoint.kernel0
    norm_num only [Endpoint.h3, mul_one, zero_add] at hk
    linear_combination hh-hk
  have m4 : atomMoment r s t w₁ w₂ w₃ 4 = Endpoint.v4 := by
    have hh := atom_recurrence (w₁ := w₁) (w₂ := w₂) (w₃ := w₃) er es et 1
    norm_num only [Nat.reduceAdd] at hh
    rw [m3,m2,m1] at hh
    have hk := Endpoint.kernel1
    norm_num only [Endpoint.h3, mul_one, zero_add] at hk
    linear_combination hh-hk
  have m5 : atomMoment r s t w₁ w₂ w₃ 5 = Endpoint.v5 := by
    have hh := atom_recurrence (w₁ := w₁) (w₂ := w₂) (w₃ := w₃) er es et 2
    norm_num only [Nat.reduceAdd] at hh
    rw [m4,m3,m2] at hh
    have hk := Endpoint.kernel2
    norm_num only [Endpoint.h3, mul_one, zero_add] at hk
    linear_combination hh-hk
  have m6 : atomMoment r s t w₁ w₂ w₃ 6 = Endpoint.v6 := by
    have hh := atom_recurrence (w₁ := w₁) (w₂ := w₂) (w₃ := w₃) er es et 3
    norm_num only [Nat.reduceAdd] at hh
    rw [m5,m4,m3] at hh
    have hk := Endpoint.kernel3
    norm_num only [Endpoint.h3, mul_one, zero_add] at hk
    linear_combination hh-hk
  have hw1 : 0 < w₁ := by
    have hp := momentSquare_pos (s*t) (-(s+t)) 1 one_ne_zero
    have he : momentSquare (s*t) (-(s+t)) 1 =
        w₁*((r-s)*(r-t))^2 := by
      unfold momentSquare
      simp only [atomMoment] at m0 m1 m2 m3 m4
      linear_combination -(s^2*t^2)*m0 + (2*s*t*(s+t))*m1 -
        ((s+t)^2+2*s*t)*m2 + (2*(s+t))*m3-m4
    rw [he] at hp
    exact pos_of_mul_pos_left hp (sq_nonneg _)
  have hw2 : 0 < w₂ := by
    have hp := momentSquare_pos (r*t) (-(r+t)) 1 one_ne_zero
    have he : momentSquare (r*t) (-(r+t)) 1 =
        w₂*((s-r)*(s-t))^2 := by
      unfold momentSquare
      simp only [atomMoment] at m0 m1 m2 m3 m4
      linear_combination -(r^2*t^2)*m0 + (2*r*t*(r+t))*m1 -
        ((r+t)^2+2*r*t)*m2 + (2*(r+t))*m3-m4
    rw [he] at hp
    exact pos_of_mul_pos_left hp (sq_nonneg _)
  have hw3 : 0 < w₃ := by
    have hp := momentSquare_pos (r*s) (-(r+s)) 1 one_ne_zero
    have he : momentSquare (r*s) (-(r+s)) 1 =
        w₃*((t-r)*(t-s))^2 := by
      unfold momentSquare
      simp only [atomMoment] at m0 m1 m2 m3 m4
      linear_combination -(r^2*s^2)*m0 + (2*r*s*(r+s))*m1 -
        ((r+s)^2+2*r*s)*m2 + (2*(r+s))*m3-m4
    rw [he] at hp
    exact pos_of_mul_pos_left hp (sq_nonneg _)
  exact ⟨⟨r,s,t,w₁,w₂,w₃,hrs,hst,hw1,hw2,hw3,hr,hs,ht,m0,m1,m2,m3,m4,m5,m6⟩⟩

def endpointAtoms : EndpointAtoms := Classical.choice exists_endpointAtoms

theorem atomic_dual_annihilates (a : EndpointAtoms) (c : Coeff) :
    a.w₁ * (-lie boundary c 1 a.r) + a.w₂ * (-lie boundary c 1 a.s) +
      a.w₃ * (-lie boundary c 1 a.t) = 0 := by
  simp only [lie_eq, gradient, field]
  have m0 := a.m0
  have m1 := a.m1
  have m2 := a.m2
  have m3 := a.m3
  have m4 := a.m4
  have m5 := a.m5
  have m6 := a.m6
  simp only [atomMoment] at m0 m1 m2 m3 m4 m5 m6
  linear_combination ((4-4*boundary)*c 0-c 1)*m0 +
    (4*c 0+(4-4*boundary)*c 1-2*c 2)*m1 +
    ((4+4*boundary)*c 0+2*c 1+(4-4*boundary)*c 2-3*c 3)*m2 +
    (4*c 0+(4+4*boundary)*c 1+(4-4*boundary)*c 3-4*c 4)*m3 +
    (3*c 1+(4+4*boundary)*c 2-2*c 3+(4-4*boundary)*c 4)*m4 +
    (2*c 2+(4+4*boundary)*c 3-4*c 4)*m5 +
    (c 3+(4+4*boundary)*c 4)*m6 +
    (c 0)*Endpoint.dual0 +
    (c 1)*Endpoint.dual1 +
    (c 2)*Endpoint.dual2 +
    (c 3)*Endpoint.dual3 +
    (c 4)*Endpoint.dual4

theorem no_strict_at_boundary : ¬ ∃ c, StrictQuarticCertificate boundary c := by
  rintro ⟨c, _, hd⟩
  let a := endpointAtoms
  have h1 := mul_pos a.hw₁ (neg_pos.mpr (hd 1 a.r (Or.inl one_ne_zero)))
  have h2 := mul_pos a.hw₂ (neg_pos.mpr (hd 1 a.s (Or.inl one_ne_zero)))
  have h3 := mul_pos a.hw₃ (neg_pos.mpr (hd 1 a.t (Or.inl one_ne_zero)))
  have he := atomic_dual_annihilates a c
  linarith

end QuarticLyapunov
