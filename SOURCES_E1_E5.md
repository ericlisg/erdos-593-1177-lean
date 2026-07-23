# Verified sources for the five imported theorems E1–E5

*Companion to arXiv:2606.24882, "A Resolution of Erdős Problems 593 and 1177"
(Eric Li).* The paper's two proof cores import five results **verbatim from the
literature** (its §2.2 "External theorem interface" and Appendix
"Exact interfaces to the imported theorems"). This note records, for each of
E1–E5, the primary source located and read online, the exact statement used, and
the mathematical content that a full Lean formalization would have to reproduce.

The arXiv paper itself was confirmed online:
`https://arxiv.org/abs/2606.24882` (Li, Eric; 2026-06-23).

---

## E1 — Erdős–Hajnal–Rothschild: nonlinear systems are non-obligatory

**Source.** P. Erdős, A. Hajnal, B. L. Rothschild, *On chromatic number of
graphs and set-systems*, in *Cambridge Summer School in Mathematical Logic*
(1971), Lecture Notes in Mathematics **337**, Springer, 1973, pp. 531–538;
Theorem 2, p. 532.

**Statement used (paper `thm:EHR-nonlinear`).** If two distinct edges of a finite
uniform hypergraph `F` intersect in at least two vertices, then `F` is
non-obligatory. In particular every obligatory finite triple system is *linear*.

**Actual mathematical content.** The witness is an *uncountably chromatic linear
triple system*. Reiher records the explicit construction
(*Obligatory hypergraphs*, arXiv:2403.11223, and the girth survey
arXiv:2403.13571, §3.7): put `λ = (2^ℵ₀)⁺` and take the triple system on the
vertex set `[λ]²` (the 2-element subsets of `λ`) whose edges are the "triangles"
```
{ {α,β}, {α,γ}, {β,γ} }   for  α < β < γ < λ.
```
Two distinct triangles share at most one pair, so the system is linear; and the
partition relation `λ → (3)²_ω` forces `χ ≥ ℵ₁`. A linear system omits every
non-linear `F`, giving non-obligatoriness.

**Formalization gap.** The `χ ≥ ℵ₁` step is the **Erdős–Rado partition relation**
`(2^ℵ₀)⁺ → (3)²_{ℵ₀}` (a special case of the Erdős–Rado theorem). This is **not
in Mathlib** (a search for partition-calculus / Erdős–Rado on cardinals returns
nothing); its proof is the Erdős–Rado ramification/tree argument. Fully
formalizing E1 therefore requires first formalizing Erdős–Rado, a standalone
set-theory project.

---

## E2 — Erdős–Hajnal: exact high-odd-girth graphs

**Source.** P. Erdős, A. Hajnal, *On chromatic number of graphs and set-systems*,
Acta Math. Acad. Sci. Hungar. **17** (1966), 61–99, Theorem 7.4, p. 76
(doi:10.1007/BF02020444); restated verbatim as Theorem C, p. 428 of
P. Erdős, F. Galvin, A. Hajnal, *On set-systems having large chromatic number
and not containing prescribed subsystems*, Colloq. Math. Soc. János Bolyai
**10**, North-Holland, 1975, pp. 425–513.

**Statement used (paper `thm:EH-odd-girth`).** For every uncountable cardinal `κ`
and every positive integer `s` there is a graph `A` with
```
|V(A)| = χ(A) = κ     and     A contains no odd cycle C_m for m ≤ 2s+1.
```

**Formalization gap.** This is the Erdős–Hajnal transfinite construction of
graphs with prescribed uncountable chromatic number and arbitrarily high odd
girth. It is **not in Mathlib** and is a substantial standalone construction
(a transfinite recursion controlling both `χ` and short odd cycles). Note the
finite analogue "high girth + high chromatic number" (Erdős's probabilistic
theorem) is itself not in Mathlib; the uncountable, exact-cardinal version needed
here is strictly harder.

---

## E3 — Erdős–Galvin–Hajnal: the simultaneous edge-labelling property P

**Source.** Erdős–Galvin–Hajnal, *On set-systems …* (Bolyai 10, 1975):
Definition 6.2, p. 448 (the property `P(S, I, δ)`) and Corollary 9.7, p. 461.

**Statement used (paper `thm:EGH-P`).** `P(S, I, δ)` is the quantifier order
`∀c ∃a ∀i ∃e`: for every `θ < δ` and every colouring `c : V(S) → θ` there is one
colour `a < θ` such that for *every* label `i ∈ I` some edge `e` of label `i`
lies inside `c⁻¹{a}` (the colour `a` is **common to all labels** — this is the
strong order, not `∀i ∃a_i ∃e`). Corollary 9.7: for infinite `ρ`, with
`δ(ρ) = min{δ : ρ^δ > ρ}` and `1 < n < ω`, the generalized Specker graph
satisfies `P(GS_n(ρ), ρ, δ(ρ))`. The paper substitutes `n = 2`.

**Formalization gap.** Requires the generalized Specker graph `GS₂(ρ)` and the
transfinite proof of its simultaneous-labelling property. **Not in Mathlib.**
The definition of the property `P` and the monotonicity `lem:P-monotone` and the
cardinal `δ(ρ)` are already formalized in this project
(`RequestProject/PropertyP.lean`, `RequestProject/DeltaRho.lean`); the *content*
of Corollary 9.7 (that `GS₂(ρ)` actually has property `P`) is the imported part.

---

## E4 — Reiher: the private expansion of K_{n,n} is obligatory

**Source (located and read in full online).** C. Reiher, *Obligatory
hypergraphs*, arXiv:2403.11223, Proc. Amer. Math. Soc. (to appear),
doi:10.1090/proc/17021; Theorem 1.2.

**Statement used (paper `thm:Reiher`).** For all integers `k ≥ 2` and `n ≥ 1`
the `k`-uniform expansion `K^{(k)}_{n,n}` of the complete bipartite graph
`K_{n,n}` is obligatory. The paper substitutes `k = 3`; passing to finite
subhypergraphs gives obligatoriness of `J⁺` for every finite bipartite `J`.

**Proof structure (from the arXiv source).** Induction on the uniformity `k`.
- Base `k = 2`: Erdős–Hajnal — a finite graph is obligatory iff bipartite; the
  hard direction ("K_{n,n} obligatory") is *every graph of uncountable chromatic
  number contains K_{n,n}* (EH66, Cor 5.6 + Thm 7.4).
- Tools: **Zykov submultiplicativity** `χ(H) ≤ ∏_i χ(V, E_i)` for a cover of the
  edge set (Fact 2.1), and its corollary: if `χ(H) ≥ ℵ₁` and `χ(V, E') ≤ ℵ₀`
  then `χ(V, E∖E') ≥ ℵ₁` (Cor 2.2).
- Inductive step: for the minimal counterexample `k`, take a `K^{(k)}_{n,n}`-free
  `H` on a least cardinal `κ` with `χ(H) > ℵ₀`; with `t = kn²+1`, define the
  `ℓ`-uniform "delta-system root" hypergraphs `H^{(ℓ)}` for `2 ≤ ℓ < k`; show
  each `χ(H^{(ℓ)}) ≤ ℵ₀` (using obligatoriness of `K^{(ℓ)}_{n,n}` by minimality
  of `k` and a delta-system extension argument); then a counting/`Δ`-system
  argument on the remaining uncountably-chromatic part produces a copy of
  `K^{(k)}_{n,n}`, a contradiction.

**Formalization gap.** The whole argument (base case EH + Zykov + delta-system
counting) is **not in Mathlib**. The base case alone (EH: uncountably chromatic
⟹ contains `K_{n,n}`) is a genuine theorem; the project already has the
degree-pruning lemma `restrict_uc` that its proof would use. In this project E4
is the carried hypothesis `ReiherExpansion` (`RequestProject/Results.lean`).

---

## E5 — Hajnal–Komjáth: the linearly obligatory loose 7-cycle

**Source.** A. Hajnal, P. Komjáth, *Obligatory subsystems of triple systems*,
Acta Math. Hungar. **119** (2008), no. 1–2, 1–13
(doi:10.1007/s10474-007-6231-2); cycle convention and statement also recorded in
Reiher's girth survey (arXiv:2403.13571, §3.7). Related: P. Komjáth,
*Some remarks on obligatory subsystems …*, Combinatorica **21** (2001), 233–238
(the necessary condition), and P. Komjáth, *An uncountably chromatic triple
system*, Acta Math. Hungar. **121** (2008), 79–92.

**Statement used (paper).** The loose/private-vertex cycle `C_n^{(3)}` (on `2n`
vertices `x_i, y_i` with edges `x_i x_{i+1} y_i`, `i ∈ ℤ/n`) is *linearly
obligatory* for `n ∉ {2,3,5}` — i.e. it occurs in every **linear** triple system
of uncountable chromatic number. The paper substitutes `n = 7`; it is used only
for Problem #1177(2). (Reiher's Theorem 1.2 gives obligatoriness of the *even*
loose cycles `C^{(3)}_n`, `n ≥ 4` even, as a special case of E4; the odd case
`n = 7`, in the *linear* host category, is the Hajnal–Komjáth input.)

**Formalization gap.** Not in Mathlib; a standalone combinatorial-set-theory
theorem. Problem #1177(2) is not part of the current Lean development, so E5 does
not appear as a carried hypothesis here.

---

## Summary of feasibility

Each of E1–E5 is a genuine published research theorem, none present in Mathlib,
and each depends on infrastructure that is itself a substantial standalone
formalization:

| Theorem | Core missing infrastructure | In Mathlib? |
|---|---|---|
| E1 | Erdős–Rado partition relation `(2^ℵ₀)⁺ → (3)²_{ℵ₀}` | no |
| E2 | Erdős–Hajnal transfinite high-odd-girth construction | no |
| E3 | Generalized Specker graph `GS₂(ρ)` + property `P` (EGH Cor 9.7) | no |
| E4 | EH base (`K_{n,n}` obligatory) + Zykov + Δ-system counting | no |
| E5 | Hajnal–Komjáth linear-host argument | no |

Consequently these cannot be *proved* (fully discharged) within this project
without first formalizing the above from scratch — each a large independent
effort — and they cannot be introduced as `axiom`s (that would compromise
soundness). In the Lean development they are therefore carried as explicit,
faithfully-stated named hypotheses (never axioms), matching the paper's own
"external theorem interface" methodology; see `RequestProject/External.lean`.
