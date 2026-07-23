import Mathlib

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Components of the bridge-trace engine (§4)

This file formalizes the self-contained finite graph-theoretic lemmas that make
up the combinatorial core of the paper's §4 "Finite linear traces of the lift":

* `labelled_forest` (`lem:labelled-forest`): a finite oriented, edge-labelled
  forest carries pairwise-distinct finite words on its vertices, compatible with
  the orientation and labels via the proper-prefix / coordinate condition.

These are theorems of finite combinatorics, stated and proved from scratch.
-/

open Classical

namespace Erdos593

/-
A finite acyclic graph on a nontrivial vertex type has a vertex of degree at
most one (a leaf, or an isolated vertex).
-/
theorem forest_exists_degree_le_one {V : Type} [Fintype V] [DecidableEq V] [Nontrivial V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (h : G.IsAcyclic) :
    ∃ z, G.degree z ≤ 1 := by
  -- Since G is a forest, it has at least one tree component.
  obtain ⟨T, hT⟩ : ∃ T : G.ConnectedComponent, True := by
    simp +zetaDelta at *;
  by_cases hT_singleton : ∀ v : V, T = G.connectedComponentMk v → ∀ w : V, G.Reachable v w → v = w;
  · obtain ⟨v, hv⟩ : ∃ v : V, T = G.connectedComponentMk v := by
      exact T.exists_rep.imp fun v hv => hv.symm;
    use v;
    exact Finset.card_le_one.mpr fun w hw x hx => by have := hT_singleton v hv w ( SimpleGraph.Adj.reachable <| by simpa using hw ) ; have := hT_singleton v hv x ( SimpleGraph.Adj.reachable <| by simpa using hx ) ; aesop;
  · obtain ⟨v, hv⟩ : ∃ v : V, T = G.connectedComponentMk v ∧ ∃ w : V, G.Reachable v w ∧ v ≠ w := by
      aesop;
    have hT_tree : (G.induce (G.connectedComponentMk v).supp).IsTree := by
      convert SimpleGraph.IsAcyclic.isTree_connectedComponent h _;
    obtain ⟨z, hz⟩ : ∃ z : (G.connectedComponentMk v).supp, (G.induce (G.connectedComponentMk v).supp).degree z ≤ 1 := by
      have := hT_tree.card_edgeFinset;
      contrapose! this;
      have := SimpleGraph.sum_degrees_eq_twice_card_edges ( G.induce ( G.connectedComponentMk v ).supp );
      have := Finset.sum_le_sum fun x ( hx : x ∈ Finset.univ ) => Nat.succ_le_of_lt ( ‹∀ z : ↑ ( G.connectedComponentMk v ).supp, 1 < ( SimpleGraph.induce ( G.connectedComponentMk v ).supp G ).degree z› x ) ; simp_all +decide [ mul_comm ] ;
      grind;
    use z.val;
    convert hz using 1;
    refine' Finset.card_bij ( fun x hx => ⟨ x, _ ⟩ ) _ _ _ <;> simp_all +decide [ SimpleGraph.degree, SimpleGraph.neighborFinset ];
    grind +suggestions

/-
**Labelled forest lemma** (`lem:labelled-forest`).  Let the oriented edge
relation `E` (with `hasym`: at most one direction between any pair) have an
acyclic underlying undirected graph `SimpleGraph.fromRel E` (a finite forest),
and let `lbl` label each oriented edge by an element of `Ω`.  Then there are
pairwise-distinct finite words `w x` over `Ω` such that for every oriented edge
`x → y`, `w x` is a proper prefix of `w y` and the letter of `w y` at coordinate
`|w x|` is the label `lbl x y`.
-/
theorem labelled_forest {V : Type} [Fintype V] [DecidableEq V] {Ω : Type}
    (E : V → V → Prop) [DecidableRel E] (lbl : V → V → Ω)
    (hasym : ∀ x y, E x y → ¬ E y x)
    (hacyc : (SimpleGraph.fromRel E).IsAcyclic) :
    ∃ w : V → List Ω, Function.Injective w ∧
      ∀ x y, E x y → (w x <+: w y ∧ w x ≠ w y ∧ (w y)[(w x).length]? = some (lbl x y)) := by
  by_cases h_nonempty : Nonempty Ω;
  · induction' hn : Fintype.card V using Nat.strong_induction_on with n ih generalizing V E lbl;
    by_cases h_card : n ≤ 1;
    · interval_cases n <;> simp_all +decide [ Function.Injective ];
      · rw [ Fintype.card_eq_zero_iff ] at hn ; aesop;
      · rw [ Fintype.card_eq_one_iff ] at hn; obtain ⟨ x, hx ⟩ := hn; use fun _ => [ ] ; aesop;
    · -- Apply `forest_exists_degree_le_one` to get a leaf `z` with `(SimpleGraph.fromRel E).degree z ≤ 1`.
      obtain ⟨z, hz⟩ : ∃ z : V, (SimpleGraph.fromRel E).degree z ≤ 1 := by
        convert forest_exists_degree_le_one ( SimpleGraph.fromRel E ) hacyc;
        exact Fintype.one_lt_card_iff_nontrivial.mp ( by linarith );
      -- Set `V' := {x : V // x ≠ z}`. Define the restricted relation `E' : V' → V' → Prop := fun a b => E a.1 b.1`, restricted label `lbl' a b := lbl a.1 b.1`.
      set V' := {x : V // x ≠ z}
      set E' : V' → V' → Prop := fun a b => E a.val b.val
      set lbl' : V' → V' → Ω := fun a b => lbl a.val b.val;
      -- By the induction hypothesis, there exists a function `u : V' → List Ω` satisfying the conditions.
      obtain ⟨u, hu_inj, hu_cond⟩ : ∃ u : V' → List Ω, Function.Injective u ∧ ∀ x y, E' x y → u x <+: u y ∧ u x ≠ u y ∧ (u y)[(u x).length]? = some (lbl' x y) := by
        convert ih ( Fintype.card V' ) _ E' lbl' _ _ rfl;
        · simp +zetaDelta at *;
          omega;
        · exact fun x y hxy => hasym _ _ hxy;
        · intro v p hp;
          convert hacyc _ _;
          exact v.val;
          convert p.map _;
          rotate_left;
          rotate_left;
          use fun x => x.val;
          all_goals norm_num [ funext_iff ];
          grind;
          convert hp.map _;
          exact Subtype.coe_injective;
      -- Consider the three cases for the leaf `z`.
      by_cases h_case_a : ∃ y, E z y;
      · obtain ⟨ y, hy ⟩ := h_case_a;
        -- Define the function `w` for the case when there is an out-edge from `z`.
        use fun x => if hx : x = z then [] else (lbl z y) :: u ⟨x, hx⟩;
        refine' ⟨ _, _ ⟩;
        · intro x y hxy;
          by_cases hx : x = z <;> by_cases hy : y = z <;> simp +decide [ hx, hy ] at hxy ⊢;
          exact Subtype.ext_iff.mp ( hu_inj hxy );
        · intro x y hxy;
          by_cases hx : x = z <;> by_cases hy : y = z <;> simp +decide [ hx, hy ] at hxy ⊢;
          · exact hasym _ _ hxy hxy;
          · contrapose! hz;
            refine' Finset.one_lt_card.mpr ⟨ y, _, _ ⟩ <;> simp +decide [ *, SimpleGraph.fromRel_adj ];
            · tauto;
            · grind;
          · contrapose! hz;
            refine' Finset.one_lt_card.mpr ⟨ x, _, _ ⟩ <;> simp +decide [ *, SimpleGraph.fromRel_adj ];
            · tauto;
            · grind;
          · exact hu_cond ⟨ x, hx ⟩ ⟨ y, hy ⟩ hxy;
      · by_cases h_case_b : ∃ y, E y z;
        · obtain ⟨y, hy⟩ : ∃ y, E y z ∧ ∀ x, E x z → x = y := by
            obtain ⟨ y, hy ⟩ := h_case_b;
            refine' ⟨ y, hy, fun x hx => _ ⟩;
            contrapose! hz;
            refine' Finset.one_lt_card.mpr ⟨ y, _, x, _, _ ⟩ <;> simp +decide [ *, SimpleGraph.fromRel_adj ];
            · grind;
            · grind;
            · tauto;
          -- Define `w` such that `w z = u y ++ (lbl y z :: List.replicate N c₀)` and `w x = u x` for `x ≠ z`.
          obtain ⟨N, hN⟩ : ∃ N : ℕ, ∀ x : V', (u x).length < N := by
            exact ⟨ Finset.sup ( Finset.image ( fun x : V' => ( u x |> List.length ) ) Finset.univ ) id + 1, fun x => Nat.lt_succ_of_le ( Finset.le_sup ( f := id ) ( Finset.mem_image_of_mem _ ( Finset.mem_univ _ ) ) ) ⟩;
          refine' ⟨ fun x => if hx : x = z then u ⟨ y, by aesop ⟩ ++ ( lbl y z :: List.replicate N ( Classical.arbitrary Ω ) ) else u ⟨ x, hx ⟩, _, _ ⟩;
          · intro x y hxy;
            grind;
          · grind +qlia;
        · -- Set `w z := List.replicate N c₀` with `N := (Finset.univ.sup fun x : V' => (u x).length) + 1`.
          obtain ⟨N, hN⟩ : ∃ N : ℕ, ∀ x : V', (u x).length < N := by
            exact ⟨ Finset.sup ( Finset.univ.image fun x : V' => ( u x |> List.length ) ) id + 1, fun x => Nat.lt_succ_of_le ( Finset.le_sup ( f := id ) ( Finset.mem_image_of_mem _ ( Finset.mem_univ x ) ) ) ⟩;
          use fun x => if hx : x = z then List.replicate N (Classical.arbitrary Ω) else u ⟨x, hx⟩;
          constructor;
          · intro x y hxy;
            grind +suggestions;
          · grind;
  · cases isEmpty_or_nonempty V <;> simp_all +decide [ Function.Injective ];
    exact False.elim <| h_nonempty.elim' <| lbl ( Classical.arbitrary V ) ( Classical.arbitrary V )

/-
**Quotient forest lemma** (`lem:quotient-forest`).  Let `G` be a finite
graph and `S` a set of edges each of which is a bridge of `G`.  Delete the edges
of `S`, contract each resulting connected component to a point, and keep the
edges of `S`.  The resulting quotient graph (a component `c` is adjacent to a
component `d` when some `S`-edge joins them) is a simple forest, i.e. acyclic.
-/
theorem quotient_forest {V : Type} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (S : Set (Sym2 V))
    (hS : ∀ e ∈ S, G.IsBridge e) :
    (SimpleGraph.fromRel (fun c d : (G.deleteEdges S).ConnectedComponent =>
        ∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧
               (G.deleteEdges S).connectedComponentMk v = d ∧ s(u,v) ∈ S)).IsAcyclic := by
  have h_connected_components : ∀ c d, SimpleGraph.Adj (SimpleGraph.fromRel (fun c d => ∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧ (G.deleteEdges S).connectedComponentMk v = d ∧ s(u, v) ∈ S)) c d → (∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧ (G.deleteEdges S).connectedComponentMk v = d ∧ s(u, v) ∈ S) := by
    simp +contextual [ SimpleGraph.fromRel_adj ];
    rintro c d hcd ( ⟨ u, hu, v, hv, huv ⟩ | ⟨ u, hu, v, hv, huv ⟩ ) <;> [ exact ⟨ u, hu, v, hv, huv ⟩ ; exact ⟨ v, hv, u, hu, by simpa only [ Sym2.eq_swap ] using huv ⟩ ];
  have h_connected_components : ∀ c d, SimpleGraph.Adj (SimpleGraph.fromRel (fun c d => ∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧ (G.deleteEdges S).connectedComponentMk v = d ∧ s(u, v) ∈ S)) c d → ∀ e ∈ S, (∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧ (G.deleteEdges S).connectedComponentMk v = d ∧ s(u, v) = e) → SimpleGraph.IsBridge (SimpleGraph.fromRel (fun c d => ∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧ (G.deleteEdges S).connectedComponentMk v = d ∧ s(u, v) ∈ S)) (Sym2.mk (c, d)) := by
    intros c d h_adj e he h_exists
    obtain ⟨u, v, hu, hv, he_eq⟩ := h_exists
    have h_not_reachable : ¬(G \ SimpleGraph.fromEdgeSet {e}).Reachable u v := by
      have := hS e he;
      convert this.2;
      rw [ ← he_eq ] ; rfl;
    have h_lift : ∀ a b : (G.deleteEdges S).ConnectedComponent, ∀ p : SimpleGraph.Walk (SimpleGraph.fromRel (fun c d => ∃ u v, (G.deleteEdges S).connectedComponentMk u = c ∧ (G.deleteEdges S).connectedComponentMk v = d ∧ s(u, v) ∈ S) \ SimpleGraph.fromEdgeSet {Sym2.mk (c, d)}) a b, ∀ x y : V, (G.deleteEdges S).connectedComponentMk x = a → (G.deleteEdges S).connectedComponentMk y = b → (G \ SimpleGraph.fromEdgeSet {e}).Reachable x y := by
      intros a b p x y hx hy;
      induction' p with a b p ih generalizing x y;
      · have h_reachable : (G.deleteEdges S).Reachable x y := by
          grind +suggestions;
        refine' h_reachable.mono _;
        intro u v; simp [SimpleGraph.deleteEdges];
        grind;
      · rename_i h₁ h₂ h₃;
        obtain ⟨ u, v, hu, hv, he ⟩ := h_connected_components _ _ ( by simpa using h₁.1 );
        have h_lift : (G \ SimpleGraph.fromEdgeSet {e}).Reachable x u := by
          have h_lift : (G.deleteEdges S).Reachable x u := by
            grind +suggestions;
          convert h_lift.mono _;
          intro x y; simp +decide [ SimpleGraph.deleteEdges ] ;
          grind;
        have h_lift : (G \ SimpleGraph.fromEdgeSet {e}).Reachable u v := by
          have h_lift : G.Adj u v := by
            have := hS _ he;
            exact this.1;
          have h_lift : s(u, v) ≠ e := by
            have := h₁.2; simp_all +decide [ SimpleGraph.fromEdgeSet ] ;
            grind;
          exact SimpleGraph.Adj.reachable ( by aesop );
        exact SimpleGraph.Reachable.trans ‹_› ( SimpleGraph.Reachable.trans h_lift ( h₃ _ _ hv hy ) );
    refine' ⟨ h_adj, _ ⟩;
    contrapose! h_lift;
    obtain ⟨ p ⟩ := Classical.not_not.1 h_lift;
    exact ⟨ _, _, p, _, _, hu, hv, h_not_reachable ⟩;
  apply SimpleGraph.isAcyclic_iff_forall_adj_isBridge.mpr;
  grind

end Erdos593