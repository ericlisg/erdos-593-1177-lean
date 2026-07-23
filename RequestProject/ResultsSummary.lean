import RequestProject.PublicationCertificate

/-!
# Citation summary: Erdős Problems 593 and 1177

The public theorem interface is universe-polymorphic.  At every universe `u`,
`FTS.Obligatory.{u}` quantifies over all host vertex types in `Type u`; this is
the intended size-indexed reading, not a weakening.  The checks below also
record the ordinary `u = 0` instances explicitly.

Problem 1177 has answers **yes / no / yes**:
1. yes: an `ℵ₁` witness can be bounded by `2^(2^ℵ₀)`;
2. no: simultaneous avoidance can fail even when each avoidance class is nonempty;
3. yes: nonemptiness transfers between all uncountable chromatic cardinals.

Mathlib's theorem `Cardinal.succ_aleph0` states
`Order.succ (ℵ₀ : Cardinal.{u}) = Cardinal.aleph 1`.
-/

open Cardinal
open Erdos593

#check classification_unconditional
#check problem_1177_part1_aleph_one
#check problem_1177_part2_aleph_one
#check problem_1177_part3_aleph_one
#check full_resolution_unconditional

-- Explicit small-universe (`u = 0`) records.
#check classification_unconditional.{0}
#check problem_1177_part1_aleph_one.{0}
#check problem_1177_part2_aleph_one.{0}
#check problem_1177_part3_aleph_one.{0}
#check full_resolution_unconditional.{0}
