% -*- coding: utf-8; mode: trale-prolog -*-
% Shared budgets for weighted LP rules and structural preferences.

:- dynamic soft_constraint/4,soft_constraints_budget/2.
:- multifile soft_constraint/4,soft_constraints_budget/2.

soft_constraints_budget(parsing,1).
soft_constraints_budget(generation,1).

% Extraction through dass stays available for parsing. Generation charges
% two points, so the current budget excludes it without closing an open SLASH.
% Example: "Er glaubt dass Aicke lacht" costs 0; "Aicke glaubt er dass lacht"
% costs 2 in generation. Both remain parseable.
% Private five-word generation trial (glaubt,dass,aicke,lacht,er): the same
% three accepted outputs, 70 instead of 93 edges with early budget pruning.
% Existing grammar filters enabled; no full-suite timing claim.
soft_constraint(no_extraction_from_dass,
    (complementizer_word,
     synsem:loc:cat:head:cform:dass),
    synsem:loc:cat:arg_st:hd:arg:nonloc:slash:e_list,
    [apply(generation),penalty(2)]).
