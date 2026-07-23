# A complete, unconditional formal verification of Erdős Problems #593 and #1177

This repository contains a **Lean 4 + Mathlib formalization** of

> Eric Li, *A Resolution of Erdős Problems 593 and 1177: Obligatory Triple
> Systems and Exact Spectra*, [arXiv:2606.24882](https://arxiv.org/abs/2606.24882) (2026).

Every step of both resolutions is machine-checked by the Lean kernel, with
no gaps and no unproved hypotheses. The entire content is packaged as a
single theorem with **no hypotheses at all**:
`Erdos593.full_resolution_unconditional` in
[`RequestProject/PublicationCertificate.lean`](RequestProject/PublicationCertificate.lean).
Its conclusion states Problem #593 and all three clauses of #1177 directly,
recording the answers to #1177(1)–(3) as **yes / no / yes**.

## The problems

A finite triple system (3-uniform hypergraph) `F` is **obligatory** if a
copy of `F` occurs in every triple system that cannot be properly coloured
with countably many colours (chromatic number > ℵ₀; proper = no
monochromatic edge).

**Problem #593** (a $500 Erdős prize problem,
[erdosproblems.com/593](https://www.erdosproblems.com/593)) asks to
characterize the obligatory finite triple systems. **Answer:** exactly the
class `B` generated from private-vertex expansions of finite bipartite
graphs and the edgeless systems, under isomorphism, disjoint unions, and
one-point amalgamations; equivalently, after deleting isolated vertices,
`F` is obligatory iff it is linear, every hyperedge-node of its Levi graph
is incident with a bridge, and every Berge cycle is even
(`classification_unconditional`).

**Problem #1177**
([erdosproblems.com/1177](https://www.erdosproblems.com/1177)): for finite
`G` let `F_G(κ)` be the triple systems of chromatic number *exactly* κ
containing no copy of `G`. The three formalized answers
(`problem_1177_part{1,2,3}_unconditional`):

1. **Yes** — nonempty `F_G(ℵ₁)` contains a member on ≤ `2^(2^ℵ₀)` vertices.
2. **No** — `F_G(ℵ₁)` and `F_H(ℵ₁)` can each be nonempty with no common
   member.
3. **Yes** — nonemptiness at one uncountable cardinal implies nonemptiness
   at every uncountable cardinal.

## Full and unconditional

**Full:** nothing is quoted from the literature. Of the paper's five
external inputs, four are proved from scratch here — E2 (Erdős–Hajnal high
odd girth, `e2_EH_oddgirth`), E3 (Erdős–Galvin–Hajnal property `P`,
`e3_EGH_P`), E4 (Reiher's obligatory `K⁽³⁾ₙ,ₙ`, `e4_Reiher`), E5
(Hajnal–Komjáth loose 7-cycle, `e5_HK_loose7`) — and the fifth, E1, is not
needed. The paper's internal engines (bridge-trace theorem, transfinite
reservoir recursion) are fully proved as well.

**Unconditional:** the source contains no `sorry`, no `admit`, no `axiom`
declaration, no `native_decide`, and no `@[implemented_by]`. The final
theorems carry no CH, GCH, or other set-theoretic hypotheses. Their
kernel-reported axioms are exactly `[propext, Classical.choice,
Quot.sound]` — Lean's three standard axioms of classical mathematics. This
is checked during the build by
[`RequestProject/AxiomAudit.lean`](RequestProject/AxiomAudit.lean), and
[`AUDIT_REPORT.md`](AUDIT_REPORT.md) records a statement-fidelity check
against the erdosproblems.com problem records.

## Verify it yourself

With [`elan`](https://github.com/leanprover/elan) installed:

```sh
lake exe cache get          # prebuilt Mathlib (strongly recommended)
lake build RequestProject
```

Expect `Build completed successfully` (~8090 jobs; exact count varies
slightly by environment) and seventeen axiom reports, each listing exactly
`[propext, Classical.choice, Quot.sound]`. Cosmetic warnings (unused simp
arguments, deprecated aliases) are expected and harmless. Last verified
2026-07-22 with Mathlib compiled from source (8091 jobs), and independently
2026-07-21 (8090 jobs, `AUDIT_REPORT.md`).

## Repository guide

- `RequestProject/PublicationCertificate.lean` — the hypothesis-free
  certificate (start here); `FinalResultsUnconditional.lean` — the
  individual headline theorems; `AxiomAudit.lean` — the executable audit.
- `RequestProject/Defs.lean`, `Structures.lean` — the definitional layer
  (the human-trust surface).
- `RequestProject/Attic/` — preserved failed experiments; not in the
  dependency closure of any final theorem.
- `AUDIT_REPORT.md` — repository-wide audit. `PAPER_STATUS.md`,
  `REMAINING_WORK.md`, `ARISTOTLE_SUMMARY.md`, and the status remarks in
  `SOURCES_E1_E5.md` are superseded historical records.
- `paper.tex` — the paper's source.

## Citation and attribution

Please cite the paper (arXiv:2606.24882) and this repository. The
formalization was developed with
[Aristotle](https://aristotle.harmonic.fun) (Harmonic): tag
`@Aristotle-Harmonic` on PRs/issues, and credit commits with
`Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>`.

## License

See [LICENSE](LICENSE).
