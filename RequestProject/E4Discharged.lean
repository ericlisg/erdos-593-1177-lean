import RequestProject.FinalResults
import RequestProject.E4Proof

/-!
# E4 discharged: the headline results no longer assume Reiher's Theorem 1.2

The literature input **E4** (`E4_Reiher`, Reiher's *Obligatory hypergraphs*,
arXiv:2403.11223, Theorem 1.2, case `k = 3`) is now a **proved theorem**
(`Erdos593.e4_Reiher`, in `RequestProject.E4Proof`), obtained from the
delta-closed filtration, Claim 2.2 and the rainbow-grid counting.  Consequently
`ReiherExpansion` holds unconditionally, and every headline result that used to
carry E4 (or its equivalent `ReiherExpansion`) as an explicit hypothesis can be
restated with that hypothesis removed.

These E4-free statements still depend on the remaining literature inputs **E2**
(`E2_EH_oddgirth`), **E3** (`E3_EGH_P`) and **E5** (`E5_HK_loose7`), which are the
other Erdős–Hajnal / Erdős–Galvin–Hajnal / Hajnal–Komjáth theorems carried by the
paper's external interface; discharging those is out of scope here.

Everything below is `sorry`-free and axiom-clean. -/

open Cardinal

namespace Erdos593

universe u

/-- **`ReiherExpansion` is now unconditional**, since E4 is proved. -/
theorem reiherExpansion_proved : ReiherExpansion.{u} :=
  reiherExpansion_of_E4 e4_Reiher

/-! ### Resolution of Erdős Problem #593 (E4 discharged) -/

/-- **Resolution of Erdős Problem #593** (`thm:classification`), with E4 discharged
(now depending only on E3 and E2). -/
theorem classification_no_E4 (h3 : E3_EGH_P.{u}) (hE2 : E2_EH_oddgirth.{u}) (F : FTS) :
    (FTS.Obligatory.{u} F ↔ Bclass F) ∧ (Bclass F ↔ F.reduce.IntrinsicObligatory) :=
  classification_final e4_Reiher h3 hE2 F

/-- **Obligatoriness is exactly membership in `B`**, with E4 discharged. -/
theorem obligatory_iff_bclass_no_E4 (h3 : E3_EGH_P.{u}) (hE2 : E2_EH_oddgirth.{u})
    (F : FTS) : FTS.Obligatory.{u} F ↔ Bclass F :=
  obligatory_iff_bclass_final e4_Reiher h3 hE2 F

/-! ### Exact-spectrum dichotomy and Problem #1177 (E4 discharged) -/

/-- **Exact-spectrum class dichotomy** (`thm:spectrum`), with E4 discharged. -/
theorem spectrum_dichotomy_no_E4 (h3 : E3_EGH_P.{u}) (hE2 : E2_EH_oddgirth.{u})
    (F : FTS) (lam : Cardinal.{u}) :
    F.InSpec lam ↔ (¬ Bclass F ∧ ℵ₀ < lam) :=
  spectrum_dichotomy_final e4_Reiher h3 hE2 F lam

/-- **Erdős Problem #1177, part (3)** (`thm:1177`), with E4 discharged. -/
theorem problem_1177_part3_no_E4 (h3 : E3_EGH_P.{u}) (hE2 : E2_EH_oddgirth.{u})
    (G : FTS) (kappa : Cardinal.{u}) (hk : ℵ₀ < kappa) (h : G.FGnonempty kappa)
    (lam : Cardinal.{u}) (hlam : ℵ₀ < lam) :
    G.FGnonempty lam :=
  problem_1177_part3_final e4_Reiher h3 hE2 G kappa hk h lam hlam

/-- **Erdős Problem #1177, part (2)**, with E4 discharged (still uses E3, E2, E5). -/
theorem problem_1177_part2_no_E4 (h3 : E3_EGH_P.{u}) (hE2 : E2_EH_oddgirth.{u})
    (hE5 : E5_HK_loose7.{u}) :
    ∃ (G H : FTS),
      G.FGnonempty (Order.succ (ℵ₀ : Cardinal.{u})) ∧
      H.FGnonempty (Order.succ (ℵ₀ : Cardinal.{u})) ∧
      ¬ ∃ (W : Type u) (K : Hypergraph W),
          K.IsTripleSystem ∧ K.HasChromatic (Order.succ (ℵ₀ : Cardinal.{u})) ∧
          ¬ G.Embeds K ∧ ¬ H.Embeds K :=
  problem_1177_part2_final e4_Reiher h3 hE2 hE5

/-! ### Compatibility corollaries (E4 discharged) -/

/-- **Compatibility (1)**: every obligatory finite triple system is strongly
tripartite, with E4 discharged. -/
theorem obligatory_stronglyTripartite_no_E4 (h3 : E3_EGH_P.{u})
    (hE2 : E2_EH_oddgirth.{u}) (F : FTS) (hobl : FTS.Obligatory.{u} F) :
    F.StronglyTripartite :=
  obligatory_stronglyTripartite_final e4_Reiher h3 hE2 F hobl

/-- **Compatibility (2)**: every finite triple-system forest is obligatory, with
E4 discharged (this one now depends on *no* literature input at all). -/
theorem forest_obligatory_no_E4 {F : FTS} (h : F.Forest) : FTS.Obligatory.{u} F :=
  forest_obligatory_final e4_Reiher h

/-- **Compatibility (3)**: for `n ≥ 3`, the private-vertex cycle expansion `C_n^+`
is obligatory iff `n` is even, with E4 discharged. -/
theorem cycleExpansion_obligatory_iff_no_E4 (h3 : E3_EGH_P.{u})
    (hE2 : E2_EH_oddgirth.{u}) (n : ℕ) (hn : 3 ≤ n) :
    FTS.Obligatory.{u} (graphExpansion (SimpleGraph.cycleGraph n)) ↔ Even n :=
  cycleExpansion_obligatory_iff_final e4_Reiher h3 hE2 n hn

/-- **Compatibility (4)**: the loose cycle `C_7^{(3)}` is linearly obligatory but
not obligatory, with E4 discharged (still uses E3, E2, E5). -/
theorem C7_linearlyObligatory_not_obligatory_no_E4 (h3 : E3_EGH_P.{u})
    (hE2 : E2_EH_oddgirth.{u}) (hE5 : E5_HK_loose7.{u}) :
    FTS.LinearlyObligatory.{u} looseCycle7 ∧ ¬ FTS.Obligatory.{u} looseCycle7 :=
  C7_linearlyObligatory_not_obligatory_final e4_Reiher h3 hE2 hE5

end Erdos593
