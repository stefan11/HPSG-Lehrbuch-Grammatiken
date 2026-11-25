% -*- coding: utf-8; mode: trale-prolog -*-
% Shared budgets for weighted LP rules and structural preferences.
% Finite costs are rounded percentages of the previous generation budget45.
% Example: a verbal-cluster step changes5->11, the old PVP cost40->89,
% and its multiword surcharge10->22; the latter combination is still above
% the generation budget (111>100). Parsing450 still admits five violations
% of the current 89-point parsing preferences (445), but rejects six(534).
% This rescaling changes no budget decision for ANY combination of the
% current declared costs: each old allowed generation sum<=45 becomes<=100;
% every old rejected sum is>=50 and becomes>=110. Hard penalties are unchanged.
% The guarantee concerns the current declarations; retuning weights requires
% a fresh check. No new runtime or speed improvement is claimed by rescaling.

:- dynamic soft_constraint/3, soft_constraint/4, soft_constraints_budget/2.
:- multifile soft_constraint/3, soft_constraint/4, soft_constraints_budget/2.
:- discontiguous soft_constraint/3, soft_constraint/4.

% soft_constraint(Name,Configuration,Options) penalizes the configuration.
% soft_constraint(Name,Antecedent,Requirement,Options) penalizes a violated implication.
% Options for both forms:
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

soft_constraints_budget(parsing,450).
soft_constraints_budget(generation,100).

% constraint_debug(on).
% Das zeigt verletzte bzw. noch unbestimmte Constraints, Strafpunkte und frühe Abbrüche.
%
% Für alle abschließenden Bewertungen, auch ohne Verletzungen:
% constraint_debug(all).
%
% constraint_debug(off).
%
% Satz gezielt nach den Generierungsbeschränkungen prüfen, ohne am Budget abzubrechen:
% constraint_diagnose("ein Satz").
%
% Im go-Modus: diagnose. / nodiagnose.
%
% Beschränkungen neu laden:
%
% constraint_reload. 
% 

% Extraction through dass stays available for parsing. Generation charges
% 44 points per violation; several preferences can accumulate beyond the
% generation budget of 100. One such violation alone is still permitted.
% "Er glaubt dass Aicke lacht" incurs no extraction penalty.
% Earlier, differently weighted five-word trial
% (glaubt,dass,aicke,lacht,er): the same
% three accepted outputs, 70 instead of 93 edges with early budget pruning.
% Existing grammar filters enabled; no full-suite timing claim.
%
% Like an implication A *> B but configurable to apply for parsing and/or generation and combined with a penalty.
%
% * Ein Einhorn glaubt jeder Affe, dass schläft.
%
soft_constraint('dass-CP-Insel',
    (complementizer_word,
     synsem:loc:cat:head:cform:dass),
    synsem:loc:cat:arg_st:hd:arg:nonloc:slash:e_list,
    [apply(generation),penalty(hard)]).

%
% dass-Sätze bei besetzter rechter Satzklammer sind schlecht.
%
% Manche Autor*innen gehen sogar so weit zu behaupten, dass sie ausgeschlossen wären.
% Das ist falsch.
%
%   Aicke glaubt, dass das Einhorn schläft.
% ? Aicke hat, dass das Einhorn schläft, geglaubt.
%
% Aber Strafen sollte es dennoch geben:
soft_constraint('dass im Mittelfeld',
    (head_complement_phrase,
     non_head_dtrs:hd:synsem:(loc:cat:head:cform:dass,
                              trace:minus),
     head_dtr:phon:ne_list),
%    [apply(both),penalty(hard)]).
    [apply(generation),penalty(60)]).


% Es gibt Belege für Partikelvoranstellung, aber diese Stellung ist meist markiert.
%
% particle_verb ist ein Obertyp für Partikelverben im Lexikon und solche, die über LRs erzeugt werden.
%
% Vor hat er sie geschlagen.
% 
% An hat er sie gelacht.
soft_constraint('* Part V1',
    particle_verb,
    synsem:loc:cat:arg_st:hd:arg:nonloc:slash:e_list,
    [apply(generation),penalty(hard)]).

% Das Buch hilft mir.
% * Ich bekomme von dem Buch geholfen.
% Penalize bare "nicht" in the prefield.
% Example: "Nicht gibt er dem Affen den Stock."
soft_constraint('* nicht V1',
    (head_filler_phrase,
     non_head_dtrs:hd:
       (word,
        synsem:loc:cont:key:nicht_rel)),
    [apply(generation),penalty(267)]).


% Ein Lied gesungen wurde.
% soft_constraint(vp_fronting_with_empty_mittelfeld,
%      (synsem:v2:plus,
%       non_head_dtrs:hd:synsem:loc:cat:head:verb, % (partial) VP
%       head_dtr:(synsem:v2:minus,
%                 non_head_dtrs:hd:phon:e_list)),
%       [apply(both),penalty(hard)]).              % for testing
%    [apply(generation),penalty(120)]).


% Ein Lied gesungen wurde.
soft_constraint('* (P)VP V1 _',
     (head_filler_phrase,
      non_head_dtrs:hd:synsem:loc:cat:head:verb, % (partial) VP
      head_dtr:phon:tl:e_list),                  % head-dtr has just one element in PHON = the finite verb
%      [apply(both),penalty(hard)]).              % for testing
     [apply(generation),penalty(89)]).


% Belebte Argumente einstelliger Verben können via von-PP angegeben werden:
%
%   Auf der Party tanzten viele Gäste
%   Auf der Party wurde (von vielen Gästen) getanzt
%   Vor dem Fenster tanzten Schneeflocken
% * Vor dem Fenster wurde (von Schneeflocken) getanzt
%
/*
soft_constraint(agent_pp_with_one_place_verb,
    (ppp_verb_infl_lr,
     synsem:loc:cat:arg_st:
       [(realized:minus,
         arg:loc:cat:head:pform:von_pform)]),
    [apply(generation),penalty(89)]).
*/
 
%
% * dass von den Schneeflocken getanzt wurde.
%
soft_constraint('von-PP[HUMAN-] ARG-ST [NP]', %inanimate_agent_pp_with_one_place_verb,
    (ppp_verb_infl_lr,
     synsem:loc:cat:arg_st:
       [(realized:minus,
         arg:loc:(cat:head:pform:von_pform,
                  cont:ind:sort:non_agentive))]),
%     [apply(both),penalty(hard)]).
    [apply(generation),penalty(hard)]).

% Wird von Aicke geschlafen?
% ?? Von Aicke geschlafen wird.
soft_constraint('von-PP[HUMAN+] ARG-ST [NP] ppp', %inanimate_agent_pp_with_one_place_verb,
    (ppp_verb_infl_lr,
     synsem:loc:cat:arg_st:
       [(realized:minus,
         arg:loc:(cat:head:pform:von_pform,
                  cont:ind:sort:agentive))]),
%     [apply(both),penalty(hard)]).
    [apply(generation),penalty(89)]).

soft_constraint('von-PP[HUMAN+] ARG-ST [NP] inf', 
    (inf_verb_infl_lr,
     synsem:loc:cat:arg_st:
       [(realized:minus,
         arg:loc:(cat:head:pform:von_pform,
                  cont:ind:sort:agentive))]),
%     [apply(both),penalty(hard)]).
    [apply(generation),penalty(89)]).


% Wird das Buch von Aicke gelesen?
% ?* Von Aicke das Buch gelesen wird.
soft_constraint('von-PP ARG-ST [NP|_] ppp', 
    (ppp_verb_infl_lr,
     synsem:loc:cat:arg_st:((hd:(realized:minus,
                                 arg:loc:cat:head:pform:von_pform),
                             tl:ne_list);
                             % Versucht wird von ihm den Aufsatz zu lesen.
                             tl:hd:(realized:minus,
                                    arg:loc:cat:head:pform:von_pform);
                             tl:(hd:(realized:minus,
                                     arg:loc:cat:head:pform:von_pform),
                                 tl:ne_list))),
%     [apply(both),penalty(hard)]).
    [apply(generation),penalty(44)]).

% Leider kann die von-PP auch hinter dem eingebetteten Verb stehen
% er von ihm zu lesen gezwungen wird
soft_constraint('von-PP ARG-ST [NP|_] inf', 
    (inf_verb_infl_lr,
     synsem:loc:cat:arg_st:((hd:(realized:minus,
                                 arg:loc:cat:head:pform:von_pform),
                             tl:ne_list);
                             tl:(hd:(realized:minus,
                                     arg:loc:cat:head:pform:von_pform),
                                 tl:ne_list))),
%     [apply(both),penalty(hard)]).
    [apply(generation),penalty(44)]).



% Charge 11 points for each nonempty head-cluster phrase. For example,
% "er wird den Aufsatz lesen dürfen" accumulates two such steps (22).
% This small cost is cumulative: the corpus contains good as well as bad
% examples with two steps, so the factor alone must not reject them.
soft_constraint('nonempty verbal-cluster step',
    (head_cluster_phrase,
     phon:ne_list),
    [apply(generation),penalty(11)]).


% Add 22 points to the existing 89-point VP-prefield preference when
% the filler has at least two words and the remaining head has one token.
% Example: "der Kran repariert wird sein" incurs this additional cost;
% one-word "Gelacht wird" does not. The updated positive Speisekammer
% examples have further material in the head phrase and do not match.
soft_constraint('multiword PVP with empty remainder',
    (head_filler_phrase,
     non_head_dtrs:hd:(phon:tl:ne_list,
                       synsem:loc:cat:head:verb),
     head_dtr:phon:tl:e_list),
    [apply(generation),penalty(22)]).


% Penalize the explicit lexical PP "von jemandem" by 67 points.
% This is a narrow approximation of the corpus judgments, not a general
% theory of indefiniteness. For example "von jemandem gearbeitet wird"
% incurs this cost in addition to the existing unary-verb passive cost.
% Implicit agents and "von Aicke" do not match this configuration.
soft_constraint('non-specific von jemandem PP',
    (head_complement_phrase,
     non_head_dtrs:hd:(phon:[a_ von,a_ jemandem],
                      synsem:loc:cat:head:(prep,pform:von_pform))),
    [apply(generation),penalty(67)]).


% Charge 44 points when an AcI governor selects a base-form auxiliary.
% Example: "zu lesen sieht ihn den Aufsatz er haben" contains such an
% embedding. This includes perfect auxiliaries as well as passive werden;
% a plain lexical infinitive and lassen_passive as governor do not match.
soft_constraint('AcI embedding an auxiliary',
    (aci_verb,
     synsem:loc:cat:arg_st:hd:arg:loc:cat:head:(vform:bse,aux:plus)),
    [apply(generation),penalty(44)]).
