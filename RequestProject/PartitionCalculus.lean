import Mathlib

/-!
# Partition calculus infrastructure towards E2

The irreducible content of `E2` (Erdős–Hajnal exact high-odd-girth graphs,
`Erdos593.E2Core` in `RequestProject/E2Construction.lean`) is a transfinite
chromatic lower bound whose successor-cardinal step rests on **partition
relations of Erdős–Rado type**.  None of this partition calculus is available in
Mathlib (only the level-1 infinite pigeonhole principle exists).

This file begins building that missing foundation from scratch, `sorry`-free.
The seed of the whole Erdős–Rado hierarchy is the **infinite Ramsey theorem**
`ℵ₀ → (ℵ₀)²_k`: every finite colouring of the ordered pairs of natural numbers
admits an infinite monochromatic set.  We prove it here; it is the base case
(exponent `2`, one uncountable step below) of the calculus that E2 needs.
-/

namespace Erdos593.PartitionCalculus

/-
**Infinite Ramsey theorem for pairs and finitely many colours**
(`ℵ₀ → (ℵ₀)²_k`).  For any colouring `c` of the ordered pairs `a < b` of natural
numbers by `k` colours, there is an infinite set `S ⊆ ℕ` and a colour `i` such
that every ordered pair from `S` has colour `i`.
-/
theorem infinite_ramsey_pairs {k : ℕ} (c : ℕ → ℕ → Fin k) :
    ∃ (S : Set ℕ) (i : Fin k), S.Infinite ∧
      ∀ a ∈ S, ∀ b ∈ S, a < b → c a b = i := by
  have h_pigeonhole : ∀ (L : Set ℕ), L.Infinite → ∀ (g : ℕ → Fin k), ∃ i : Fin k, {x ∈ L | g x = i}.Infinite := by
    intro L hL g;
    contrapose! hL;
    exact Set.Finite.subset ( Set.Finite.biUnion ( Set.toFinite ( Finset.univ : Finset ( Fin k ) ) ) fun i _ => hL i ) fun x hx => by aesop;
  -- Define the sequence of pairs $(a_n, T_n)$ where $T_n$ is an infinite subset of $\mathbb{N}$ and $a_n \in T_n$.
  have h_seq : ∃ (a : ℕ → ℕ) (T : ℕ → Set ℕ), (∀ n, (T n).Infinite) ∧ (∀ n, a n ∈ T n) ∧ (∀ n, a n < sInf (T (n + 1))) ∧ (∀ n, ∀ b ∈ T (n + 1), c (a n) b = c (a n) (sInf (T (n + 1)))) ∧ (∀ n, T (n + 1) ⊆ T n) ∧ (∀ n, a n < a (n + 1)) := by
    have h_seq : ∃ (T : ℕ → Set ℕ), (∀ n, (T n).Infinite) ∧ (∀ n, T (n + 1) ⊆ T n) ∧ (∀ n, ∀ b ∈ T (n + 1), c (sInf (T n)) b = c (sInf (T n)) (sInf (T (n + 1)))) ∧ (∀ n, sInf (T n) < sInf (T (n + 1))) := by
      have h_seq : ∀ (L : Set ℕ), L.Infinite → ∃ T : Set ℕ, T ⊆ L ∧ T.Infinite ∧ ∀ b ∈ T, c (sInf L) b = c (sInf L) (sInf T) ∧ sInf L < sInf T := by
        intro L hL
        obtain ⟨i, hi⟩ : ∃ i : Fin k, {x ∈ L | x > sInf L ∧ c (sInf L) x = i}.Infinite := by
          have h_pigeonhole : Set.Infinite {x ∈ L | x > sInf L} := by
            exact Set.Infinite.diff hL ( Set.finite_le_nat ( sInf L ) ) |> Set.Infinite.mono fun x hx => by aesop;
          rename_i h;
          exact h { x | x ∈ L ∧ x > sInf L } h_pigeonhole ( fun x => c ( sInf L ) x ) |> fun ⟨ i, hi ⟩ => ⟨ i, hi.mono fun x hx => by aesop ⟩;
        use {x ∈ L | x > sInf L ∧ c (sInf L) x = i};
        refine' ⟨ fun x hx => hx.1, hi, fun x hx => ⟨ _, _ ⟩ ⟩;
        · rw [ hx.2.2, show c ( sInf L ) ( sInf { x | x ∈ L ∧ x > sInf L ∧ c ( sInf L ) x = i } ) = i from ?_ ];
          exact Nat.sInf_mem ( hi.nonempty ) |>.2.2;
        · exact lt_of_lt_of_le ( Nat.lt_succ_self _ ) ( le_csInf ⟨ x, hx ⟩ fun y hy => Nat.succ_le_of_lt hy.2.1 );
      choose! T hT₁ hT₂ hT₃ using h_seq;
      use fun n => Nat.recOn n Set.univ fun n ih => T ih;
      refine' ⟨ _, _, _, _ ⟩;
      · exact fun n => Nat.recOn n ( Set.infinite_univ ) fun n ih => hT₂ _ ih;
      · exact fun n => hT₁ _ ( by exact Nat.recOn n ( Set.infinite_univ ) fun n ih => hT₂ _ ih );
      · exact fun n b hb => hT₃ _ ( show Set.Infinite ( Nat.recOn n Set.univ fun n ih => T ih ) from Nat.recOn n ( Set.infinite_univ ) fun n ih => hT₂ _ ih ) _ hb |>.1;
      · intro n;
        exact hT₃ _ ( show Set.Infinite ( Nat.recOn n Set.univ fun n ih => T ih ) from Nat.recOn n ( Set.infinite_univ ) fun n ih => hT₂ _ ih ) _ ( Classical.choose_spec ( Set.Infinite.nonempty ( hT₂ _ ( show Set.Infinite ( Nat.recOn n Set.univ fun n ih => T ih ) from Nat.recOn n ( Set.infinite_univ ) fun n ih => hT₂ _ ih ) ) ) ) |>.2;
    obtain ⟨ T, hT₁, hT₂, hT₃, hT₄ ⟩ := h_seq;
    use fun n => sInf (T n), T;
    exact ⟨ hT₁, fun n => Nat.sInf_mem ( hT₁ n |> Set.Infinite.nonempty ), hT₄, hT₃, hT₂, hT₄ ⟩;
  obtain ⟨ a, T, hT₁, hT₂, hT₃, hT₄, hT₅, hT₆ ⟩ := h_seq;
  -- Now d : ℕ → Fin k has infinite domain and finite codomain, so by pigeonhole some colour i occurs for infinitely many indices: let M = {n | dₙ = i} be infinite.
  obtain ⟨i, hi⟩ : ∃ i : Fin k, Set.Infinite {n | c (a n) (sInf (T (n + 1))) = i} := by
    exact h_pigeonhole Set.univ Set.infinite_univ ( fun n => c ( a n ) ( sInf ( T ( n + 1 ) ) ) ) |> fun ⟨ i, hi ⟩ => ⟨ i, hi.mono fun n hn => hn.2 ⟩;
  refine' ⟨ Set.image a { n | c ( a n ) ( sInf ( T ( n + 1 ) ) ) = i }, i, _, _ ⟩;
  · refine' hi.image _;
    exact fun x hx y hy hxy => StrictMono.injective ( strictMono_nat_of_lt_succ hT₆ ) hxy;
  · simp +zetaDelta at *;
    intro n hn m hm hnm;
    rw [ ← hn, hT₄ n ( a m ) ];
    exact Set.mem_of_subset_of_mem ( show T ( n + 1 ) ⊇ T m from by exact Nat.le_induction ( by tauto ) ( fun k hk ih ↦ by exact Set.Subset.trans ( hT₅ _ ) ih ) _ ( show n + 1 ≤ m from Nat.succ_le_of_lt ( Nat.lt_of_not_ge fun h ↦ by linarith [ show a n ≥ a m from by exact monotone_nat_of_le_succ ( fun n ↦ le_of_lt ( hT₆ n ) ) h ] ) ) ) ( hT₂ m )

/-- Infinite pigeonhole over a fixed infinite ground set: for an infinite set
`L` and any `k`-colouring `g` of `ℕ`, some colour class meets `L` in an infinite
set. -/
theorem exists_infinite_fiber_of_infinite {k : ℕ} (L : Set ℕ) (hL : L.Infinite)
    (g : ℕ → Fin k) : ∃ i : Fin k, {x ∈ L | g x = i}.Infinite := by
  contrapose! hL
  exact Set.Finite.subset
    (Set.Finite.biUnion (Set.toFinite (Finset.univ : Finset (Fin k)))
      fun i _ => hL i) fun x hx => by aesop

/-
**The recursion powering the exponent step.**  Given the exponent-`n` Ramsey
statement (`ih`), an infinite ground set `L` and a colouring `c`, build a nested
chain of infinite tail sets `T` with least elements `a m = sInf (T m)` and
colours `d m`, so that any `n`-subset of `T (m+1)` gets colour `d m` when the
point `a m` is prepended.
-/
theorem ramsey_chain {n : ℕ}
    (ih : ∀ {k : ℕ} (c : Finset ℕ → Fin k) (L : Set ℕ), L.Infinite →
      ∃ (S : Set ℕ) (i : Fin k), S ⊆ L ∧ S.Infinite ∧
        ∀ t : Finset ℕ, ↑t ⊆ S → t.card = n → c t = i)
    {k : ℕ} (c : Finset ℕ → Fin k) (L : Set ℕ) (hL : L.Infinite) :
    ∃ (T : ℕ → Set ℕ) (a : ℕ → ℕ) (d : ℕ → Fin k),
      T 0 = L ∧ (∀ m, (T m).Infinite) ∧ (∀ m, T (m + 1) ⊆ T m) ∧
      (∀ m, a m = sInf (T m)) ∧ (∀ m, a m ∉ T (m + 1)) ∧
      (∀ m (u : Finset ℕ), ↑u ⊆ T (m + 1) → u.card = n → c (insert (a m) u) = d m) := by
  revert ih;
  intro ih
  have h_step : ∀ (L' : Set ℕ), L'.Infinite → ∃ (S : Set ℕ) (aa : ℕ) (dd : Fin k), S ⊆ L' ∧ S.Infinite ∧ aa = sInf L' ∧ aa ∉ S ∧ ∀ (u : Finset ℕ), (u : Set ℕ) ⊆ S → u.card = n → c (insert aa u) = dd := by
    intro L' hL'
    obtain ⟨S, i, hS_sub, hS_inf, hS_hom⟩ := ih (fun u => c (insert (sInf L') u)) (L' \ {sInf L'}) (by
    exact hL'.diff ( Set.finite_singleton _ ));
    exact ⟨ S, sInf L', i, fun x hx => hS_sub hx |>.1, hS_inf, rfl, fun hx => hS_sub hx |>.2 rfl, hS_hom ⟩;
  choose! S aa dd hS hS' haa haa' hdd using h_step;
  refine' ⟨ fun m => Nat.recOn m L fun m ih => S ih, fun m => aa ( Nat.recOn m L fun m ih => S ih ), fun m => dd ( Nat.recOn m L fun m ih => S ih ) ( show ( Nat.recOn m L fun m ih => S ih ) |> Set.Infinite from Nat.recOn m hL fun m ih => hS' _ ih ), _, _, _, _, _ ⟩ <;> simp +decide [ * ];
  · exact fun m => Nat.recOn m hL fun m ih => hS' _ ih;
  · exact fun m => hS _ ( by exact Nat.recOn m hL fun m ih => hS' _ ih );
  · exact fun m => haa _ ( by exact Nat.recOn m hL fun m ih => hS' _ ih );
  · exact ⟨ fun m => haa' _ ( by exact Nat.recOn m hL fun m ih => hS' _ ih ), fun m u hu hu' => hdd _ ( by exact Nat.recOn m hL fun m ih => hS' _ ih ) _ hu hu' ⟩

/-
The points `a m = sInf (T m)` of a Ramsey chain are strictly increasing.
-/
theorem chain_strictMono {T : ℕ → Set ℕ} {a : ℕ → ℕ}
    (hInf : ∀ m, (T m).Infinite) (hsub : ∀ m, T (m + 1) ⊆ T m)
    (ha : ∀ m, a m = sInf (T m)) (hnotin : ∀ m, a m ∉ T (m + 1)) :
    StrictMono a := by
  refine' strictMono_nat_of_lt_succ fun m => _;
  refine' lt_of_le_of_ne ( ha m ▸ ha ( m + 1 ) ▸ _ ) _;
  · exact le_csInf ( hInf _ |> Set.Infinite.nonempty ) fun x hx => Nat.sInf_le ( hsub _ hx );
  · exact fun h => hnotin m <| h.symm ▸ ha ( m + 1 ) ▸ Nat.sInf_mem ( hInf _ |> Set.Infinite.nonempty )

/-
**Homogeneity of the diagonal set of a Ramsey chain.**  If `M` is a set of
indices all coloured `i` (`d m = i`), then every `(n+1)`-subset of `a '' M` gets
colour `i`: its least point is some `a m` with `m ∈ M`, and the remaining `n`
points lie in `T (m+1)`, so its colour is `d m = i`.
-/
theorem ramsey_homog_of_chain {k n : ℕ} {c : Finset ℕ → Fin k}
    {T : ℕ → Set ℕ} {a : ℕ → ℕ} {d : ℕ → Fin k}
    (hInf : ∀ m, (T m).Infinite) (hsub : ∀ m, T (m + 1) ⊆ T m)
    (ha : ∀ m, a m = sInf (T m)) (hnotin : ∀ m, a m ∉ T (m + 1))
    (hhom : ∀ m (u : Finset ℕ), ↑u ⊆ T (m + 1) → u.card = n → c (insert (a m) u) = d m)
    {i : Fin k} {M : Set ℕ} (hM : ∀ m ∈ M, d m = i)
    {t : Finset ℕ} (ht : ↑t ⊆ a '' M) (htc : t.card = n + 1) :
    c t = i := by
  -- Set `u := t.erase am`. Then `t = insert am u = insert (a m) u` (`Finset.insert_erase`), and `u.card = n` (`Finset.card_erase_of_mem am∈t`, using `t.card = n+1`).
  obtain ⟨am, ham⟩ : ∃ am ∈ t, ∀ x ∈ t, am ≤ x := by
    exact ⟨ Nat.find <| Finset.card_pos.mp <| htc.symm ▸ Nat.succ_pos _, Nat.find_spec <| Finset.card_pos.mp <| htc.symm ▸ Nat.succ_pos _, fun x hx => Nat.find_min' _ hx ⟩
  obtain ⟨m, hmM, hm⟩ : ∃ m ∈ M, a m = am := by
    exact ht ham.1
  obtain ⟨u, hu⟩ : ∃ u : Finset ℕ, t = insert am u ∧ am ∉ u ∧ u.card = n := by
    exact ⟨ t.erase am, by rw [ Finset.insert_erase ham.1 ], by aesop, by aesop ⟩;
  -- Show `↑u ⊆ T (m+1)`: take `x ∈ u`. Then `x ∈ t` and `x ≠ am`. Since `x ∈ t ⊆ a '' M`, `x = a p` for some `p ∈ M`. We have `am = a m ≤ x = a p` (min'_le), and `a m ≠ a p` (since `x ≠ am`), so `a m < a p`, giving `m < p` via `hmono.lt_iff_lt`. Hence `m + 1 ≤ p`, so `T p ⊆ T (m+1)` by `hanti`. Now `a p = sInf (T p) ∈ T p` (`ha p`, `Nat.sInf_mem` of the nonempty infinite `T p`), so `x = a p ∈ T (m+1)`.
  have hu_subset : ∀ x ∈ u, x ∈ T (m + 1) := by
    intro x hxu
    obtain ⟨p, hpM, hp⟩ : ∃ p ∈ M, a p = x := by
      exact ht ( hu.1.symm ▸ Finset.mem_insert_of_mem hxu )
    have hmp : m < p := by
      exact lt_of_le_of_ne ( Nat.le_of_not_lt fun h => by linarith [ ham.2 _ ( hu.1.symm ▸ Finset.mem_insert_of_mem hxu ), hp, hm, show a p < a m from by { exact ( chain_strictMono hInf hsub ha hnotin ) h } ] ) ( by aesop_cat )
    have htp : T p ⊆ T (m + 1) := by
      exact Nat.le_induction ( by tauto ) ( fun k hk ih => by exact Set.Subset.trans ( hsub k ) ih ) p hmp
    have hxtp : x ∈ T p := by
      exact hp ▸ ha p ▸ Nat.sInf_mem ( hInf p |> Set.Infinite.nonempty )
    exact htp hxtp;
  grind

/-- **The exponent step**: the exponent-`n` Ramsey statement implies the
exponent-`(n+1)` statement. -/
theorem ramsey_step (n : ℕ)
    (ih : ∀ {k : ℕ} (c : Finset ℕ → Fin k) (L : Set ℕ), L.Infinite →
      ∃ (S : Set ℕ) (i : Fin k), S ⊆ L ∧ S.Infinite ∧
        ∀ t : Finset ℕ, ↑t ⊆ S → t.card = n → c t = i) :
    ∀ {k : ℕ} (c : Finset ℕ → Fin k) (L : Set ℕ), L.Infinite →
      ∃ (S : Set ℕ) (i : Fin k), S ⊆ L ∧ S.Infinite ∧
        ∀ t : Finset ℕ, ↑t ⊆ S → t.card = n + 1 → c t = i := by
  intro k c L hL
  obtain ⟨T, a, d, hT0, hInf, hsub, ha, hnotin, hhom⟩ := ramsey_chain ih c L hL
  have hmono : StrictMono a := chain_strictMono hInf hsub ha hnotin
  obtain ⟨i, hi⟩ := exists_infinite_fiber_of_infinite Set.univ Set.infinite_univ d
  refine ⟨a '' {x ∈ Set.univ | d x = i}, i, ?_, ?_, ?_⟩
  · rintro _ ⟨m, _, rfl⟩
    have hmem : a m ∈ T m := ha m ▸ Nat.sInf_mem (hInf m).nonempty
    have hTmL : T m ⊆ L := hT0 ▸ (antitone_nat_of_succ_le hsub) (Nat.zero_le m)
    exact hTmL hmem
  · exact hi.image fun x _ y _ h => hmono.injective h
  · intro t ht htc
    exact ramsey_homog_of_chain hInf hsub ha hnotin hhom (fun m hm => hm.2) ht htc

/-- **Infinite Ramsey theorem, general finite exponent, relativized form.**  For
any infinite ground set `L ⊆ ℕ` and any colouring `c` of the `n`-element subsets
of `ℕ` by `k` colours, there is an infinite `S ⊆ L` and a colour `i` such that
every `n`-element subset of `S` has colour `i`.

Stating it relative to an arbitrary infinite `L` makes the induction on the
exponent `n` self-contained: the step at exponent `n+1` removes the least element
`a` of the current tail and applies the exponent-`n` hypothesis to the induced
colouring `u ↦ c (insert a u)` on the infinite subset `L \ {a}`. -/
theorem infinite_ramsey_rel (n : ℕ) :
    ∀ {k : ℕ} (c : Finset ℕ → Fin k) (L : Set ℕ), L.Infinite →
      ∃ (S : Set ℕ) (i : Fin k), S ⊆ L ∧ S.Infinite ∧
        ∀ t : Finset ℕ, ↑t ⊆ S → t.card = n → c t = i := by
  induction n with
  | zero =>
    intro k c L hL
    exact ⟨L, c ∅, subset_refl L, hL, fun t _ htc => by
      rw [Finset.card_eq_zero] at htc; subst htc; rfl⟩
  | succ n ih => exact ramsey_step n ih

/-- **Infinite Ramsey theorem, general finite exponent** (`ℵ₀ → (ℵ₀)ⁿ_k`).  For
any colouring `c` of the `n`-element subsets of `ℕ` by `k` colours, there is an
infinite set `S ⊆ ℕ` and a colour `i` such that every `n`-element subset of `S`
has colour `i`.  This is the finite-exponent partition relation underlying the
Erdős–Rado stepping-up used by E2. -/
theorem infinite_ramsey (n : ℕ) {k : ℕ} (c : Finset ℕ → Fin k) :
    ∃ (S : Set ℕ) (i : Fin k), S.Infinite ∧
      ∀ t : Finset ℕ, ↑t ⊆ S → t.card = n → c t = i := by
  obtain ⟨S, i, _, hInf, hHom⟩ := infinite_ramsey_rel n c Set.univ Set.infinite_univ
  exact ⟨S, i, hInf, hHom⟩

end Erdos593.PartitionCalculus