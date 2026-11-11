% -*- coding: utf-8; mode: trale-prolog -*-
% Shared budgets for weighted LP rules and structural preferences.

:- dynamic soft_constraint/4,soft_constraints_budget/2.
:- multifile soft_constraint/4,soft_constraints_budget/2.

% Options for soft_constraint/4:
%
% apply(both)        Parsing and generation (default).
% apply(parsing)     Parsing only.
% apply(generation)  Generation only.
%
% penalty(N)         Nonnegative integer cost (default: 1).
% penalty(hard)      Reject every violation, regardless of the budget.
%
% Options may appear in either order.
% Costs share the soft_constraints_budget/2 budget with weighted LP rules.
% A total equal to the budget is allowed; a higher total is rejected.
% Undetermined checks incur no cost and remain pending.

soft_constraints_budget(parsing,10).
soft_constraints_budget(generation,5).

% Extraction through dass stays available for parsing. Generation charges
% two points, so the current budget excludes it without closing an open SLASH.
% Example: "Er glaubt dass Aicke lacht" costs 0; "Aicke glaubt er dass lacht"
% costs 2 in generation. Both remain parseable.
% Private five-word generation trial (glaubt,dass,aicke,lacht,er): the same
% three accepted outputs, 70 instead of 93 edges with early budget pruning.
% Existing grammar filters enabled; no full-suite timing claim.
%
% Like an implication A *> B but configurable to apply for parsing and/or generation and combined with a penalty.
% 
soft_constraint(no_extraction_from_dass,
    (complementizer_word,
     synsem:loc:cat:head:cform:dass),
    synsem:loc:cat:arg_st:hd:arg:nonloc:slash:e_list,
    [apply(generation),penalty(hard)]).

% Es gibt Belege für Partikelvoranstellung, aber diese Stellung ist meist markiert.
%
% particle_verb ist ein Obertyp für Partikelverben im Lexikon und solche, die über LRs erzeugt werden.
%
% Vor hat er sie geschlagen.
% 
% An hat er sie gelacht.
soft_constraint(no_extraction_of_particles,
    particle_verb,
    synsem:loc:cat:arg_st:hd:arg:nonloc:slash:e_list,
    [apply(generation),penalty(hard)]).

