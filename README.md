This project was edited by [Aristotle](https://aristotle.harmonic.fun).

To cite Aristotle:
- Tag @Aristotle-Harmonic on GitHub PRs/issues
- Add as co-author to commits:
```
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```

# Lean formalization of arXiv:2606.24882

This repository contains a Lean 4 + Mathlib formalization of *A Resolution of
Erdős Problems 593 and 1177: Obligatory Triple Systems and Exact Spectra*.
The paper source is included as `paper.tex`.

The final unconditional interface is in
`RequestProject/FinalResultsUnconditional.lean`. For publication, the entire
resolution is additionally packaged as the single hypothesis-free theorem
`Erdos593.full_resolution_unconditional` in
`RequestProject/PublicationCertificate.lean`. Its `FullResolution` conclusion
states Problem #593 and all three clauses of #1177 directly, with #1177(1–3)
recording the answers **yes / no / yes**. A repository-wide verification and
source-artifact assessment is recorded in `AUDIT_REPORT.md`. In particular,
the final interface contains:

- `classification_unconditional` and `obligatory_iff_bclass_unconditional`;
- `spectrum_dichotomy_unconditional`;
- `problem_1177_part1_unconditional`, `problem_1177_part2_unconditional`, and
  `problem_1177_part3_unconditional`;
- the unconditional compatibility results, including
  `C7_linearlyObligatory_not_obligatory_unconditional`.

The last external input needed by the final interface, the Hajnal–Komjáth
loose-seven-cycle theorem, is proved as `Erdos593.e5_HK_loose7` in
`RequestProject/E5HK.lean`.

Build with:

```sh
lake build RequestProject
```

The library builds without `sorry`, `admit`, added axioms, or
`@[implemented_by]`.  Every audited final theorem—including the single joint publication
certificate—uses only Lean's standard logical axioms `propext`,
`Classical.choice`, and `Quot.sound`. It has no literature hypothesis, no
project-specific assumption, and no regularity, GCH, or CH assumption.

For citation-ready theorem signatures and explicit `u = 0` instances, see
`RequestProject/ResultsSummary.lean`. The reproducible kernel-dependency report
is `RequestProject/AxiomAudit.lean`; failed historical E2 experiments are
isolated under `RequestProject/Attic/`.
