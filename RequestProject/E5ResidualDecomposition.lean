import RequestProject.E5ObstructionGrid

/-!
# Countable obstruction blocks with an uncountably chromatic residual

The obstruction-grid construction can be strengthened by retaining, after all
countably many blocks have been selected, an uncountably chromatic residual
host.  This is useful for recursive Hajnal--Komjáth extraction arguments: the
selected countable cores consume only countably many vertices, so the remainder
still has the full uncountable chromatic obstruction.
-/

open Cardinal

namespace Erdos593

universe u

variable {W : Type u}

/-
Countably many mutually vertex-disjoint, exactly countably chromatic linear
cores can be selected away from a prescribed countable set, while the hypergraph
induced by avoiding all their vertices remains uncountably chromatic.
-/
theorem exists_disjoint_countable_cores_with_uncountable_residual
    (H : Hypergraph W) (htri : H.IsTripleSystem) (hlin : H.Linear)
    (huc : H.UncountablyChromatic) {S : Set W} (hS : S.Countable) :
    ∃ (A : ℕ → Set (Set W)) (U : Set W) (R : Hypergraph W),
      (∀ r, (A r).Countable ∧ A r ⊆ H.edges ∧
        (∀ e ∈ A r, e ⊆ Sᶜ) ∧
        (⟨A r⟩ : Hypergraph W).IsTripleSystem ∧
        (⟨A r⟩ : Hypergraph W).Linear ∧
        (⟨A r⟩ : Hypergraph W).ColorableBy ℵ₀ ∧
        ∀ k, 0 < k → ¬ ∃ c : W → Fin k,
          (⟨A r⟩ : Hypergraph W).ProperColoring c) ∧
      U = ⋃ r, ⋃ e ∈ A r, e ∧
      U.Countable ∧ U ⊆ Sᶜ ∧
      (∀ ⦃r s⦄, r ≠ s →
        Disjoint (⋃ e ∈ A r, e) (⋃ e ∈ A s, e)) ∧
      R.edges = {e | e ∈ H.edges ∧ e ⊆ Uᶜ} ∧
      R.IsTripleSystem ∧ R.Linear ∧ R.UncountablyChromatic ∧
      (∀ r e, e ∈ A r → ∀ f ∈ R.edges, Disjoint e f) := by
  obtain ⟨ A, hA₁, hA₂ ⟩ := Erdos593.exists_disjoint_linear_exactly_countably_chromatic_family H htri hlin huc hS
  generalize_proofs at *;
  refine' ⟨ A, _, _, hA₁, rfl, _, _, hA₂, _ ⟩;
  exact ⟨ { e | e ∈ H.edges ∧ e ⊆ ( ⋃ r, ⋃ e ∈ A r, e ) ᶜ } ⟩;
  · refine' Set.countable_iUnion fun r => _;
    exact Set.Countable.biUnion ( hA₁ r |>.1 ) fun e he => hA₁ r |>.2.2.2.1 e he |> fun h => Set.Finite.countable <| Set.finite_of_ncard_pos <| by linarith;
  · exact Set.iUnion_subset fun r => Set.iUnion₂_subset fun e he => hA₁ r |>.2.2.1 e he;
  · refine' ⟨ rfl, _, _, _, _ ⟩;
    · exact fun e he => htri e he.1;
    · intro e₁ he₁ e₂ he₂ hne u hu₁ hu₂;
      exact fun h => by have := hlin e₁ he₁.1 e₂ he₂.1 hne; aesop;
    · convert Erdos593.uncountablyChromatic_avoid_countable H htri huc _;
      refine' Set.countable_iUnion fun r => _;
      exact Set.Countable.biUnion ( hA₁ r |>.1 ) fun e he => hA₁ r |>.2.2.2.1 e he |> fun h => Set.Finite.countable <| Set.finite_of_ncard_pos <| by linarith;
    · simp +contextual [ Set.disjoint_left ];
      exact fun r e he f hf hf' a ha => fun ha' => hf' r e he ha' ha

/-
The preceding decomposition can additionally avoid any prescribed
countable family of host edges.
-/
theorem exists_disjoint_countable_cores_with_uncountable_residual_avoid
    (H : Hypergraph W) (htri : H.IsTripleSystem) (hlin : H.Linear)
    (huc : H.UncountablyChromatic) {S : Set W} (hS : S.Countable)
    {B : Set (Set W)} (hB : B.Countable) :
    ∃ (A : ℕ → Set (Set W)) (U : Set W) (R : Hypergraph W),
      (∀ r, (A r).Countable ∧ A r ⊆ H.edges ∧
        (∀ e ∈ A r, e ∉ B ∧ e ⊆ Sᶜ) ∧
        (⟨A r⟩ : Hypergraph W).IsTripleSystem ∧
        (⟨A r⟩ : Hypergraph W).Linear ∧
        (⟨A r⟩ : Hypergraph W).ColorableBy ℵ₀ ∧
        ∀ k, 0 < k → ¬ ∃ c : W → Fin k,
          (⟨A r⟩ : Hypergraph W).ProperColoring c) ∧
      U = ⋃ r, ⋃ e ∈ A r, e ∧
      U.Countable ∧ U ⊆ Sᶜ ∧
      (∀ ⦃r s⦄, r ≠ s →
        Disjoint (⋃ e ∈ A r, e) (⋃ e ∈ A s, e)) ∧
      R.edges = {e | e ∈ H.edges ∧ e ∉ B ∧ e ⊆ Uᶜ} ∧
      R.IsTripleSystem ∧ R.Linear ∧ R.UncountablyChromatic ∧
      (∀ r e, e ∈ A r → ∀ f ∈ R.edges, Disjoint e f) := by
  -- Let H' be the subhypergraph of H with edges H.edges \ B.
  set H' : Hypergraph W := ⟨H.edges \ B⟩;
  have hH'_uncountablyChromatic : H'.UncountablyChromatic := by
    apply uncountablyChromatic_delete_countable_edges H htri huc hB
  have hH'_triple : H'.IsTripleSystem := by
    exact fun e he => htri e he.1
  have hH'_linear : H'.Linear := by
    exact fun e he f hf hne => hlin e ( Set.diff_subset he ) f ( Set.diff_subset hf ) hne
  obtain ⟨A, U, R, hA, hU, hR⟩ := exists_disjoint_countable_cores_with_uncountable_residual H' hH'_triple hH'_linear hH'_uncountablyChromatic hS;
  use A, U, R;
  grind

/-
Every uncountably chromatic linear triple system splits off a countable
vertex set whose induced edge system has no finite proper colouring, while the
edge system wholly outside that set remains uncountably chromatic.
-/
theorem exists_countable_unbounded_part_and_uncountable_residual
    (H : Hypergraph W) (htri : H.IsTripleSystem) (hlin : H.Linear)
    (huc : H.UncountablyChromatic) {S : Set W} (hS : S.Countable) :
    ∃ U : Set W,
      U.Countable ∧ U ⊆ Sᶜ ∧
      (⟨{e | e ∈ H.edges ∧ e ⊆ Uᶜ}⟩ : Hypergraph W).UncountablyChromatic ∧
      ∀ k, 0 < k → ¬ ∃ c : W → Fin k,
        (⟨{e | e ∈ H.edges ∧ e ⊆ U}⟩ : Hypergraph W).ProperColoring c := by
  obtain ⟨ A, U, R, hA, hU, hR ⟩ := exists_disjoint_countable_cores_with_uncountable_residual H htri hlin huc hS;
  refine' ⟨ U, hR.1, hR.2.1, _, _ ⟩;
  · convert hR.2.2.2.2.2.2.1;
    exact hR.2.2.2.1.symm;
  · intro k hk h
    obtain ⟨ c, hc ⟩ := h
    have hA0 : ∀ e ∈ A 0, e ⊆ U := by
      exact fun e he => hU.symm ▸ Set.subset_iUnion₂_of_subset 0 e ( Set.subset_iUnion_of_subset he ( Set.Subset.refl _ ) );
    exact hA 0 |>.2.2.2.2.2.2 k hk ⟨ c, fun e he => hc e ⟨ hA 0 |>.2.1 he, hA0 e he ⟩ ⟩

/-
The countable/uncountable split can avoid a countable list of edges on
both sides, without losing the unbounded finite chromatic obstruction in the
countable part.
-/
theorem exists_countable_unbounded_part_and_uncountable_residual_avoid
    (H : Hypergraph W) (htri : H.IsTripleSystem) (hlin : H.Linear)
    (huc : H.UncountablyChromatic) {S : Set W} (hS : S.Countable)
    {B : Set (Set W)} (hB : B.Countable) :
    ∃ U : Set W,
      U.Countable ∧ U ⊆ Sᶜ ∧
      (⟨{e | e ∈ H.edges ∧ e ∉ B ∧ e ⊆ Uᶜ}⟩ : Hypergraph W).UncountablyChromatic ∧
      ∀ k, 0 < k → ¬ ∃ c : W → Fin k,
        (⟨{e | e ∈ H.edges ∧ e ∉ B ∧ e ⊆ U}⟩ : Hypergraph W).ProperColoring c := by
  obtain ⟨ A, U, R, hA, hU, hU_countable, hU_subset, h_disjoint, hR_edges, hR_tri, hR_lin, hR_uc, h_disjoint_edges ⟩ := Erdos593.exists_disjoint_countable_cores_with_uncountable_residual_avoid H htri hlin huc hS hB;
  refine' ⟨ U, hU_countable, hU_subset, _, _ ⟩;
  · convert hR_uc;
    exact hR_edges.symm;
  · intro k hk
    by_contra h_contra
    obtain ⟨c, hc⟩ := h_contra;
    refine' hA 0 |>.2.2.2.2.2.2 k hk ⟨ c, fun e he => hc e ⟨ hA 0 |>.2.1 he, hA 0 |>.2.2.1 e he |>.1, _ ⟩ ⟩;
    exact hU.symm ▸ Set.subset_iUnion₂_of_subset 0 e ( Set.subset_iUnion_of_subset he ( Set.Subset.refl _ ) )

end Erdos593