import Mathlib
import RequestProject.ErdosHajnalGirthGeneral
import RequestProject.EHGirthChromatic
import RequestProject.E2Construction

/-!
# `E2Core` via the general graph construction — the odd-girth premise is FALSE

This file *attempts* to assemble the Erdős–Hajnal core `Erdos593.E2Core` (hence,
via `Erdos593.E2_of_core`, the external interface `E2_EH_oddgirth`) from the graph
`Erdos593.EHG.graph k κ` on strictly increasing `k`-tuples of `Pt κ`.

**Important.**  The assembly needs the odd-girth statement `OddGirthGeneral`
("no odd cycle of length `≤ 2k-3`"), but that statement is **FALSE** for this
construction — see `RequestProject.Attic.E2OddGirthFalse` (`EHG.oddGirthGeneral_false`),
which exhibits an explicit `5`-cycle in `graph 4 κ` (`5 = 2·4 - 3`).  Hence the
"reductions" `e2Core_of` / `e2_EH_of` below are implications *from a false
premise* and are therefore vacuous; they do **not** discharge E2.

What *is* genuinely proved here and is correct:
* `|V| ≤ κ` (`EHG.card_le`);
* the chromatic lower bound: `graph k κ` is not `θ`-colourable for any `θ < κ`
  (`not_colorableBy_general`) — so the graph is genuinely high-chromatic.

What fails: this specific interleaving edge relation does not yield high odd
girth, so `graph k κ` is not a valid E2 witness.  The actual headline theorems
continue to carry `E2_EH_oddgirth` as an explicit literature hypothesis (see
`FinalResults.lean`), which remains sound.
-/

open Cardinal

namespace Erdos593
namespace EHG

open ER60 (Pt)

universe u

variable {κ : Cardinal.{u}} {k : ℕ}

/-! ### Coordinate propagation along oriented chains

Along a directed chain `u 0 → u 1 → ⋯` of oriented edges (`IsEdge (u n) (u (n+1))`)
the coordinates propagate: after `r ≥ 1` steps the `i`-th coordinate is squeezed
between the `(i+r)`-th and `(i+2r)`-th coordinates of the start.  These are the
reusable structural facts behind the odd-girth argument (they generalize the
single-edge `isEdge_coord_lt` / `isEdge_gap`). -/

/-
**Cross propagation.**  Along an oriented chain, `u 0 (i+r) < u r (i)` for
`r ≥ 1` (whenever `i + r < k`).
-/
theorem isEdge_chain_cross (u : ℕ → (Fin k → Pt κ))
    (hedge : ∀ n, IsEdge (u n) (u (n + 1)))
    (r : ℕ) (hr : 1 ≤ r) (i : ℕ) (h : i + r < k) :
    (u 0) ⟨i + r, h⟩ < (u r) ⟨i, by omega⟩ := by
  induction' r with r ih generalizing i;
  · contradiction;
  · rcases r with ( _ | r ) <;> simp_all +decide;
    · exact hedge 0 |>.1 i ( by omega );
    · convert lt_trans _ ( hedge ( r + 1 ) |>.1 i ( by omega ) ) using 1;
      grind +qlia

/-
**Gap propagation.**  Along an oriented chain, `u r (i) < u 0 (i+2r)` for
`r ≥ 1` (whenever `i + 2*r < k`).
-/
theorem isEdge_chain_gap (u : ℕ → (Fin k → Pt κ))
    (hedge : ∀ n, IsEdge (u n) (u (n + 1)))
    (r : ℕ) (hr : 1 ≤ r) (i : ℕ) (h : i + 2 * r < k) :
    (u r) ⟨i, by omega⟩ < (u 0) ⟨i + 2 * r, h⟩ := by
  induction' hr with r hr ih generalizing i <;> simp_all +decide;
  · exact hedge 0 |>.2 i ( by omega );
  · have := hedge r;
    convert lt_trans _ ( ih ( i + 2 ) ( by linarith ) ) using 1;
    · grind;
    · exact this.2 i ( by linarith )

/-! ### The general odd-girth bound -/

/-- **The general odd-girth bound**, as a named proposition.  It states that for
every `k ≥ 2` the Erdős–Hajnal graph `graph k κ` has no odd cycle of length
`≤ 2k-3` (`NoShortOddCycle (graph k κ) (k-2)`), generalizing the triangle-free
base case `k = 3` (`ER60.noShortOddCycle_one`, proved).

**WARNING — this proposition is FALSE.**  It is *disproved* in
`RequestProject.Attic.E2OddGirthFalse` (`EHG.oddGirthGeneral_false`): the graph
`graph 4 κ` (for infinite `κ`) contains a `5`-cycle, and `5 = 2·4 - 3`, so it has
an odd cycle of length `≤ 2k-3`.  The interleaving edge relation `IsEdge` used
here (`a_{i+1} < b_i < a_{i+2}` for all coordinates) is *not* the genuine
Erdős–Hajnal high-odd-girth construction; the balanced source–sink configuration
`S → x → T ← z ← y ← S` realises a `5`-cycle already at `k = 4`.  (An earlier note
claiming odd girth `2k-1` "validated for `k ≤ 5`" was incorrect.)

Consequently `graph k κ` is a genuinely high-chromatic graph
(`not_colorableBy_general`, below, is a correct theorem) but it is **not** a
valid witness for E2, and the "reductions" `e2Core_of` / `e2_EH_of` below (and the
`_of_oddGirth` theorems in `E2Reduction.lean`) are implications *from a false
premise*, hence vacuous.  E2 therefore genuinely remains carried as the explicit
literature hypothesis `E2_EH_oddgirth` in the actual headline theorems (see
`FinalResults.lean`), which is sound.  The chromatic *half*
(`not_colorableBy_general`) is still fully proved and correct. -/
def OddGirthGeneral : Prop :=
  ∀ (κ : Cardinal.{u}) (k : ℕ) (hk : 2 ≤ k), NoShortOddCycle (graph k κ hk) (k - 2)

/-! ### The general chromatic lower bound -/

/-- **General chromatic lower bound.**  For `ℵ₀ < κ` and `k ≥ 2`, the graph
`graph k κ` is not `θ`-colourable for any `θ < κ`.  This generalizes the `k = 3`
Erdős–Rado peeling argument (`ER60.not_colorableBy`). -/
theorem not_colorableBy_general (hk : 2 ≤ k) (hκ : ℵ₀ < κ) {θ : Cardinal.{u}}
    (hθ : θ < κ) :
    ¬ (SimpleGraph.toHG (graph k κ hk)).ColorableBy θ := by
  intro h
  have hνκ : max θ ℵ₀ < κ := max_lt hθ hκ
  have hμκ : Order.succ (max θ ℵ₀) ≤ κ := Order.succ_le_of_lt hνκ
  have hμreg : (Order.succ (max θ ℵ₀)).IsRegular := Cardinal.isRegular_succ (le_max_right _ _)
  have hθμ : θ < Order.succ (max θ ℵ₀) := lt_of_le_of_lt (le_max_left _ _) (Order.lt_succ _)
  exact not_colorableBy_regular_general hμreg hk hθμ (colorableBy_of_le hk hμκ h)

/-! ### Assembling `E2Core` (vacuous: the premise `OddGirthGeneral` is false)

Given the odd-girth bound `OddGirthGeneral`, the core `E2Core` — and hence the
external interface `E2_EH_oddgirth` — would follow, using the cardinality bound
(`card_le`), the padding reduction (`E2_of_core`) and the chromatic lower bound
(`not_colorableBy_general`).  **However `OddGirthGeneral` is FALSE**
(`EHG.oddGirthGeneral_false`), so the two theorems below are vacuous implications
and do not discharge E2. -/

/-- **`OddGirthGeneral → E2Core`.**  Vacuous: the hypothesis `OddGirthGeneral` is
false (`EHG.oddGirthGeneral_false`). -/
theorem e2Core_of (hog : OddGirthGeneral.{u}) : E2Core.{u} := by
  intro κ hκ s
  refine ⟨Vtx (s + 2) κ, graph (s + 2) κ (by omega), ?_, ?_, ?_⟩
  · exact card_le (by omega) hκ.le
  · intro θ hθ
    exact not_colorableBy_general (by omega) hκ hθ
  · have h := hog κ (s + 2) (by omega)
    simpa using h

/-- **`OddGirthGeneral → E2_EH_oddgirth`.**  Vacuous: the hypothesis
`OddGirthGeneral` is false (`EHG.oddGirthGeneral_false`), so this does not
discharge E2. -/
theorem e2_EH_of (hog : OddGirthGeneral.{u}) : E2_EH_oddgirth.{u} :=
  E2_of_core (e2Core_of hog)

end EHG
end Erdos593