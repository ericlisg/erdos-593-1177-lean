# SUPERSEDED HISTORICAL RECORD

> **This file is retained as a chronological development record and is superseded in full.**
> For the current, verified state use `AUDIT_REPORT.md`, `README.md`, and
> `RequestProject/ResultsSummary.lean`. Statements below that describe work as
> missing or conditional are historical, not current status.

> **UPDATE (later run).** Much of what is listed below has since been
> formalized. See `PAPER_STATUS.md` for the current state. In brief: §2, §3,
> §6.1, §6.2, §6.3 and all the definitional infrastructure (Berge cycles,
> bridges, class `B`, expansions, amalgamation, spectrum, `F_G`) are now fully
> proved and `sorry`-free, and the headline theorems (`classification` for #593,
> `spectrum_dichotomy`, `problem_1177_part3`) are proved `sorry`-free from four
> named hypotheses carrying the paper's imported theorems (E1–E5) and its two
> heaviest internal engines (the bridge-trace theorem and the transfinite
> reservoir recursion). The original gap analysis follows.

# What remains to fully formalise arXiv:2606.24882

This note answers the question: *what is remaining that would make the paper
fully formalised?* It is based on the paper's TeX source (v10) and the current
Lean state.

## Currently formalised (machine-checked, no `sorry`/`axiom`)

* **§3 — The complete-rank one-apex lift** (`RequestProject/Lift.lean`):
  the construction `Lift(A, κ)` and the theorem `χ(Lift(A,κ)) = κ` when
  `χ(A) = κ` (`thm:lift-chromatic`). This is the paper's central new
  construction.
* **§6.2 — Cardinal arithmetic** (`RequestProject/CardinalArith.lean`):
  Small unions, the four "Cardinal facts", Successors cofinal, Cofinal fibres.

Everything else below is **not yet formalised**.

## 1. Imported external theorems (E1–E5) — deep results not in Mathlib

These are quoted from the literature, not proved in the paper, and none is in
Mathlib. Each would be a substantial standalone formalization effort; the
faithful alternative is to carry each as an explicit hypothesis/`variable`
rather than an `axiom`.

* **E1** Erdős–Hajnal–Rothschild — a two-edge intersection forces
  non-obligatory (`thm:EHR-nonlinear`).
* **E2** Erdős–Hajnal — high-odd-girth graphs of prescribed uncountable size
  and chromatic number (`thm:EH-odd-girth`).
* **E3** Erdős–Galvin–Hajnal — the simultaneous common-colour labelling of the
  generalized Specker graph `GS_2(ρ)` (property `P`, `thm:EGH-P`).
* **E4** Reiher — `K_{n,n}^+` is obligatory (`thm:Reiher`).
* **E5** Hajnal–Komjáth — the loose 7-cycle is linearly obligatory (used only
  for Problem #1177(2)).

## 2. Missing definitional infrastructure

Needed before the remaining theorems can even be *stated* in Lean:

* obligatory triple systems; the target class `B` (`Bclass`);
* Levi graphs and expansions; hyperedge-nodes and **bridges**;
* **Berge cycles** and their length/parity;
* linear triple systems; `F`-free; exact-`λ`-chromatic;
* the exact spectrum `Spec(F)` and the family `F_G(κ)`;
* the generalized Specker graph `GS_2(ρ)` and edge labellings.

## 3. §2 Preliminaries

* Isolated-vertex reduction lemma (`lem:` at Levi-graph subsection).

## 4. §4 Finite linear traces of the lift (ZFC combinatorics — in scope)

* Cycle–selector correspondence;
* Cycle collapse;
* Quotient forest;
* Labelled forest lemma;
* **Bridge-trace theorem** (the section's main result).

## 5. §5 Obligatory triple systems and Problem #593 (needs E1, E4)

* Expansion pieces; Leaf-piece / running-intersection lemma;
* Finite bridge decomposition (proposition) and the supporting lemma;
* **Resolution of Problem #593** — the classification `thm:intro-classification`
  (three-way equivalence);
* Obstruction trichotomy; Compatibility with the known theory.

## 6. §6 Exact linear calibration (needs E3; transfinite recursion)

* Simultaneous edge-labelling input (definition); Monotonicity;
* Stage capacity; **Recursive construction** (the transfinite reservoir
  recursion); Linearity; Canonical upper colouring; Reservoir capture;
  Lower bound;
* **Exact successor calibration** theorem and its corollary, giving
  `thm:intro-linear` (`χ(L_κ)=κ` with `|V(L_κ)| ≤ 2^{2^μ}` for `κ=μ⁺`).

## 7. §7 Exact spectra and Problem #1177 (needs all of the above, plus E5)

* **Exact-spectrum class dichotomy** (`thm:intro-spectrum`);
* **Resolution of Problem #1177** (`cor:intro-1177`, answers yes/no/yes).

## Summary

The self-contained ZFC **core** is done (the lift + its exact chromatic
number, and the calibration's cardinal arithmetic). To reach a *full*
formalisation one would additionally need: (a) the five imported theorems
E1–E5 (either fully formalised or explicitly assumed as hypotheses), (b) a
sizeable body of new definitions (Levi graphs, bridges, Berge cycles,
obligatory/linear systems, spectra), and (c) the two combinatorial engines
(the **bridge-trace theorem**, §4–5, and the **transfinite reservoir
recursion**, §6) that assemble these into the two headline results — the
classification resolving **#593** and the spectrum dichotomy resolving
**#1177**.
