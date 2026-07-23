import RequestProject.ResultsSummary
import RequestProject.PublicationCertificate

/-!
# Kernel dependency audit

The commands below make the trusted dependencies of every public unconditional
result and each independently discharged E2--E5 input visible during a build.
Expected output for every declaration is exactly:
`[propext, Classical.choice, Quot.sound]`.
-/

#print axioms Erdos593.classification_unconditional
#print axioms Erdos593.obligatory_iff_bclass_unconditional
#print axioms Erdos593.problem_1177_part1_unconditional
#print axioms Erdos593.spectrum_dichotomy_unconditional
#print axioms Erdos593.problem_1177_part3_unconditional
#print axioms Erdos593.obligatory_stronglyTripartite_unconditional
#print axioms Erdos593.cycleExpansion_obligatory_iff_unconditional
#print axioms Erdos593.problem_1177_part2_unconditional
#print axioms Erdos593.C7_linearlyObligatory_not_obligatory_unconditional

#print axioms Erdos593.e2_EH_oddgirth
#print axioms Erdos593.e3_EGH_P
#print axioms Erdos593.e4_Reiher
#print axioms Erdos593.e5_HK_loose7

#print axioms Erdos593.problem_1177_part1_aleph_one
#print axioms Erdos593.problem_1177_part2_aleph_one
#print axioms Erdos593.problem_1177_part3_aleph_one

-- The single theorem jointly certifying both complete resolutions.
#print axioms Erdos593.full_resolution_unconditional
