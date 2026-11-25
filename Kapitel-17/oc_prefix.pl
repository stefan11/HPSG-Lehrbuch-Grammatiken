% -*- coding: utf-8; mode: trale-prolog -*-
% Private experiment: close pending attraction at the transition to ordinary
% complement realization. A head-complement phrase is not a word and cannot
% subsequently be the head daughter of a head-cluster phrase. Remaining VPs
% must therefore be saturated phrasal complements. Their attraction results
% are empty, although their COMPS lists can retain realized spirits.
% Inspect the head daughter's flags, including the complement realized here.
% Already realized cluster complements must keep their attracted arguments.
% Walk the current valence list, rather than a fixed daughter-tree depth.
% Example: in "Das den Roman zu lesen den Mann zu zwingen versprechende Kind
% lacht", the pending reading VP can originate inside the embedded control
% verb. Closing only the first complement of the highest head misses it.
% Coherent cluster daughters have already been marked REALIZED plus; retain
% their prefixes so that coherent argument attraction and long passives work.
% This also reaches a pending VP inherited from a more deeply embedded verb.
% Local Chapter-17 trial, 12 November 2026. Parsing the free fragment
% "den Aufsatz zu lesen gezwungen werdendem" changes 5 analyses to 3. The
% removed two analyses have open ARG-ST tails at the control-verb stem;
% the three surviving stems have closed lists of length 3 or 4.
% In a full-lexicon generation trial restricted to the input word forms,
% the deeply embedded example above retains its 3 distinct outputs while
% the chart changes from 484 to 393 edges (one timing pair: 28.53 to 12.97 s
% CPU). All 6 restricted-vocabulary output lists match the baseline.
% The simple zwingen probe has 661 -> 717 edges, so savings vary by input.
% With the regular vocabulary configuration, versuchen finishes with 14
% outputs in 67.22 s CPU; the baseline reaches the 120-second test limit.
% The complete zwingen generation still reaches a 300-second test limit.
% The 100 residues in the original free "von ihm ..." fragment also remain.
% This experiment retains the current speed.pl constraints and has no new
% attraction-prefix binding for the subject-raising formulas.
:- multifile '*>'/2, if/2, fun/1.
:- discontiguous '*>'/2, if/2, fun/1.

head_complement_phrase *>
  head_dtr:synsem:loc:cat:comps:close_pending_attraction.

fun close_pending_attraction(-).
close_pending_attraction(List) if
  when(List=(e_list;ne_list),undelayed_close_pending_attraction(List)).
undelayed_close_pending_attraction([]) if true.
undelayed_close_pending_attraction([Argument|Rest]) if
  (close_argument_attraction(Argument),close_pending_attraction(Rest)).

close_argument_attraction((realized:Realized,arg:loc:cat:Cat)) if
  when(Realized=(plus;minus),close_argument_attraction_known(Realized,Cat)).
close_argument_attraction_known(plus,_) if true.
% The extra prefix is meaningful for verbal selections only. Do not constrain
% ordinary NP/PP categories just because they occur on the same valence list.
% Reuse the grammar's non-instantiating head-type delay (cf. agreement).
close_argument_attraction_known(minus,(head:Head,attracted_comps_:Attracted)) if
  (when(Head=participle_or_verb,Attracted=[]),
   when(disjoint(Head,participle_or_verb),true)).

% Close pending attraction at a completed cluster boundary as well.
% syntax.pl restricts the HEAD_DTR of a head_cluster_phrase to word_or_v_trace;
% its phrase mother cannot be such a head later. It can still be selected
% by a higher word, which may attract its ordinary, already known arguments.
% Inspect the MOTHER's COMPS: the verb combined by this cluster rule is now
% REALIZED plus, so close_argument_attraction_known/2 leaves its prefix alone.
% Remaining REALIZED minus verbal selections must be ordinary complements;
% they cannot contribute an additional, still unknown attracted prefix here.
% Empty ATTRACTED_COMPS_ closes that prefix, not the entire COMPS list:
% realized spirits and the fixed matrix arguments remain available. The
% latter come from the fixed tail in append_matrix_arguments/4; this rule
% closes only the recorded attraction prefix of the pending selected VP.
%
% Example (private Chapter-17 comparison, 19 November 2026): parsing the free
% fragment "gezwungen zu werden versprochen bekommendes" gives 8 -> 4
% derivations. The zwingen ARG-ST tail changes from open in all 8 original
% derivations to closed (length 3) in all 4 survivors. The top cluster COMPS
% also changes from an open tail to closed lists of length 4 or 5. Its known
% matrix arguments remain; the constituent is not required to be saturated.
% Fragments containing
% "den Aufsatz zu lesen" keep their 2/4 derivations and closed ARG-ST lists.
% 17 focused and 16 AcI parse comparisons retain their baseline semantic,
% overt-case and score classes. Some baseline cases have no analysis; those
% cases are not positive preservation evidence. Full regular-vocabulary
% generation of "Er versucht ihn anzulachen" retains all 17 word sequences,
% exact scores and zero residues: 940 -> 908 chart edges; 43.335 -> 34.337 s
% CPU in one concurrent comparison (not a general timing guarantee).
% All 216 positive testsuite inputs retain their semantic/case/score classes
% and zero residues, including the updated Speisekammer examples. The deeper
% item 230 still times out at native 1200000 ms with no generated output:
% 2031 active/2657 inactive edges, 1150.787 s CPU, 1215.675 s elapsed. The
% timeout is NOT solved; no same-weights full baseline comparison was run.
head_cluster_phrase *>
  synsem:loc:cat:comps:close_pending_attraction.
