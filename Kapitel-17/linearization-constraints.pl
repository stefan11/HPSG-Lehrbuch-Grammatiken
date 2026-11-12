% -*- coding: utf-8; mode: trale-prolog -*-
% Local argument precedence for German, using spirits as the domain.
%
% NP < dass clause: complements combine to the left of verbs/adjectives.
% Verb-initial heads do not directly combine with NP or dass complements.
% The initial prototype rejected "Glaubt dass der Affe lacht er" (1 -> 0
% analyses, 44 -> 38 passive edges), preserving the NP-first counterpart.
% Input-word-restricted generation of "Er glaubt dass der Affe lacht"
% dropped the one violating output and reduced chart edges from 105 to 94.
% Existing parser filters were enabled; no whole-suite speed claim.

:- multifile '*>'/2.
:- discontiguous '*>'/2.
:- multifile ':='/2.
:- discontiguous ':='/2.
:- multifile if/2.
:- discontiguous if/2.
:- dynamic lp_rule/2.
:- multifile lp_rule/2.

:- dynamic lp_rule/4.
:- multifile lp_rule/4.

% The budgets for violable constraints for parsing and generation are defined in soft-constraints.pl.

% Surface precedence declarations; every applicable rule must hold.

% NP < dass-CP
lp_rule(loc:cat:head:noun,
        loc:cat:head:(comp,cform:dass)).

% PP < dass-CP
%
% PP-before-CP test: "Heute wird dass der Affe lacht von dem Mann geglaubt"
% goes from 3 analyses to 0 (83 -> 69 edges); PP-first retains all 3 (89 edges).
% Existing filters enabled; this is not a whole-suite benchmark.
lp_rule(loc:cat:head:prep,
        loc:cat:head:(comp,cform:dass)).

% NP[expl] < XP
% * dass zu regnen es beginnt
lp_rule(loc:(cat:head:noun,
             cont:ind:expl),loc:cat:head:head).

% verletzbare LP-Regeln, Verletzungen werden aufsummiert.

% NP:belebt < NP:unbelebt
% Testen mit Budget 1 und "dass das Buch der Mann kennt"
lp_rule(animate_before_inanimate,
        loc:(cat:head:noun,
             cont:ind:sort:agentive),
        loc:(cat:head:noun,
             cont:ind:sort:non_agentive),
        [apply(both),penalty(2)]).


% Words of two or three letters precede verbal phrases.
lp_rule(short_word_before_vp,
        (phrase:minus,
         weight:((a_ 2);(a_ 3))),
        (phrase:plus,
         loc:cat:head:verb),
        [apply(generation),penalty(hard)]).

/*
% NP < VP[inf]
% * Den Aufsatz beginnt zu lesen er.
lp_rule(pronoun_before_zu_inf,
        loc:(cat:head:noun,
             cont:ppro),
        loc:cat:head:vform:inf,
        [apply(generation),penalty(1000)]).
*/

(head_complement_phrase,
 head_dtr:synsem:loc:cat:head:adj_or_participle_or_verb) *>
 (head_dtr:synsem:loc:cat:comps:Arguments,
  non_head_dtrs:[synsem:New]) goal spirit_lp_domain_check(Arguments,New).

% The following code may be ignored. It walks trough the COMPS list and checks whether the elements
% are just attracted although they are realized already with another head. This may happen in frontings like:
%
% Das Buch gegeben hat Aicke dem Kind.
%
% Without this check, it would seem as if "das Buch" is realized to the right of "Aicke" and "dem Kind".
%
% The check ensures that only "Aicke" and "dem Kind" are serialized with respect to each other.

% LP checking is staged:
% 1. lp_rules/3 waits until a reversed category pair is known.
% 2. Its third argument excludes embedded realizations from this domain.
% 3. Only a remaining pair needs the local REALIZED/TRACE check.
%
% The third argument is an exception goal, not another LP declaration.
% It succeeds when the pair is outside the current local domain;
% it fails for a genuine local precedence violation.
%
% Check category relevance before inspecting local domain structure.
% An omitted optional passive PP can have REALIZED plus while its TRACE
% or internal COMPS remains unspecified. The focused tests found no
% underspecified REALIZED flags; the eager check waited on that PP's
% TRACE or internal list structure even without a relevant LP violation.
% The eager scan left one residue for "Den Aufsatz zu lesen beginnt er"
% and ten per analysis for "Dem Mann scheint nicht zu helfen zu sein".
% The staged check removes these residues while preserving the
% fronted-VP exception. These are focused tests, not a suite benchmark.
%
% lp_rules(Left,Right) is equivalent to lp_rules(Left,Right,fail).
spirit_lp_domain_check(Arguments,New) if
 spirit_lp_check(Arguments,New,Arguments).
spirit_lp_check(Arguments,New,Domain) if
 when(Arguments=(e_list;ne_list),spirit_lp_list(Arguments,New,Domain)).
spirit_lp_list([],_,_) if true.
spirit_lp_list([(Old,arg:OldSynsem)|Rest],New,Domain) if
 (lp_rules(New,OldSynsem,spirit_lp_local_pair(New,Old,Domain)),
  spirit_lp_check(Rest,New,Domain)).
spirit_lp_local_pair(New,Old,Domain) if
 spirit_lp_domain_exception(Domain,New,Old).

% A reversed pair is permitted when either element was realized inside
% another argument. Such an excluded pair does not need a TRACE value.
% Complete the exclusion list before testing identity.
spirit_lp_domain_exception(Arguments,New,Old) if
 (spirit_lp_embedded(Arguments,Excluded),
  spirit_lp_domain_ready_tail(Excluded,Excluded,New,Old)).
spirit_lp_embedded(Arguments,Excluded) if
 when(Arguments=(e_list;ne_list),spirit_lp_embedded_list(Arguments,Excluded)).
spirit_lp_embedded_list([],[]) if true.
spirit_lp_embedded_list([arg:loc:cat:comps:Comps|Rest],append(Own,More)) if
 (spirit_lp_realized(Comps,Own),spirit_lp_embedded(Rest,More)).
spirit_lp_realized(Arguments,Realized) if
 when(Arguments=(e_list;ne_list),spirit_lp_realized_list(Arguments,Realized)).
spirit_lp_realized_list([],[]) if true.
spirit_lp_realized_list([(Arg,realized:Flag)|Rest],Result) if
 when(Flag=(plus;minus),spirit_lp_realized_arg(Flag,Arg,Rest,Result)).
spirit_lp_realized_arg(plus,arg:Synsem,Rest,[Synsem|More]) if
 spirit_lp_realized(Rest,More).
spirit_lp_realized_arg(minus,_,Rest,More) if
 spirit_lp_realized(Rest,More).
spirit_lp_domain_ready_tail(Tail,Excluded,New,Old) if
 when(Tail=(e_list;ne_list),
      spirit_lp_domain_ready_list(Tail,Excluded,New,Old)).
spirit_lp_domain_ready_list([],Excluded,New,(Old,arg:OldSynsem)) if
 (spirit_lp_member(New,Excluded) -> true
 ;spirit_lp_member(OldSynsem,Excluded) -> true
 ;when((New=trace:minus,Old=(realized:plus,arg:trace:minus)),fail)).
spirit_lp_domain_ready_list([_|Tail],Excluded,New,Old) if
 spirit_lp_domain_ready_tail(Tail,Excluded,New,Old).

% Structure identity, not unifiability or just identical semantic indices.
spirit_lp_member(_,[]) if fail.
spirit_lp_member(S,[H|T]) if
 (S =@ H -> true ; spirit_lp_member(S,T)).
