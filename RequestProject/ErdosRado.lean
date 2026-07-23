import Mathlib

/-!
# Partition-calculus infrastructure towards Erdős–Rado for pairs

The Erdős–Rado theorem `(2^κ)⁺ → (κ⁺)²_κ` — for every colouring of the ordered
pairs of a set of size `(2^κ)⁺` by `≤ κ` colours there is a homogeneous set of
size `κ⁺` — is the fundamental uncountable-cardinal partition relation absent
from Mathlib and on the critical path for `E2` (the Erdős–Hajnal high-odd-girth
construction).

This file develops, `sorry`-free, the two elementary components of the standard
proof, phrased over an arbitrary linearly ordered type `α`:

* `homogeneous_of_endHomogeneous` — the **pigeonhole step**: an *end-homogeneous*
  set of size `> κ` contains a *homogeneous* set of size `> κ` (using the
  regularity of `κ⁺`).
* `card_types_le` — the **type-counting bound**: over a set of size `≤ κ` there
  are at most `2 ^ κ` colour-types.

What is *not* in this file is the transfinite heart of Erdős–Rado — the
interleaved "tree"/type recursion that produces an end-homogeneous set of size
`κ⁺` from a ground set of size `(2^κ)⁺` (the successor-cardinal step where the
`2^κ` bound is used to keep the candidate sets large through limit stages).  That
recursion is a substantial standalone development; the two components proved here
are its reusable elementary ingredients.
-/

open Cardinal

namespace Erdos593.ErdosRado

universe u

variable {α : Type u} [LinearOrder α] {γ : Type u}

/-- `H` is *homogeneous* for `f` if all ordered pairs from `H` get the same
colour `c`. -/
def Homogeneous (f : α → α → γ) (H : Set α) (c : γ) : Prop :=
  ∀ a ∈ H, ∀ b ∈ H, a < b → f a b = c

/-- `H` is *end-homogeneous* for `f` if for every `a ∈ H`, the colour `f a b` is
the same for all `b ∈ H` with `a < b`. -/
def EndHomogeneous (f : α → α → γ) (H : Set α) : Prop :=
  ∀ a ∈ H, ∀ b ∈ H, ∀ c ∈ H, a < b → a < c → f a b = f a c

/-- **Pigeonhole step.**  An end-homogeneous set of size `≥ κ⁺` (with `κ⁺`
regular, which holds automatically for `κ ≥ ℵ₀`) contains a homogeneous set of
size `≥ κ⁺`.  For each `a` in the end-homogeneous set `H` the tail colour
`g a := f a b` (any `b > a`) is well defined; `g : H → γ` has `#γ ≤ κ < cf κ⁺`,
so some fibre has size `≥ κ⁺`, and any such fibre is homogeneous. -/
theorem homogeneous_of_endHomogeneous {κ : Cardinal.{u}} (hκ : ℵ₀ ≤ κ)
    (hγ : #γ ≤ κ) (f : α → α → γ) {H : Set α}
    (hH : EndHomogeneous f H) (hcard : κ < #H) :
    ∃ (H' : Set α) (c : γ), H' ⊆ H ∧ κ < #H' ∧ Homogeneous f H' c := by
  by_contra!;
  -- Let `g : H → γ` be the function defined by `g a := f a b` for `b ∈ H` with `a < b`.
  obtain ⟨g, hg⟩ : ∃ g : H → γ, ∀ a : H, ∀ b : H, a < b → f a b = g a := by
    have hg : ∀ a : H, ∃ c : γ, ∀ b : H, a < b → f a b = c := by
      intro a; by_cases ha : ∃ b : H, a < b; aesop;
      exact ⟨ f a a, fun b hb => False.elim <| ha ⟨ b, hb ⟩ ⟩;
    exact ⟨ fun a => Classical.choose ( hg a ), fun a b hab => Classical.choose_spec ( hg a ) b hab ⟩;
  set θ : Cardinal := Order.succ κ
  have hθ : θ ≤ #H := by
    exact Order.succ_le_of_lt hcard
  have hθ_cof : #γ < θ.ord.cof := by
    convert lt_of_le_of_lt hγ ( Order.lt_succ κ ) using 1;
    convert Cardinal.IsRegular.cof_eq ( Cardinal.isRegular_succ hκ ) using 1;
  obtain ⟨c₀, hc₀⟩ : ∃ c₀ : γ, θ ≤ #(g ⁻¹' {c₀}) := by
    apply_rules [ Cardinal.infinite_pigeonhole_card ];
    exact le_trans hκ ( Order.le_succ _ );
  refine' this ( Set.image ( fun x : g ⁻¹' { c₀ } => ( x : H ) ) Set.univ ) c₀ _ _ _;
  · grind;
  · rw [ Cardinal.mk_image_eq, Cardinal.mk_univ ]
    · exact lt_of_lt_of_le ( Order.lt_succ κ ) hc₀
    · exact Subtype.coe_injective.comp Subtype.coe_injective
  · intro a ha b hb hab; aesop;

/-- **Type-counting bound.**  Over a set `P` of size `≤ κ` (with `κ` infinite)
there are at most `2 ^ κ` colour-types `P → γ`, when `#γ ≤ κ`.  This is the
cardinal bound `#γ ^ #P ≤ κ ^ κ = 2 ^ κ` that keeps the Erdős–Rado recursion
under control. -/
theorem card_types_le {κ : Cardinal.{u}} (hκ : ℵ₀ ≤ κ) {P : Type u}
    (hP : #P ≤ κ) (hγ : #γ ≤ κ) : #(P → γ) ≤ 2 ^ κ := by
  have hκ0 : κ ≠ 0 := by
    rintro h; rw [h] at hκ; exact Cardinal.aleph0_ne_zero (le_antisymm hκ (zero_le _))
  calc #(P → γ) = #γ ^ #P := by rw [Cardinal.mk_arrow]; simp
    _ ≤ κ ^ #P := Cardinal.power_le_power_right hγ
    _ ≤ κ ^ κ := Cardinal.power_le_power_left hκ0 hP
    _ = 2 ^ κ := Cardinal.power_self_eq hκ

end Erdos593.ErdosRado
