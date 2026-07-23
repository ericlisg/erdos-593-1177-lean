# SUPERSEDED HISTORICAL RECORD

> **This file is retained as a chronological development record and is superseded in full.**
> For the current, verified state use `AUDIT_REPORT.md`, `README.md`, and
> `RequestProject/ResultsSummary.lean`. Statements below that describe work as
> missing or conditional are historical, not current status.

# Formalization status: arXiv:2606.24882

*A Resolution of Erdős Problems 593 and 1177: Obligatory Triple Systems and
Exact Spectra* (Eric Li), formalized in Lean 4 + Mathlib.

The whole `RequestProject` library **builds cleanly and contains no `sorry` and
no `axiom` declarations**; every result depends only on the standard axioms
`propext`, `Classical.choice`, `Quot.sound`.

The paper's TeX source is included as `paper.tex`.

## HEADLINE UPDATE — E2–E5 are now fully proved; every headline result is unconditional

The last deep literature input used by the main results, **E2** (the
Erdős–Hajnal exact high-odd-girth theorem, Acta Math. Hungar. 17 (1966),
Theorem 7.4 = Erdős–Galvin–Hajnal, Bolyai 10 (1975), Theorem C), is now a
**fully proved, `sorry`-free, axiom-clean theorem** `Erdos593.e2_EH_oddgirth`
(`RequestProject/E2Genuine.lean`).  It is obtained from the genuine generalized
Specker graph `GS_n(κ)` (Def. 8.2), built from scratch here:

* `RequestProject/GSn.lean` — the construction on the strictly increasing
  `(n²+n+1)`-tuples of `κ.ord.ToType`, its cardinality bound `card_le`
  (`|V| ≤ κ`), and the two index-comparison workhorse lemmas.
* `RequestProject/GSnPotential.lean` — the graph-independent cyclic
  difference-constraint potential (the delta-lemma core): the max-window
  potential `pot`, `pot_step` (it absorbs every edge constraint when the total
  increment is `≤ 0`) and `pot_le_posSum`.
* `RequestProject/GSnOddGirth.lean` — **Lemma 8.3(A)**
  `noShortOddCycle_n : NoShortOddCycle (graph n κ) n` (no odd cycle of length
  `≤ 2n+1`), via the delta-lemma potential and the reversal (ascent-majority)
  argument.
* `RequestProject/GSnChromatic.lean` — **Lemma 8.3(B)** `not_colorableBy`
  (`χ(GS_n(κ)) = κ`), by the Erdős–Rado cofinal peeling (reusing the
  graph-independent stabilization tower `EHG.stab`) plus the `GS_n`-specific
  extraction (`grow`, `mid`, `extract_gsn`) that reads off two interleaving
  `L`-tuples forming a monochromatic edge.

Together with the already-discharged **E3** (`Erdos593.e3_EGH_P`) and **E4**
(`Erdos593.e4_Reiher`), **E5** is now also fully proved as
`Erdos593.e5_HK_loose7` in `RequestProject/E5HK.lean`.  The proof formalizes the
Hajnal–Komjáth `M₃` construction, a closed filtration and blocker-reflection
argument, the uncountably chromatic link-graph extraction, and the explicit
embedding of the loose seven-cycle into `M₃`.

Consequently (`RequestProject/FinalResultsUnconditional.lean`), the following
are now **completely unconditional theorems** (no carried hypotheses,
axiom-clean):

* `classification_unconditional` — **Resolution of Erdős Problem #593**.
* `obligatory_iff_bclass_unconditional`.
* `spectrum_dichotomy_unconditional` — the exact-spectrum class dichotomy.
* `problem_1177_part3_unconditional` — **Erdős Problem #1177, part (3)**.
* `problem_1177_part2_unconditional` — **Erdős Problem #1177, part (2)**;
* `obligatory_stronglyTripartite_unconditional`,
  `cycleExpansion_obligatory_iff_unconditional`, and
  `C7_linearlyObligatory_not_obligatory_unconditional` — all four compatibility
  statements.

Thus no E1–E5 hypothesis remains in the unconditional final interface.  Earlier
historical sections of this file describe intermediate stages with carried
inputs; those descriptions are superseded by this update.

## What is fully proved (self-contained, no hypotheses)

* **§3 — The complete-rank one-apex lift** (`RequestProject/Lift.lean`): the
  construction `Lift(A,κ)` and the theorem `χ(Lift(A,κ)) = κ` when `χ(A)=κ`
  (`thm:lift-chromatic`), the paper's central new construction.
* **§2 — Isolated-vertex reduction** (`RequestProject/Reduce.lean`): the
  reduction `F ↦ F°`, the equivalence `F ↪ H ↔ F° ↪ H` for infinite hosts
  (`lem:isolated-reduction`), and its consequences for obligatoriness and the
  spectrum. Also: a triple-system host with uncountable chromatic number is
  infinite.
* **§6.1 — Property `P` and monotonicity** (`RequestProject/PropertyP.lean`):
  the Erdős–Galvin–Hajnal simultaneous-labelling property and `lem:P-monotone`.
* **§6.2 — Cardinal arithmetic** (`RequestProject/CardinalArith.lean`): small
  unions, the cardinal facts, cofinal fibres, successors cofinal.
* **§6.3 — The cardinal `δ(ρ)`** (`RequestProject/DeltaRho.lean`): `δ(ρ)` and
  the key calibration fact `μ⁺ ≤ δ(2^μ)`.
* **§4 — Combinatorial core of the bridge-trace engine**
  (`RequestProject/BridgeTrace.lean`): the two self-contained finite
  graph-theoretic lemmas of §4, proved from scratch: the **labelled forest
  lemma** `labelled_forest` (`lem:labelled-forest`) — a finite oriented,
  edge-labelled forest carries pairwise-distinct finite words on its vertices,
  compatible with the orientation and labels via the proper-prefix / coordinate
  condition (the combinatorial heart of the *sufficiency* direction of the
  bridge-trace theorem), together with its helper `forest_exists_degree_le_one`
  (a finite forest has a leaf); and the **quotient forest lemma**
  `quotient_forest` (`lem:quotient-forest`) — contracting the components left
  after deleting a set of bridges yields an acyclic quotient.  (These are
  components of the §4 bridge-trace theorem, whose full assembly — requiring the
  Levi-graph derivative machinery and the lift's sequence-node cycle-collapse
  argument — is not yet formalized; see below.)
* **Definitional infrastructure** (`RequestProject/Defs.lean`,
  `RequestProject/Structures.lean`): finite triple systems `FTS`, embeddings,
  obligatoriness, linearity, the spectrum `Spec` and the family `F_G(κ)`; Berge
  cycles, Levi bridges (via the "lies on no Berge cycle" characterization) and
  bridge selectors; the intrinsic obligatoriness condition; private-vertex
  expansions `J⁺`, disjoint union and one-point amalgamation of finite triple
  systems; and the target class `B` (`Bclass`).
* **Closure lemmas** (`RequestProject/Results.lean`): edgeless systems are
  obligatory; obligatoriness transfers across isomorphism and is closed under
  disjoint union; deleting a finite vertex set preserves uncountable chromatic
  number (`restrict_uc`); an obligatory system has empty spectrum.

## The headline theorems (proved modulo explicitly carried hypotheses)

In `RequestProject/Results.lean` the following are all **`sorry`-free**:

* `bclass_obligatory` — the **positive half** of Problem #593.
* `classification` — **Resolution of Erdős Problem #593** (`thm:classification`):
  obligatoriness ⟺ membership in `B` ⟺ the intrinsic Levi-graph condition.
* `spectrum_dichotomy` — the **exact-spectrum class dichotomy** (`thm:spectrum`).
* `problem_1177_part3` — **Erdős Problem #1177, part (3)**.

These theorems now take, as explicit hypotheses, exactly the paper's inputs that
are not otherwise formalized here (carried as hypotheses, never as axioms).  One
of the four originally-carried hypotheses, **`AmalgClosure`, has since been fully
proved and discharged** (see below); the three that remain are:

* `ReiherExpansion` — the E4 interface (Reiher's theorem `thm:Reiher` that
  `K_{n,n}⁺` is obligatory, with the subhypergraph passage): every bipartite
  expansion `J⁺` is obligatory.
* `NegativeCore` — the negative half of #593 and the spectrum construction
  (§4–§6): if `F ∉ B` then every uncountable `λ` carries an exact-`λ`-chromatic
  `F`-free system. This packages the obstruction trichotomy, the (fully proved)
  lift, the bridge-trace theorem (§4, from E1/E2), and exact linear calibration
  (§6, from E3).
* `FiniteDecomposition` — the finite bridge decomposition
  (`prop:finite-decomposition`, §5).

## `AmalgClosure` — now fully proved (no longer a hypothesis)

The one-point amalgamation closure of `lem:obligatory-closure` is now proved from
scratch and the hypothesis has been removed from all headline theorems.  The
supporting development (all `sorry`-free, only the standard axioms):

* **`RequestProject/Compactness.lean`** — the **de Bruijn–Erdős compactness
  theorem** for graph colourings (`colorable_of_forall_finite`): if every finite
  vertex set admits a proper `k`-colouring, so does the whole graph.  Proved via
  the finite-intersection-property argument in the compact product space
  `∀ v, Fin k`.
* **`RequestProject/AmalgHelpers.lean`** — the reusable colouring toolkit:
  `colorableBy_aleph0_of_countable`, `restrict_colorable_of_obligatory`
  (an obligatory `F` that omits a restriction makes it `ℵ₀`-colourable),
  `colorableBy_of_finite_parts` (glue finitely many `ℵ₀`-colourable parts with
  disjoint palettes), the averaging lemma `exists_low_degree_vertex`, the finite
  degeneracy colouring `finite_degenerate_coloring`, and its de Bruijn–Erdős
  consequence `colorable_of_out` (a graph with an out-orientation of out-degree
  `≤ d` is `(2d+1)`-colourable).  Also hosts `restrict_uc` (moved here).
* **`RequestProject/AmalgClosure.lean`** — the amalgamation argument itself:
  `amalgamate_embeds_of_copies` (build an amalgam embedding from two copies
  meeting only at the glue point), `reroute_isolated` (reroute isolated vertices
  onto fresh host vertices), `rootSetF_compl_Ffree`, `class_Gfree` (each colour
  class of the auxiliary graph is `G`-free), `amalgamate_symm_iso` (symmetry of
  amalgamation), the isolated-root case `amalgamate_obligatory_of_isolated`, the
  main non-isolated case `amalgamate_obligatory_of_nonisolated` (the de
  Bruijn–Erdős / degeneracy argument on the rooted-copy graph), and the combined
  **`amalgamate_obligatory`**.  `Results.amalgClosure_holds : AmalgClosure`
  packages it and discharges the hypothesis.

## What is not yet formalized

The three remaining carried hypotheses are the remaining content. Two are imported
literature theorems (Reiher; and, inside `NegativeCore`, Erdős–Hajnal–Rothschild,
Erdős–Hajnal, Erdős–Galvin–Hajnal, and — for #1177(2) — Hajnal–Komjáth); the
other (`FiniteDecomposition`, together with the internals of `NegativeCore`)
comprises the paper's heaviest internal engines (the finite bridge decomposition,
the bridge-trace theorem with its Levi-graph component/derivative machinery, and
the transfinite reservoir recursion of the exact calibration), whose full ZFC
formalization would each be a large standalone project.

## The explicit external interface E1–E5 (`RequestProject/External.lean`)

The five imported literature theorems E1–E5 are now stated as **explicit,
faithfully-typed named propositions**, each with its verified source, in
`RequestProject/External.lean` (they were previously bundled opaquely inside
`NegativeCore`/`ReiherExpansion`, and E5 was absent).  The file builds
`sorry`-free and axiom-clean:

* `E1_EHR_nonlinear`, `E2_EH_oddgirth`, `E3_EGH_P`, `E4_Reiher`, `E5_HK_loose7`
  — the precise statements used by the paper, with the supporting definitions
  `NoShortOddCycle`, `FTS.LinearlyObligatory`, `looseCycle7`.
* `E4_Reiher_of_reiherExpansion` (proved) shows `E4_Reiher` is exactly the
  `K_{n,n}` instance of the carried hypothesis `ReiherExpansion`, via
  `completeBipartite_colorable_two`.
* `colorableBy_mono`, `colorableBy_aleph0_union` (Zykov, two-piece form) and
  `uncountablyChromatic_diff` (Reiher's Corollary 2.2) — the reusable colouring
  ingredients of Reiher's proof of E4, fully proved.

Verified bibliographic details, exact statements, and proof strategies for all
five theorems (located and read online, including Reiher's arXiv sources) are in
`SOURCES_E1_E5.md`.  Full *proofs* of E1–E5 are not provided: each is a deep
published theorem absent from Mathlib and depending on substantial infrastructure
not present here (Erdős–Rado for E1; the Erdős–Hajnal transfinite high-odd-girth
construction for E2; the generalized Specker graph and property `P` for E3; the
Erdős–Hajnal base case plus the delta-system argument for E4; the Hajnal–Komjáth
argument for E5).  They are carried as explicit named hypotheses, never as
`axiom`s.

## §4–§5 bridge-trace engine fully discharged (`RequestProject/CycleCollapse.lean`, `RequestProject/NegativeDirection.lean`)

The first of the paper's two heavy internal engines — the §4–§5 bridge-trace
theorem, including the lift's sequence-node **cycle-collapse** argument and the
Levi-graph bridge/derivative reasoning — is now **fully proved, `sorry`-free and
axiom-clean** (only `propext`, `Classical.choice`, `Quot.sound`).

`RequestProject/CycleCollapse.lean`:
* `cycle_collapse` (`lem:cycle-collapse`): the transfinite linchpin — if a finite
  linear triple system embeds into `Lift(A,κ)`, then on every Berge cycle all
  sequence nodes coincide.  Proved via the prefix-order (`Node.wpre`), a cyclic
  induction (`zmod_cyclic_induction`), a first-return argument
  (`exists_first_return`), run-constancy of the base coordinate
  (`seqAt_const_along`), and a linearity contradiction.
* `exists_bridge_incidence` / `bridgeSelector_of_embeds_lift`: a lift embedding
  forces a bridge incidence at every edge (hence a bridge selector).
* `base_adj` / `lift_bergeCycle_graphCycle`: a Berge cycle of length `m` maps to
  an actual `m`-cycle in `A` (host form of `lem:cycle-selector`).
* `lift_omits_of_no_bridgeSelector` (case ii) and `lift_omits_of_bergeCycle`
  (case iii): the two omission cores of the negative direction.

`RequestProject/NegativeDirection.lean`:
* `completeGraph_hasChromatic`, `liftHG_tripleSystem`,
  `nonlinear_not_embeds_linear`, `no_bridgeSelector_of`: the plumbing.
* **`negativeCore_of : AllLinearExists → E2_EH_oddgirth → NegativeCore`** — the
  negative half is reduced, via the obstruction trichotomy
  (`finiteDecomposition_holds`) and the fully-proved bridge-trace machinery, to
  just the §6 output `AllLinearExists` (= `cor:all-linear`) and the external
  theorem `E2`.  The §4–§5 engine no longer appears as a hypothesis.
* `classification_of`, `spectrum_dichotomy_of`, `problem_1177_part3_of`: the
  headline results restated with the §4–§5 engine discharged — they now depend
  only on `ReiherExpansion` (= E4, external), `AllLinearExists` (= §6 output),
  and `E2_EH_oddgirth` (external).

## §6 transfinite reservoir recursion fully discharged (`RequestProject/Reservoir*.lean`)

The second of the paper's two heavy internal engines — the §6 exact linear
calibration (the *transfinite reservoir recursion*) — is now **fully proved,
`sorry`-free and axiom-clean** (only `propext`, `Classical.choice`, `Quot.sound`).
The sole §6 output needed for the negative direction, `AllLinearExists`
(`cor:all-linear`), is derived from the genuine external Erdős–Galvin–Hajnal
property-`P` input `E3_EGH_P` (which is the only thing §6 imports from the
literature):

* `RequestProject/ReservoirSetup.lean` — the geometry (levels `R = ρ⁺`, fibres
  `Λ = 2^ρ`, ranks), the bundled construction data `CalibData μ`, the triple
  system `L_κ = CalibData.L`, and the structural theorems: `L_isTripleSystem`,
  `L_linear` (`lem:calibration-linearity`), and the canonical upper colouring
  `L_colorable` (`lem:calibration-upper`, `χ(L_κ) ≤ κ`).
* `RequestProject/ReservoirBuild.lean` — the allocation part
  (`lem:stage-capacity`, `lem:calibration-construction`): `stage_capacity`
  (`|R_α| ≤ Λ`), the injective placement of copies (`exists_copy`) and apex maps
  (`exists_phi`), assembled into `exists_calibData : E3 → Nonempty (CalibData μ)`.
* `RequestProject/ReservoirLower.lean` — the lower bound
  (`lem:reservoir-capture`, `lem:calibration-lower`): `Dsmall_lt` (`|D| < ρ`),
  `exceptional_subsingleton`, `exists_xi`, `exists_level_above`,
  `exists_disjoint_copy`, the reservoir-capture theorem `reservoir_capture`, and
  `L_lower` (`χ(L_κ) ≥ κ`).
* `RequestProject/Reservoir.lean` — assembly: `successor_linear`
  (`thm:successor-linear`), the disjoint-union machinery for the limit case, and
  **`allLinearExists_of_E3 : E3_EGH_P → AllLinearExists`** (`cor:all-linear`).
  The E3-based headline resolutions `classification_of_E3`,
  `spectrum_dichotomy_of_E3`, `problem_1177_part3_of_E3` no longer carry
  `AllLinearExists`; they depend only on the external interface theorems
  `ReiherExpansion` (E4), `E3_EGH_P` (E3), `E2_EH_oddgirth` (E2).

(The strengthened `E3_EGH_P` in `RequestProject/External.lean` now also records
`|V(S)| = ρ`, which holds for the generalized Specker graph and is used for the
stage-capacity bound.)

Both of the paper's heavy internal engines (the §4–§5 bridge-trace theorem and
the §6 reservoir recursion) are therefore fully machine-checked; the only
remaining hypotheses are the imported literature theorems E2–E5 of the external
interface.

## Progress on E2 (Erdős–Hajnal high odd girth): base case fully formalized

`RequestProject/ErdosHajnalGirth.lean` (namespace `Erdos593.ER60`) formalizes,
completely `sorry`-free and axiom-clean (`propext, Classical.choice, Quot.sound`),
the **`n = 1` (triangle-free) base case** of the Erdős–Hajnal high-odd-girth
theorem — i.e. the Erdős–Rado 1960 graph:

* `graph κ` — the Erdős–Rado graph on the strictly increasing triples of
  `Pt κ := κ.ord.ToType`, with edge `x₀<x₁<y₀<x₂<y₁<y₂`.
* `card_le` — `|V| ≤ κ`.
* `triangleFree` / `noShortOddCycle_one` — no odd cycle of length `≤ 3`.
* `not_colorableBy_regular` — the chromatic lower bound at a regular cardinal, by
  the iterated cofinal-colour argument (three peeling levels), built on the
  reusable infinite-combinatorics machinery `Cofinal`, `cofinal_univ`,
  `cofinal_Ioi`, `exists_ub` (regularity boundedness), `cofinal_fiber`.
* `not_colorableBy` — the chromatic lower bound for every uncountable `κ`, via the
  initial-segment reduction to `μ = (max θ ℵ₀)⁺` (`exists_pt_orderEmbedding`,
  `colorableBy_of_le`).
* `e2Core_oddGirth_one` — packages the above as the `s = 1` slice of
  `Erdos593.E2Core` (graph on `≤ κ` vertices, not `θ`-colourable for `θ < κ`, no
  odd cycle of length `≤ 3`).

This is exactly the `n = 1` case of the generalized Specker graph `GSₙ(κ)`
(Erdős–Galvin–Hajnal, Bolyai 10, 1975, Def. 8.2 / Lemma 8.3).  The general
odd-girth case (`GSₙ(κ)` for all `n`, the full `E2Core`) uses a specific
type-graph interleaving pattern on `(n²+n+1)`-tuples whose exact index
combinatorics could not be reconstructed reliably from the available
(OCR-degraded) primary sources, so `E2_EH_oddgirth` remains a faithfully-stated
carried hypothesis (never an axiom) for general odd girth, together with `E5`.

## E2: the general-`k` chromatic lower bound is proved; but the odd-girth "reduction" is a DEAD END

A later run proved the *chromatic half* of E2 in general and attempted to reduce
the rest to a finite odd-girth statement `OddGirthGeneral`.  **That statement
turned out to be false** (see the CORRECTION subsection at the end of this
section); the reduction is therefore vacuous.  The chromatic-bound machinery
listed here is `sorry`-free and axiom-clean and remains correct.

* `RequestProject/E2CoreProof.lean` — oriented-chain coordinate propagation for
  the general Erdős–Hajnal graph `EHG.graph k κ`: `isEdge_chain_cross`
  (`u 0 (i+r) < u r (i)`) and `isEdge_chain_gap` (`u r (i) < u 0 (i+2r)`).
* `RequestProject/EHGirthChromatic.lean` — the **general-`k` chromatic lower
  bound** (the Erdős–Rado cofinal-peeling argument, generalizing the `k = 3`
  base case `ER60.not_colorableBy`):
  - `stab` — the stabilization tower, with `stab_spec` (cofinal-fibre spec),
    `stab_congr` (prefix congruence), and `exists_next_star` (one-step extension);
  - `extract_aux` — the interleaving-extraction induction building two
    star-realizing tuples `a`, `b` forming an edge with `c a = c b`;
  - `not_colorableBy_regular_general` — `graph k κ` is not `θ`-colourable for
    `θ < κ` at a *regular* `κ` (`k ≥ 2`).
* `RequestProject/E2CoreProof.lean` — `not_colorableBy_general` removes
  regularity (initial-segment reduction), and
  `e2Core_of : OddGirthGeneral → E2Core`,
  `e2_EH_of : OddGirthGeneral → E2_EH_oddgirth` assemble the core using the
  proved chromatic bound, the cardinality bound `EHG.card_le`, and the padding
  reduction `E2_of_core`.  Here `EHG.OddGirthGeneral` is the single remaining
  elementary statement: *for every `k ≥ 2`, `graph k κ` has no odd cycle of
  length `≤ 2k-3`*.
* `RequestProject/E2Reduction.lean` — since E3 and E4 are already proved, the
  three headline resolutions not using E5 (Problem #593 classification, the
  exact-spectrum dichotomy, Problem #1177 part (3)) are restated as following
  from `EHG.OddGirthGeneral` **alone** (`classification_of_oddGirth`,
  `spectrum_dichotomy_of_oddGirth`, `problem_1177_part3_of_oddGirth`).

Thus E2's transfinite *chromatic* content (`χ(graph k κ) = κ`) is fully
machine-checked and correct.

### CORRECTION (this run): `OddGirthGeneral` is FALSE — E2 is *not* reduced

The reduction above is **not valid**, because its remaining premise
`EHG.OddGirthGeneral` is **false**.  This run *disproved* it:
`RequestProject/E2OddGirthFalse.lean` (`EHG.oddGirthGeneral_false`, `sorry`-free,
axiom-clean) exhibits an explicit `5`-cycle in `graph 4 κ` (for infinite `κ`),
namely `S — x — T — z — y — S` on five strictly increasing `4`-tuples; since
`5 = 2·4 - 3`, the graph `graph 4 κ` has an odd cycle of length `≤ 2k-3`.

Root cause: the interleaving edge relation `IsEdge` used for `EHG.graph`
(`a_{i+1} < b_i < a_{i+2}` at every coordinate) is *not* the genuine
Erdős–Hajnal high-odd-girth construction (which uses a different "half-shift"
edge rule on longer tuples).  A balanced source–sink configuration produces short
odd cycles already at `k = 4`.  The earlier "validated for `k ≤ 5`" note was
incorrect.

Consequences:
* `EHG.graph k κ` remains a genuinely high-chromatic graph
  (`not_colorableBy_general` is a correct theorem), but it is **not** a valid E2
  witness.
* `e2Core_of` / `e2_EH_of` (in `E2CoreProof.lean`) and the `_of_oddGirth`
  theorems (in `E2Reduction.lean`) are implications *from a false premise*, hence
  vacuous; they do **not** discharge E2 and do **not** make any headline result
  unconditional.
* The genuine, sound headline resolutions continue to carry `E2_EH_oddgirth` as
  an explicit literature hypothesis (see `FinalResults.lean`); nothing in the
  project is unsound, and no axioms were introduced.

Bottom line: **E2 (and E5) remain carried as explicit literature hypotheses**,
exactly as the paper does.  The docstrings of the affected files were corrected
to state this plainly.
