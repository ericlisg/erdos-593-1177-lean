import Mathlib
import RequestProject.Attic.E2CoreProof

/-!
# `EHG.OddGirthGeneral` is **false**

The proposition `Erdos593.EHG.OddGirthGeneral` claims that for every `k ≥ 2` the
Erdős–Hajnal graph `graph k κ` has no odd cycle of length `≤ 2k-3`.  This is
**false** already for `k = 4`: the graph `graph 4 κ` (on strictly increasing
`4`-tuples of `Pt κ`, with the interleaving edge relation `a_{i+1} < b_i < a_{i+2}`)
contains a `5`-cycle, and `5 = 2·4 - 3`.

An explicit witness, in terms of an arbitrary strictly increasing sequence
`e : ℕ → Pt κ` (which exists whenever `κ` is infinite), is the `5`-cycle on the
five strictly increasing `4`-tuples
```
  S = (e0, e1, e4, e7),   x = (e2, e5, e11, e15),   T = (e10, e13, e16, e17),
  z = (e7, e9, e12, e14),  y = (e3, e6, e8, e10)
```
with edges (oriented) `S → x`, `x → T`, `z → T`, `y → z`, `S → y`, forming the
cycle `S — x — T — z — y — S`.  (These are the ranks of a numeric counterexample
`S=(0,10,20,30)`, `x=(15,25,35,55)`, `T=(33,45,60,70)`, `z=(30,32,40,50)`,
`y=(16,29,31,33)`, verified by direct computation.)

Consequently the "reduction of E2 to `OddGirthGeneral`" (`EHG.e2_EH_of`,
`EHG.e2Core_of`, and the `_of_oddGirth` theorems in `E2Reduction.lean`) is a
reduction to a **false** premise, hence vacuous.  The `EHG.graph` construction is
high-chromatic (`not_colorableBy_general`, correct) but does **not** have high odd
girth, so it is *not* a valid witness for the Erdős–Hajnal theorem `E2`.  The
genuine headline results of the project therefore continue to carry
`E2_EH_oddgirth` as an explicit literature hypothesis (see `FinalResults.lean`),
which remains sound.
-/

open Cardinal

namespace Erdos593
namespace EHG

open ER60 (Pt)

universe u

/-- For an infinite cardinal there is a strictly increasing `ℕ`-indexed sequence
of points. -/
theorem exists_strictMono_nat {κ : Cardinal.{u}} (hκ : ℵ₀ ≤ κ) :
    ∃ e : ℕ → Pt κ, StrictMono e := by
  have homega : (ℵ₀ : Cardinal).ord ≤ κ.ord := Cardinal.ord_le_ord.mpr hκ
  have hlt : ∀ n : ℕ, (n : Ordinal) < κ.ord := by
    intro n
    calc (n : Ordinal) < (ℵ₀ : Cardinal).ord := by
            rw [Cardinal.ord_aleph0]; exact Ordinal.nat_lt_omega0 n
      _ ≤ κ.ord := homega
  refine ⟨fun n => Ordinal.enum (α := κ.ord.ToType) (· < ·)
      ⟨(n : Ordinal), by rw [Ordinal.type_toType]; exact hlt n⟩, ?_⟩
  intro a b hab
  refine Ordinal.enum_lt_enum.mpr ?_
  simp only [Subtype.mk_lt_mk]
  exact_mod_cast hab

/-- Helper: an oriented edge `IsEdge` of `graph 4 κ` between two tuples given as
`e ∘ ra` and `e ∘ rb` for a strictly monotone `e : ℕ → Pt κ` follows from the
rank inequalities (`ra_{i+1} < rb_i` and `rb_i < ra_{i+2}`). -/
theorem isEdge_of_ranks {κ : Cardinal.{u}} (e : ℕ → Pt κ) (he : StrictMono e)
    (ra rb : Fin 4 → ℕ)
    (hc : ∀ i : ℕ, (h : i + 1 < 4) → ra ⟨i+1,h⟩ < rb ⟨i, by omega⟩)
    (hg : ∀ i : ℕ, (h : i + 2 < 4) → rb ⟨i, by omega⟩ < ra ⟨i+2,h⟩) :
    IsEdge (k:=4) (κ:=κ) (fun i => e (ra i)) (fun i => e (rb i)) :=
  ⟨fun i h => he (hc i h), fun i h => he (hg i h)⟩

/-- **`OddGirthGeneral` is false.**  The graph `graph 4 κ` (for infinite `κ`)
contains a `5`-cycle, and `5 = 2·4 - 3`, so it has an odd cycle of length
`≤ 2k-3`.  The witness is the `5`-cycle `S — x — T — z — y — S` on the five
strictly increasing `4`-tuples described in the module docstring. -/
theorem oddGirthGeneral_false : ¬ OddGirthGeneral.{u} := by
  intro h
  obtain ⟨e, he⟩ := exists_strictMono_nat (κ := (ℵ₀ : Cardinal.{u})) le_rfl
  set S : Vtx 4 (ℵ₀ : Cardinal.{u}) := ⟨fun i => e (![0,1,4,7] i), he.comp (by decide)⟩ with hS
  set x : Vtx 4 (ℵ₀ : Cardinal.{u}) := ⟨fun i => e (![2,5,11,15] i), he.comp (by decide)⟩ with hx
  set T : Vtx 4 (ℵ₀ : Cardinal.{u}) := ⟨fun i => e (![10,13,16,17] i), he.comp (by decide)⟩ with hT
  set z : Vtx 4 (ℵ₀ : Cardinal.{u}) := ⟨fun i => e (![7,9,12,14] i), he.comp (by decide)⟩ with hz
  set y : Vtx 4 (ℵ₀ : Cardinal.{u}) := ⟨fun i => e (![3,6,8,10] i), he.comp (by decide)⟩ with hy
  have mk : ∀ ra rb : Fin 4 → ℕ,
      (∀ i:ℕ,(hh:i+1<4)→ ra ⟨i+1,hh⟩ < rb ⟨i,by omega⟩) →
      (∀ i:ℕ,(hh:i+2<4)→ rb ⟨i,by omega⟩ < ra ⟨i+2,hh⟩) →
      IsEdge (k:=4) (κ:=(ℵ₀:Cardinal.{u})) (fun i => e (ra i)) (fun i => e (rb i)) :=
    fun ra rb hc hg => isEdge_of_ranks e he ra rb hc hg
  have eSx : IsEdge S.1 x.1 := mk ![0,1,4,7] ![2,5,11,15]
    (by rintro (_|_|_|i) hh <;> first | omega | simp_all) (by rintro (_|_|i) hh <;> first | omega | simp_all)
  have exT : IsEdge x.1 T.1 := mk ![2,5,11,15] ![10,13,16,17]
    (by rintro (_|_|_|i) hh <;> first | omega | simp_all) (by rintro (_|_|i) hh <;> first | omega | simp_all)
  have ezT : IsEdge z.1 T.1 := mk ![7,9,12,14] ![10,13,16,17]
    (by rintro (_|_|_|i) hh <;> first | omega | simp_all) (by rintro (_|_|i) hh <;> first | omega | simp_all)
  have eyz : IsEdge y.1 z.1 := mk ![3,6,8,10] ![7,9,12,14]
    (by rintro (_|_|_|i) hh <;> first | omega | simp_all) (by rintro (_|_|i) hh <;> first | omega | simp_all)
  have eSy : IsEdge S.1 y.1 := mk ![0,1,4,7] ![3,6,8,10]
    (by rintro (_|_|_|i) hh <;> first | omega | simp_all) (by rintro (_|_|i) hh <;> first | omega | simp_all)
  have hns := h (ℵ₀ : Cardinal.{u}) 4 (by norm_num) 5 (by decide) (by norm_num) (by norm_num)
  apply hns
  refine ⟨![S, x, T, z, y], ?_, ?_⟩
  · have hcomp : Function.Injective ((fun v : Vtx 4 (ℵ₀:Cardinal.{u}) => v.1 0) ∘ ![S,x,T,z,y]) := by
      have heq : ((fun v : Vtx 4 (ℵ₀:Cardinal.{u}) => v.1 0) ∘ ![S,x,T,z,y])
          = (fun i => e (![0,2,10,7,3] i)) := by
        funext i; fin_cases i <;> simp [hS,hx,hT,hz,hy]
      rw [heq]; exact he.injective.comp (by decide)
    exact Function.Injective.of_comp hcomp
  · intro i
    fin_cases i
    · exact Or.inl eSx
    · exact Or.inl exT
    · exact Or.inr ezT
    · exact Or.inr eyz
    · exact Or.inr eSy

end EHG
end Erdos593
