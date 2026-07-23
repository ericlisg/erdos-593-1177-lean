import RequestProject.E3Discharged
import RequestProject.Attic.E2CoreProof

/-!
# Headline results under the odd-girth statement — which is FALSE (vacuous)

The literature inputs **E3** (Erdős–Galvin–Hajnal) and **E4** (Reiher) are proved
in this project (`Erdos593.e3_EGH_P`, `Erdos593.e4_Reiher`).  A previous run
*attempted* to reduce the last remaining input **E2** (Erdős–Hajnal high odd
girth, `E2_EH_oddgirth`) to the concrete statement
`Erdos593.EHG.OddGirthGeneral` — "for every `k ≥ 2` the graph `graph k κ` has no
odd cycle of length `≤ 2k-3`".

**That reduction is a dead end: `OddGirthGeneral` is FALSE.**  It is disproved in
`RequestProject.Attic.E2OddGirthFalse` (`EHG.oddGirthGeneral_false`): `graph 4 κ` has an
explicit `5`-cycle and `5 = 2·4 - 3`.  The chromatic lower bound
`χ(graph k κ) = κ` is correct and fully proved, but this particular interleaving
construction does *not* have high odd girth, so it is not a valid E2 witness.

Hence the theorems below — which take `OddGirthGeneral` as a hypothesis — are
implications from a false premise, i.e. **vacuous**; they do not make the headline
results unconditional.  The genuine, sound headline resolutions of
arXiv:2606.24882 continue to carry `E2_EH_oddgirth` as an explicit literature
hypothesis; see `RequestProject.FinalResults`.  These vacuous variants are kept
only to document the (failed) reduction attempt.
-/

open Cardinal

namespace Erdos593

universe u

/-- **Resolution of Erdős Problem #593** from the odd-girth statement alone
(E3, E4 already proved, E2's chromatic half proved). -/
theorem classification_of_oddGirth (hog : EHG.OddGirthGeneral.{u}) (F : FTS) :
    (FTS.Obligatory.{u} F ↔ Bclass F) ∧ (Bclass F ↔ F.reduce.IntrinsicObligatory) :=
  classification_no_E34 (EHG.e2_EH_of hog) F

/-- **Obligatoriness is exactly membership in `B`**, from the odd-girth statement
alone. -/
theorem obligatory_iff_bclass_of_oddGirth (hog : EHG.OddGirthGeneral.{u}) (F : FTS) :
    FTS.Obligatory.{u} F ↔ Bclass F :=
  obligatory_iff_bclass_no_E34 (EHG.e2_EH_of hog) F

/-- **Exact-spectrum class dichotomy** (`thm:spectrum`), from the odd-girth
statement alone. -/
theorem spectrum_dichotomy_of_oddGirth (hog : EHG.OddGirthGeneral.{u}) (F : FTS)
    (lam : Cardinal.{u}) :
    F.InSpec lam ↔ (¬ Bclass F ∧ ℵ₀ < lam) :=
  spectrum_dichotomy_no_E34 (EHG.e2_EH_of hog) F lam

/-- **Erdős Problem #1177, part (3)** (`thm:1177`), from the odd-girth statement
alone. -/
theorem problem_1177_part3_of_oddGirth (hog : EHG.OddGirthGeneral.{u})
    (G : FTS) (kappa : Cardinal.{u}) (hk : ℵ₀ < kappa) (h : G.FGnonempty kappa)
    (lam : Cardinal.{u}) (hlam : ℵ₀ < lam) :
    G.FGnonempty lam :=
  problem_1177_part3_no_E34 (EHG.e2_EH_of hog) G kappa hk h lam hlam

end Erdos593
