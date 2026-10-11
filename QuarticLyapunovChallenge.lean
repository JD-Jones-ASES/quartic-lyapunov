module
public import Mathlib

/-! Complete quartic classification for the displayed cubic field. The only
root hypotheses specify the unique explicit algebraic boundary; its existence
is proved by endpoint_classification. All five quartic coefficients are unrestricted. -/
@[expose] public noncomputable section
namespace QuarticLyapunov

/-- The five unrestricted real coefficients in descending powers of x. -/
abbrev Coeff := Fin 5 → ℝ

/-- A general real homogeneous quartic on the plane. -/
def quartic (c : Coeff) (x y : ℝ) : ℝ :=
  c 0*x^4 + c 1*x^3*y + c 2*x^2*y^2 + c 3*x*y^3 + c 4*y^4

/-- The damping-one cubic vector field. -/
def field (b x y : ℝ) : ℝ × ℝ :=
  ((-(x^2+y^2)+b*(x^2-y^2))*x-(x^2+y^2)*y,
   (-(x^2+y^2)+b*(x^2-y^2))*y+(x^2+y^2)*x)

/-- Actual Lie derivative, defined using partial derivatives of the polynomial. -/
def lie (b : ℝ) (c : Coeff) (x y : ℝ) : ℝ :=
  deriv (fun s => quartic c s y) x * (field b x y).1 +
  deriv (fun s => quartic c x s) y * (field b x y).2

/-- Positive definiteness means positivity at every nonzero real pair. -/
def PositiveQuartic (c : Coeff) : Prop :=
  ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quartic c x y

/-- Strict derivative inequality at every nonzero real pair. -/
def StrictQuarticCertificate (b : ℝ) (c : Coeff) : Prop :=
  PositiveQuartic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie b c x y < 0

/-- Weak derivative inequality with the same strict positivity requirement. -/
def WeakQuarticCertificate (b : ℝ) (c : Coeff) : Prop :=
  PositiveQuartic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie b c x y ≤ 0

/-- The explicit algebraic boundary polynomial, evaluated at B squared. -/
def phi (u : ℝ) : ℝ :=
  16*u^6 - 92*u^5 + 125*u^4 - 134*u^3 - 103*u^2 - 200*u + 100

/-- General homogeneous quadratic with unrestricted real coefficients. -/
def quadratic (a d e x y : ℝ) : ℝ := a*x^2+d*x*y+e*y^2

/-- The actual Lie derivative of a quadratic. -/
def quadraticLie (b a d e x y : ℝ) : ℝ :=
  deriv (fun s => quadratic a d e s y) x*(field b x y).1 +
  deriv (fun s => quadratic a d e x s) y*(field b x y).2

/-- Exact weak endpoint, strict exclusion, and uniqueness among unrestricted quartics. -/
theorem endpoint_classification : ∃ B : ℝ, 2 < B ∧ phi (B^2)=0 ∧
    (∀ b : ℝ, 1 < b → phi (b^2)=0 → b=B) ∧
    ∃ c : Coeff, WeakQuarticCertificate B c ∧
      (¬ ∃ d : Coeff, StrictQuarticCertificate B d) ∧
      (∀ d : Coeff, WeakQuarticCertificate B d → ∃ k : ℝ, 0 < k ∧ d=fun i => k*c i) := by
  sorry

/-- A literal strict integer quartic at two, while no positive weak quadratic exists. -/
theorem degree_separation :
    StrictQuarticCertificate 2 ![2,-9,20,-20,8] ∧
    ¬ ∃ a d e : ℝ,
      (∀ x y : ℝ, x≠0 ∨ y≠0 → 0 < quadratic a d e x y) ∧
      (∀ x y : ℝ, x≠0 ∨ y≠0 → quadraticLie 2 a d e x y ≤ 0) := by
  sorry

/-- Explicit algebraic endpoint coefficients in the monic-cubic-square normalization.
The five rational Horner polynomials are evaluated at the positive root b. -/
def explicitEndpoint (b : ℝ) : Coeff :=
  ![((((((((((((139079209 / 91413225 : ℝ)*b+(-73861532 / 91413225 : ℝ))*b+(-3056012767 / 365652900 : ℝ))*b+(408113144 / 91413225 : ℝ))*b+(2838406961 / 292522320 : ℝ))*b+(-96478534 / 18282645 : ℝ))*b+(-7284622853 / 731305800 : ℝ))*b+(7346593463 / 1462611600 : ℝ))*b+(-18095894717 / 1462611600 : ℝ))*b+(11810757931 / 1462611600 : ℝ))*b+(-3777931663 / 146261160 : ℝ))*b+(2373897047 / 146261160 : ℝ)),
    ((((((((((((-112708516 / 91413225 : ℝ)*b+(63916832 / 91413225 : ℝ))*b+(588460267 / 91413225 : ℝ))*b+(-302753444 / 91413225 : ℝ))*b+(-95414305 / 14626116 : ℝ))*b+(35216839 / 18282645 : ℝ))*b+(3020482261 / 365652900 : ℝ))*b+(-840254147 / 365652900 : ℝ))*b+(948029378 / 91413225 : ℝ))*b+(-3674353039 / 365652900 : ℝ))*b+(94262401 / 3656529 : ℝ))*b+(-548592473 / 36565290 : ℝ)),
    ((((((((((((157993082 / 91413225 : ℝ)*b+(-23681072 / 18282645 : ℝ))*b+(-1611187363 / 182826450 : ℝ))*b+(121805234 / 18282645 : ℝ))*b+(1052853677 / 146261160 : ℝ))*b+(-37908551 / 7313058 : ℝ))*b+(-677585618 / 91413225 : ℝ))*b+(501602359 / 146261160 : ℝ))*b+(-12146089103 / 731305800 : ℝ))*b+(2190008183 / 146261160 : ℝ))*b+(-2309201641 / 73130580 : ℝ))*b+(268110739 / 14626116 : ℝ)),
    ((((((((((((-60026932 / 91413225 : ℝ)*b+(48080912 / 91413225 : ℝ))*b+(313277839 / 91413225 : ℝ))*b+(-270510704 / 91413225 : ℝ))*b+(-218039873 / 73130580 : ℝ))*b+(66082084 / 18282645 : ℝ))*b+(636499447 / 365652900 : ℝ))*b+(-927817877 / 365652900 : ℝ))*b+(1507849747 / 182826450 : ℝ))*b+(-2486619949 / 365652900 : ℝ))*b+(207368702 / 18282645 : ℝ))*b+(-226368203 / 36565290 : ℝ)),
    ((((((((((((46299401 / 91413225 : ℝ)*b+(-31292668 / 91413225 : ℝ))*b+(-987796463 / 365652900 : ℝ))*b+(168629656 / 91413225 : ℝ))*b+(834278689 / 292522320 : ℝ))*b+(-38514926 / 18282645 : ℝ))*b+(-2222283667 / 731305800 : ℝ))*b+(3808067887 / 1462611600 : ℝ))*b+(-7649088313 / 1462611600 : ℝ))*b+(4633388819 / 1462611600 : ℝ))*b+(-1140664907 / 146261160 : ℝ))*b+(725927503 / 146261160 : ℝ))]

/-- The complete strict quartic classification, including both parameter signs. -/
theorem strict_classification (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) (b : ℝ) :
    (∃ c : Coeff, StrictQuarticCertificate b c) ↔ |b| < B := by
  sorry

/-- The complete weak quartic classification, with endpoint attainment. -/
theorem weak_classification (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) (b : ℝ) :
    (∃ c : Coeff, WeakQuarticCertificate b c) ↔ |b| ≤ B := by
  sorry

/-- The literal algebraic coefficient vector is weak and generates the complete endpoint ray. -/
theorem endpoint_explicit (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) :
    WeakQuarticCertificate B (explicitEndpoint B) ∧
    (∀ c : Coeff, WeakQuarticCertificate B c →
      ∃ k : ℝ, 0 < k ∧ c=fun i => k*explicitEndpoint B i) := by
  sorry

/-- The negative endpoint derivative is a monic cubic square with three distinct real lines. -/
theorem endpoint_geometry (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) :
    ∃ h₀ h₁ h₂ r s t : ℝ, r < s ∧ s < t ∧
      (∀ x y : ℝ, -lie B (explicitEndpoint B) x y =
        (h₀*x^3+h₁*x^2*y+h₂*x*y^2+y^3)^2) ∧
      h₀+h₁*r+h₂*r^2+r^3=0 ∧ h₀+h₁*s+h₂*s^2+s^3=0 ∧
      h₀+h₁*t+h₂*t^2+t^3=0 := by
  sorry

/-- Weak quartic feasibility contracts to strict feasibility without increasing degree. -/
theorem degree_preserving_contraction (B ρ : ℝ) (hρ₀ : 0 ≤ ρ) (hρ₁ : ρ < 1) :
    (∃ c : Coeff, WeakQuarticCertificate B c) →
    ∃ c : Coeff, StrictQuarticCertificate (ρ*B) c := by
  sorry

/-- Exact rational isolation of the positive boundary; decimals are not proof inputs. -/
theorem boundary_isolation (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0) :
    (2128153533088618627125605907329:ℝ)/10^30 < B ∧
    B < (2128153533088618627125605907330:ℝ)/10^30 := by
  sorry

/-- The seven unrestricted real coefficients in descending powers of x. -/
abbrev SexticCoeff := Fin 7 → ℝ

/-- A general real homogeneous sextic on the plane. -/
def sextic (c : SexticCoeff) (x y : ℝ) : ℝ :=
  c 0*x^6 + c 1*x^5*y + c 2*x^4*y^2 + c 3*x^3*y^3 +
  c 4*x^2*y^4 + c 5*x*y^5 + c 6*y^6

/-- Actual Lie derivative, defined using partial derivatives of the sextic. -/
def sexticLie (b : ℝ) (c : SexticCoeff) (x y : ℝ) : ℝ :=
  deriv (fun s => sextic c s y) x * (field b x y).1 +
  deriv (fun s => sextic c x s) y * (field b x y).2

/-- Positive definiteness at every nonzero real pair. -/
def PositiveSextic (c : SexticCoeff) : Prop :=
  ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < sextic c x y

/-- Strict derivative inequality at every nonzero real pair. -/
def StrictSexticCertificate (b : ℝ) (c : SexticCoeff) : Prop :=
  PositiveSextic c ∧ ∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → sexticLie b c x y < 0

/-- The whole cone of quartics with nonpositive endpoint derivative, including zero. -/
theorem endpoint_cone_classification (B : ℝ) (hB : 1 < B) (hphi : phi (B^2)=0)
    (c : Coeff) :
    (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → lie B c x y ≤ 0) ↔
      ∃ k : ℝ, 0 ≤ k ∧ c = fun i => k * explicitEndpoint B i := by
  sorry

/-- A strict integer sextic at nine fourths, where weak quadratics and quartics are impossible. -/
theorem sextic_separation :
    StrictSexticCertificate (9/4) ![34, -296, 1247, -2850, 3606, -2358, 634] ∧
    (¬ ∃ c : Coeff, WeakQuarticCertificate (9/4) c) ∧
    (¬ ∃ a d e : ℝ,
      (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → 0 < quadratic a d e x y) ∧
      (∀ x y : ℝ, x ≠ 0 ∨ y ≠ 0 → quadraticLie (9/4) a d e x y ≤ 0)) := by
  sorry

end QuarticLyapunov
