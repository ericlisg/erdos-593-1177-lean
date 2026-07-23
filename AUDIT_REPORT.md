# Audit of the formalization of Erdős Problems 593 and 1177

Date of audit: 2026-07-21

## Verdict

**The Lean development does fully and unconditionally prove the formal statements corresponding to Erdős Problem 593 and all three clauses of Erdős Problem 1177.**

This conclusion applies to the machine-checked mathematical interface in
`FinalResultsUnconditional.lean`. It does **not** mean that every historical
status note or downloaded source artifact in the repository is itself a current
mathematical assertion. In particular, `ARISTOTLE_SUMMARY.md`,
`REMAINING_WORK.md`, `PAPER_STATUS.md`, and `SOURCES_E1_E5.md` contain
chronological records of earlier incomplete stages. Those records should not be
used instead of the final interface and this audit.

## Final unconditional statements

For a publication-facing, mechanically unambiguous certificate, the structure
`Erdos593.FullResolution` states #593 and all three clauses of #1177 in one
proposition, and the theorem
`Erdos593.full_resolution_unconditional : Erdos593.FullResolution` proves that
proposition with **no hypotheses**. This rules out a merely conditional
assembly: the theorem type contains no parameters for E1–E5 or for any other
literature result. Its four fields are discharged by the public unconditional
theorems below.

The following declarations likewise have no hypotheses standing for literature results:

* `Erdos593.classification_unconditional`: for every finite triple system `F`,
  obligatoriness is equivalent to membership in the inductively generated class
  `Bclass`, and this is equivalent to the intrinsic condition on the
  isolated-vertex reduction.
* `Erdos593.obligatory_iff_bclass_unconditional`: the direct classification
  resolving Problem 593.
* `Erdos593.spectrum_dichotomy_unconditional`: the exact spectrum is empty for
  `F ∈ Bclass` and consists of every uncountable cardinal otherwise.
* `Erdos593.problem_1177_part1_unconditional`: an exact-`ℵ₁` witness can be
  chosen with at most `2^(2^ℵ₀)` vertices.
* `Erdos593.problem_1177_part2_unconditional`: there are finite `G,H` whose
  exact-`ℵ₁` avoidance families are individually nonempty but have empty
  intersection.
* `Erdos593.problem_1177_part3_unconditional`: nonemptiness at one uncountable
  chromatic cardinal implies nonemptiness at every uncountable cardinal.

Thus the three answers to Problem 1177 are formalized as **yes, no, yes**.
The part-(1) declaration was already proved in `Calibration.lean`; this audit
added the previously missing unconditional wrapper to the final public
interface. The joint publication certificate uses the literal
`Cardinal.aleph 1` statements for parts (1) and (2), and quantifies over all
uncountable cardinals in part (3).

## Statement fidelity checked

The audit compared the final declarations with `paper.tex` and checked the core
formal definitions:

* a host triple system has three-element edges;
* weak proper coloring means that no edge is monochromatic;
* `UncountablyChromatic` means not colorable with `ℵ₀` colors;
* finite-system embeddings are injective, edge-preserving, and non-induced;
* obligatoriness quantifies over all uncountably chromatic triple systems;
* `FGnonempty κ` means existence of an exact-`κ`-chromatic triple system
  omitting the given finite system;
* `InSpec` additionally records that the cardinal is uncountable;
* the loose seven-cycle has vertices `x_i,y_i` and edges
  `{x_i,x_(i+1),y_i}`.

These conventions agree with the statements used in the paper. The final
results are not weakened to vacuous propositions and do not retain E2--E5 as
assumptions.

## Machine verification

The complete Lake target was rebuilt:

```text
lake build RequestProject
Build completed successfully (8090 jobs).
```

The target builds the full public library, including the citation summary and executable axiom audit. The module import graph has 88
project imports and no import cycle. A source scan found:

* no proof term containing `sorry`;
* no `admit` tactic;
* no declared `axiom`;
* no `unsafe` declaration;
* no `@[implemented_by]` escape hatch.

Occurrences of words such as “sorry”, “admit”, and “axiom” are confined to
explanatory comments. The axioms reported for the classification, spectrum
result, all three Problem-1177 clauses, and each discharged E2--E5 theorem are
exactly:

```text
propext, Classical.choice, Quot.sound
```

These are standard logical/set-quotient principles used by Mathlib; there is no
project-specific unproved assumption in the dependency closure of the final
results. `AxiomAudit.lean` also prints the dependencies of
`full_resolution_unconditional`, so the joint certificate itself—not merely its
component lemmas—is checked.

The independently discharged inputs checked during this audit are:

* `e2_EH_oddgirth` in `E2Genuine.lean`;
* `e3_EGH_P` in `E3Proof.lean`;
* `e4_Reiher` in `E4Proof.lean`;
* `e5_HK_loose7` in `E5HK.lean`.

## TeX and source artifacts

`paper.tex` was compiled successfully with Tectonic into a 23-page PDF. The log
contains no TeX error or undefined-reference warning; its only reported warning
is that `inputenc` is ignored by a Unicode-native engine.

The malformed `HK2008.pdf` artifact (an HTML landing page with the wrong
extension) has been deleted. No PDF is a Lean dependency. The genuine
Hajnal--Komjáth paper was checked during research but is not committed as a
build artifact.

The OCR text files are research/source aids and are not trusted dependencies of
any Lean theorem. OCR quality is imperfect, particularly for mathematical
symbols; mathematical correctness rests on the checked Lean declarations, not
on those OCR transcriptions.

## Non-blocking issues

The build emits style/deprecation warnings (mainly unused `simp` arguments and a
few deprecated cardinal lemma names). They do not alter elaboration, theorem
statements, or kernel checking. Historical planning/status documents contain
obsolete passages describing results as unfinished; their later update banners
and the final interface supersede those passages.

## Conclusion

For the precise question “does the machine-checked project fully and
unconditionally discharge Erdős Problems 593 and 1177?”, the answer is **yes**.
Malformed source artifacts have been removed and historical notes are now
prominently marked as superseded. Neither was ever a dependency of the formal
proofs.

---

## Final pre-publication pass (2026-07-21)

### Live-record fidelity

The live records at `erdosproblems.com/593` and `/1177` were fetched on
2026-07-21. #593 asks for finite 3-uniform hypergraphs appearing in every
3-uniform hypergraph of chromatic number `> ℵ₀`. #1177 defines `F_G(κ)` as the
3-uniform hypergraphs of chromatic number exactly `κ` not containing `G`, then
states the three assertions answered here **yes / no / yes**.

The Lean definitions match those records: `FTS.Embeds` is injective,
edge-preserving, and non-induced; `UncountablyChromatic` is literally
`¬ ColorableBy ℵ₀`; `HasChromatic` is exact; and `FGnonempty` at
`Order.succ ℵ₀` is exact-`ℵ₁` nonemptiness. The loose-cycle convention is the
14-vertex private-vertex cycle with edges `{x_i,x_(i+1),y_i}` modulo 7.
Mathlib documents `Order.succ ℵ₀ = Cardinal.aleph 1` as
`Cardinal.succ_aleph0`; the source comments record this, and the final interface
now provides literal-`Cardinal.aleph 1` forms of all three #1177 results.

### Universes

The results are universe-polymorphic in `u`. At each `u`,
`FTS.Obligatory.{u}` quantifies over every host `W : Type u`; `FGnonempty`,
embeddings, and chromatic cardinals stay in the same universe. This is the
intended size-indexed assertion, not a weakening. `ResultsSummary.lean`
explicitly checks the `u = 0` instances.

### Hygiene and executable audit

The vacuous interleaving-construction dead end was moved to
`RequestProject/Attic/`. The malformed HTML file named `HK2008.pdf` was deleted.
`PAPER_STATUS.md` and `REMAINING_WORK.md` now have prominent superseded banners.
`RequestProject/AxiomAudit.lean` executes `#print axioms` for every public
unconditional theorem, the three literal-`aleph 1` wrappers, and E2--E5.

### Cold-clone result

A fresh local clone fetched Mathlib, then ran `lake build RequestProject` from
no project build artifacts: **Build completed successfully (8090 jobs)**. The
16 requested/public axiom reports all printed exactly
`[propext, Classical.choice, Quot.sound]`; no other axiom report appeared. A
string scan of all freshly generated project `.olean` files found no `sorryAx`,
`Lean.ofReduceBool`, or `native_decide`.
