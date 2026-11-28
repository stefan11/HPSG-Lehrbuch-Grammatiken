% -*- coding: utf-8; mode: trale-prolog -*-
% Local argument precedence for German, using spirits as the domain.
%

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

:- discontiguous lp_rule/4.


% The budgets for violable constraints for parsing and generation are defined in soft-constraints.pl.

% Surface precedence declarations; every applicable rule must hold.

% NP < dass clause: complements combine to the left of verbs/adjectives.
% Verb-initial heads do not directly combine with NP or dass complements.
% The initial prototype rejected "Glaubt dass der Affe lacht er" (1 -> 0
% analyses, 44 -> 38 passive edges), preserving the NP-first counterpart.
% Input-word-restricted generation of "Er glaubt dass der Affe lacht"
% dropped the one violating output and reduced chart edges from 105 to 94.

% Pronoun < dass-CP (parsing)
lp_rule('Pronoun < dass-CP (parsing)',
        (loc:cat:head:noun,
         weight:((a_ 2);(a_ 3))),
        loc:cat:head:(comp,cform:dass),
        [apply(parsing),penalty(hard)]).

% NP < dass-CP (generation)
lp_rule('NP < dass-CP (generation)',
        loc:cat:head:noun,
        loc:cat:head:(comp,cform:dass),
        [apply(generation),penalty(hard)]).

%
% PP-before-CP test: "Heute wird dass der Affe lacht von dem Mann geglaubt"
% goes from 3 analyses to 0 (83 -> 69 edges); PP-first retains all 3 (89 edges).
%
% Beim Parsing muss es noch gehen:
% Heute wird, dass Affen lachen, von niemandem mehr geglaubt
%
% PP < dass-CP
lp_rule('PP < dass-CP',
        loc:cat:head:prep,
        loc:cat:head:(comp,cform:dass),
        [apply(generation),penalty(hard)]).

% NP[expl] < XP
% * dass zu regnen es beginnt
lp_rule('NP[expl] < XP',
        loc:(cat:head:noun,
             cont:ind:expl),
        loc:cat:head:head,
        [apply(both),penalty(hard)]).

% verletzbare LP-Regeln, Verletzungen werden aufsummiert.

% A positive animacy preference can compensate another LP preference, but
% only for the same two locally realized constituents. Keep the existing
% NP-only penalties above unchanged; this additional rule adds no penalties.
% Example diagnosis (2026-11-21): "wird von dem Kind der Roman geliebt?"
% has NP < PP at 20 and earns 25: this pair contributes 0, discarding 5.
% Its other 55 points remain separate. At NP < PP = 44, the pair would cost 19.
% This validates the balance, not a generation-speed claim.
% Surplus cannot compensate another pair, a soft constraint or a hard rule.

% NP/PP:belebt < NP/PP:unbelebt
% Testen mit Budget 1 und "dass das Buch der Mann kennt"
lp_rule('belebt < unbelebt',
        loc:(cat:head:(noun;prep),
             cont:ind:sort:agentive),
        loc:(cat:head:(noun;prep),
             cont:ind:sort:non_agentive),
        [apply(both),penalty(22),reward(22)]).



% Words of two or three letters precede verbal phrases.
lp_rule('short < VP',
        (%phrase:minus, % Es gibt keine Phrasen aus zwei oder drei Phonemen.
         loc:cat:head:noun,
         weight:((a_ 2);(a_ 3))),
        (phrase:plus,
         loc:cat:head:verb),
        [apply(generation),penalty(hard)]).


% *? Verspricht ihm, den Aufsatz zu lesen, jemand?
% *? Verspricht ihm, den Aufsatz zu lesen, ein Mann?
%
% Die VP-Einbettung bekommt in soft-constraints.pl schon 11 Strafpunkte genau wie Verbalkomplexbildung.
% Variante A (27.11.): abgeschaltet. Die Gym-Bewertungen bevorzugen keine
% NP vor einer kohärent/inkohärent eingebetteten VP; mit 59 Punkten fielen
% z. B. die Testsätze 175/176 ("dass den Aufsatz zu lesen der Mann dem Affen
% versprach") aus dem Budget. Zum Wiedereinschalten: penalty(59).
/*
lp_rule('NP < VP',
        loc:cat:head:noun,
        (phrase:plus,
         loc:cat:head:verb,
         nonloc:slash:e_list),
        [apply(generation),penalty(59)]).
*/

% ?* Den Aufsatz verspricht ihm zu lesen jemand.
lp_rule('NP < VP/XP (freezing)',
        loc:cat:head:noun,
        (phrase:plus,
         loc:cat:head:verb,
         nonloc:slash:ne_list),
        [apply(generation),penalty(90)]).


% Diese Abfolgen gehen prinzipiell, aber man möchte sie nicht generieren.
%
% ?* gestern wurde von ihm er gesehen
%
% * den aufsatz sieht von ihm er gelesen werden müssen
% * den aufsatz sieht von ihm er gelesen zu werden haben
% * den aufsatz sieht von ihm er zu lesen sein
%
% Pron < PP
% Restrict the short member to a nominal category. The particle "an" has
% WEIGHT 2 too and remains a realized spirit inside "angelachte". Counting
% it as a short pronoun rejects "das von jemandem angelachte Kind fetzt".
% Focused diagnosis: the two parsed derivations lose the spurious hard
% violation and have 0 points. "von ihm er angelacht wird" remains excluded.
% No generation-time benchmark is claimed for this category correction.
%
% nicht ganz schlecht:
%
% Angelacht wird von ihm er. 
lp_rule('pronoun < PP',
        (loc:cat:head:noun,
         weight:((a_ 2);(a_ 3))),
        (%phrase:plus,
         loc:cat:head:prep),
%        [apply(both),penalty(hard)]).
        [apply(generation),penalty(15)]). % in addition to the 44 below


% NP < PP 
lp_rule('NP < PP',
        loc:cat:head:noun,
        loc:cat:head:prep,
%        [apply(both),penalty(hard)]).
        [apply(generation),penalty(26)]).



% Claude, 27.11.: Ein Argument des Matrixverbs vor einem angezogenen Objekt des
% eingebetteten Verbs ist die normale Abfolge. In der kohärenten Analyse von
%   von ihm den Aufsatz zu lesen gezwungen wird er
% stehen PP und NP in einer LP-Domäne, in der inkohärenten steckt die NP in der
% VP. Ohne Ausgleich kostete nur die kohärente Lesart 'NP < PP' (26), und das
% Mutter-Packen konnte die beiden Lesarten nicht zusammenlegen (Items 182, 232).
% Die Belohnung gleicht 'NP < PP' für genau dieses Paar aus. Nur für
% eingebettete zu-Infinitive: Bei Passiv- und Perfekthilfsverben gibt es keine
% inkohärente Alternative, dort bleibt 'NP < PP' bestehen.
lp_rule('matrix PP < embedded object',
        loc:cat:head:prep,
        loc:cat:head:noun,
        [roles(domain,
               selected(arg:loc:cat:head:(verb,vform:inf),[arg,loc,cat,comps]),
               [arg]),
         apply(generation),penalty(0),reward(26)]).

% Hier gibt es scrambling von zwei Akkusativen
% Das widerspricht belebt vor unbelebt und NP < Pron und ist einfach nicht mehr verarbeitbar.
%
% Eigentlich bräuchte man eine Regel, die das Scrambling eines eingebetteten Arguments über ein Matrixargument runterstuft.
%
% er sieht den aufsatz ihn lesen müssen
% er sieht den aufsatz ihn zu lesen haben
%
% NP[animate] < NP[inanimate]
lp_rule('NP[acc,animate] < NP[acc,inanimate]',
        loc:(cat:head:(noun,
                       case:morph_case:acc),
             cont:ind:sort:agentive),
        loc:(cat:head:(noun,
                       case:morph_case:acc),
             cont:ind:sort:non_agentive),
        [apply(both),penalty(hard)]).

/*
% nicht kann im Vorfeld stehen. Es ist aber sehr markiert und der Generator soll so etwas wie
%
% * Nicht gibt oft den stock dem affen er.
% * Nicht gibt oft er den stock dem Affen.
%
% nicht generieren.
%
% This is done in soft_constraints.pl
lp_rule(no_negation_before_extraction,
        (loc:cat:head:verb,
         nonloc:slash:ne_list),
        loc:cont:key:nicht_rel,
        apply(both),penalty(hard)]).
*/


% * jetzt beginnt den Aufsatz zu lesen er.
% * Den Aufsatz beginnt zu lesen er.
%
% pronoun < VP[inf]
lp_rule('pronoun < VP[inf]',
        (loc:cat:head:noun,
         weight:((a_ 2);(a_ 3))),
%             cont:ppro),
        loc:cat:head:vform:inf,
%        [apply(both),penalty(hard)]).       % testing
        [apply(generation),penalty(hard)]).


% Prefer an independent matrix argument before an attracted embedded object.
% Control and AcI entries record their fixed NP suffix and attracted prefix
% together on the selected SYNSEM. The two LP members must occur in those
% two lists of ONE such certificate. The test observes SYNSEM identity.
% Raising, perfect and passive auxiliaries do not introduce a certificate.
% In particular, bekommen merely promotes geben's dative argument. The rule
% must not add a second matrix/embedded penalty to an order of geben's NPs.
% The append result and all grammatical sharing remain unchanged. Multiple
% certificates can coexist on a shared VP without identifying their lists.
% Source example: "dass morgen von dem Kind den Stock der Affe gegeben bekommt".
% Focused target-vocabulary generation from the geben sentence restores
% "dass morgen von dem Kind den Stock der Affe gegeben bekommt": total cost
% 6 -> 4 at budget 5; 20 -> 24 outputs. This is a restricted-vocabulary probe.
% Control and AcI probes retain their independent-argument penalties, including
% passive control and deeper embedding. No general speed gain is established.
% Existing local-domain and fronted-VP exceptions remain in force.
%
% NP[nom] < NP[acc] (wenn NP[acc] vom eingebetteten Verb kommt)
lp_rule('NP[nom, matrix] < NP[acc, embedded]', 
        loc:cat:head:(noun,
                      case:(case_type:str,
                            morph_case:nom)),
        loc:cat:head:(noun,
                      case:morph_case:acc),
        [roles(independent,
               selected(arg:loc:cat:head:verb,
                        [arg,loc,cat,comps]),
               [arg]),
         apply(generation), penalty(80)]).


% ?  Lässt den Mann der Affe den Kran reparieren?
% ?* Reparieren lässt den Mann der Affe den Kran.
%
% independent verlangt, dass die erste NP ein eigenes Argument des regierenden Verbs ist. Hier ist
% das „der Affe“ als Subjekt von „lässt“.

% selected(Beschreibung, Pfad) sucht ein selegiertes verbales Argument und prüft, ob die zweite NP
% von dort angehoben wurde. Die Beschreibung findet den Eintrag für „reparieren“. Der Pfad führt von
% diesem Eintrag über ARG.LOC.CAT.HEAD.SUBJ zu seiner Subjektliste. Dort steht „den Mann“. Mit COMPS
% wie in der bestehenden Regel käme man stattdessen zu „den Kran“.

% [arg] sagt, wie man aus den Einträgen der Argumentlisten die verglichenen Objekte bekommt. Jeder
% Eintrag ist ein argument. Unter ARG steht sein SYNSEM, dessen Strukturteilung TRALE für die
% Zuordnung prüft.

lp_rule('NP[nom, matrix] < NP[acc, embedded subject]',
        loc:cat:head:(noun,
                      case:(case_type:str,
                            morph_case:nom)),
        loc:cat:head:(noun,
                      case:morph_case:acc),
        [roles(independent,
               selected(arg:loc:cat:head:verb,
                        [arg,loc,cat,head,subj]),
               [arg]),
         apply(generation),
         penalty(80)]).


% Prefer the embedded subject before its object in an AcI construction.
% Both surface NPs have accusative case, so case alone cannot identify roles.
% The three paths below select SUBJ, COMPS and each argument's SYNSEM inside
% ONE selected verb in the existing domain. SYNSEM identity connects the raised
% arguments to that verb, including deeper raising chains. Semantic index
% identity is insufficient (control and reflexives can share an index).
% The existing local-domain exception still exempts extraction and arguments
% realized inside a fronted VP. Both role lists are observed without unifying
% them or choosing an interpretation. Unknown roles stay pending.
% Trial value 2 is provisional and requires empirical calibration.
% "Er sieht den Mann die Frau anlachen": actor-first reading costs 0;
% the reading with "die Frau" as actor costs 2. Extraction and fronted VP
% probes retain cost 0. Sixteen parse probes preserve all 21 analyses/MRSs.
% Full-vocabulary generation: budget 5 retains 40 outputs and 1164 edges;
% budget 1 retains 36 outputs and 1100 edges, all with zero grammar residues.
% One timing pair at budget 5: 39.428 s -> 47.655 s CPU. This is an added
% preference with measurable overhead, not a demonstrated speed optimization.
%
% NP[acc] < NP[acc] (when first NP[acc] depends on the matrix verb)
lp_rule('NP[acc,matrix] < NP[acc,embedded]',
        loc:cat:head:(noun,
                      case:morph_case:acc),
        loc:cat:head:(noun,
                      case:morph_case:acc),
        [roles([arg,loc,cat,head,subj],[arg,loc,cat,comps],[arg]),
%         apply(both),penalty(hard)]).
         apply(both),penalty(89)]).


% object before subject + embedded object before subject
% dass den affen den aufsatz der mann zu lesen zwingt
%

% dass den aufsatz von dem mann der affe zu lesen gezwungen wird
% dass von dem mann den aufsatz der affe zu lesen gezwungen wird

% den aufsatz zu lesen von ihm versucht wird



% An independent matrix dative precedes the selected verb's object.
% Example: "er verspricht den Aufsatz ihm zu lesen" incurs 11 points.
% Ordinary reordered arguments of geben do not match this origin test.
% The combined corpus fit retains all 219 evaluable positive inputs by score;
% this is not an isolated timing or full regeneration guarantee.
lp_rule('matrix dative < embedded object',
        loc:cat:head:(noun,case:morph_case:dat),
        loc:cat:head:(noun,case:morph_case:acc),
        [roles(independent,
               selected(arg:loc:cat:head:verb,[arg,loc,cat,comps]),
               [arg]),
         apply(generation),penalty(11)]).


% A locally realized 2/3-letter nominative precedes an accusative.
% Example: the late "er" in
% 
% "ihm verspricht den Aufsatz er zu lesen"
%
% Ein Märchen erzählen muss dem Kind er.
%
% incurs 100 points. The existing LP extraction exceptions still apply.
% A single violation equals the generation budget and is therefore allowed;
% another positive cost (eg animate < inanimate) can put the analysis over budget.
lp_rule('short nominative < gen/dat/acc',
        (loc:cat:head:(noun,case:(case_type:str,morph_case:nom)),
         weight:((a_ 2);(a_ 3))),
        loc:cat:head:(noun,case:morph_case:gen_or_dat_or_acc),
        [apply(generation),penalty(84)]).

% Claude, 27.11.: Schwache Pronomen vor vollen NPs (Wackernagel).
% Nur oblique Pronomen; ein spätes Nominativpronomen bestraft schon
% 'short nominative < gen/dat/acc'. Eine volle NP ist eine Phrase oder ein
% Einzelwort mit mindestens vier Zeichen (Aicke, jemand, jemandem).
% Ein Subjekt vor dem Pronomen ist leichter markiert als ein Objekt.
% Gewichte Variante A (27.11.): offline an den Gym-Bewertungen gefittet
% (claude-bench/lpeval.py, lpsearch.py; Rohlauf mit allen Lesarten).
%
%    zu helfen hat ihm der mann        (0)
%  ? zu helfen hat der mann ihm        (Bewertung 33, bisher 0 Punkte)
%  ? zu lesen verspricht jemand ihm den aufsatz (Bewertung 10)
% ?* er zwingt den aufsatz ihn zu lesen
lp_rule('pronoun < NP[nom]',
        (loc:cat:head:(noun,case:morph_case:gen_or_dat_or_acc),
         weight:((a_ 2);(a_ 3))),
        (loc:cat:head:(noun,case:morph_case:nom),
         (phrase:plus;weight:((a_ 4);(a_ 5);(a_ 6);(a_ 7);(a_ 8);(a_ 9);(a_ 10);(a_ 11);(a_ 12)))),
        [apply(generation),penalty(33)]).

lp_rule('pronoun < NP[obl]',
        (loc:cat:head:(noun,case:morph_case:gen_or_dat_or_acc),
         weight:((a_ 2);(a_ 3))),
        (loc:cat:head:(noun,case:morph_case:gen_or_dat_or_acc),
         (phrase:plus;weight:((a_ 4);(a_ 5);(a_ 6);(a_ 7);(a_ 8);(a_ 9);(a_ 10);(a_ 11);(a_ 12)))),
        [apply(generation),penalty(66)]).

% Claude, 27.11.: Pronomen vor Satznegation. "nicht er" geht nur als
% Konstituentennegation.
% ?* oft gibt nicht er den stock dem affen   (bisher 22 Punkte)
lp_rule('pronoun < nicht',
        (loc:cat:head:noun,
         weight:((a_ 2);(a_ 3))),
        loc:cont:key:nicht_rel,
        [domain(adjunct_argument),apply(generation),penalty(44)]).

% Noch nicht umgesetzt: definit < indefinit. Die bewerteten Paare im
% Bewertungsgym stützen das bisher nicht (meist "jemand" als Subjekt, dann
% gewinnt Nominativ zuerst). Dafür bräuchte es Testsätze, die sich nur in der
% Definitheit unterscheiden, z. B.
%   dass ein Kind dem Affen den Stock gibt / dass dem Affen ein Kind den Stock gibt

% Compare locally realized PP and infinitival VP coarguments using the
% existing LP domain and extraction exceptions. Example: the local order
% "den Aufsatz zu lesen von ihm versucht wird" violates this preference.
% The completed-tree corpus fit predicts 108/124 dispreferred orders
% excluded in the combined candidate; this is not yet a generation proof.
lp_rule('PP < VP[inf]',
        loc:cat:head:prep,
        loc:cat:head:(verb,vform:inf),
        [apply(generation),penalty(111)]).



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
% 1. lp_rules/4 waits until a reversed category pair is known.
% 2. Its third argument excludes embedded realizations from this domain.
% 3. Only a remaining pair needs the local REALIZED/TRACE check.
%
% The fourth argument supplies the same domain to role-conditioned rules.
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
% An old spirit with REALIZED minus cannot be a previously serialized
% constituent. Skip it before constructing one observation per LP rule.
% Do not choose an unknown flag: wait for its existing realization decision.
% Example: "Oft gibt er nicht dem Affen den Stock." (reading 1).
% In the 2026-11-20 full-vocabulary trial, combined with native metadata-aware
% agenda packing: 10,476 -> 9,450 edges; all 229 word/score reports preserved;
% CPU 301.577 s -> 242.954 s. This is one complete run pair under variable
% machine load, not an isolated timing result for this grammar change alone.
spirit_lp_list([(Old,realized:Flag)|Rest],New,Domain) if
 (when(Flag=(plus;minus),spirit_lp_realized_pair(Flag,New,Old,Domain)),
  spirit_lp_check(Rest,New,Domain)).
spirit_lp_realized_pair(minus,_,_,_) if true.
% Retire a known omitted argument before creating any LP check. The guard
% below is retained for checks created before lexical omission became known.
spirit_lp_realized_pair(plus,New,Old,Domain) if
 (prolog(spirit_lp_omitted(Old)) -> true
 ;(Old=arg:OldSynsem,
   lp_rules(New,OldSynsem,spirit_lp_local_pair(New,Old,Domain),Domain))).
% Empty/overtly omitted arguments have no position in a surface LP pair.
% Example: "Die Aufsätze gelesen wurden in der Speisekammer." The optional
% von-PP is omitted at its original lexical slot; it has WEIGHT 0, not an
% unknown TRACE value on which an LP comparison should keep waiting.
% Inspect the existing scalar without choosing a value or creating a path.
spirit_lp_local_pair(New,Old,Domain) if
 (prolog(spirit_lp_omitted(Old)) -> true
 ;spirit_lp_domain_exception(Domain,New,Old)).

spirit_lp_omitted(Old) :-
 gen_projection_existing_path([arg,weight],Old,Weight),
 get_type(Weight,Type),
 Type==(a_ 0).

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


% LP rules for local verbal modifiers. The domain selects a set of rules;
% the descriptions in each rule decide which constituents match.
lp_rule('NP[nom] < adjunct PP',
        loc:cat:head:noun,
        loc:cat:head:mod_prep,%cont:key:in_rel,
        [domain(adjunct_argument),apply(generation),penalty(20)]).

% temporal – kausal – modal – lokal
% Example of an adjunct-only preference, left disabled for calibration:
% lp_rule('temporal < locative adjunct',
%          loc:(cat:head:mod:loc:cat:head:adj_or_participle_or_verb,
%               cont:key:temporal_rel),
%          loc:(cat:head:mod:loc:cat:head:adj_or_participle_or_verb,
%               cont:key:locative_rel),
%          [domain(adjunct_adjunct),apply(generation),penalty(20)]).

% German verb-final heads take their complements on the left, and speed.pl
% requires PRE_MODIFIER plus for adjuncts of verbs. The new non-head
% daughter therefore precedes the entire head projection in both cases.
% In V2, the verb-final projection headed by the verb trace contains the
% relevant pairs. The initial verb takes that projection as its complement.
% Follow HEAD_DTR only through local complement and adjunct phrases.
head_complement_phrase *>
 (head_dtr:H, non_head_dtrs:[D]) goal adjunct_lp_argument(H,D).

head_adjunct_phrase *>
 (head_dtr:H, non_head_dtrs:[D]) goal adjunct_lp_modifier(H,D).

adjunct_lp_argument(H,D) if
 when((H=synsem:loc:cat:head:(verb,initial:minus),D=phon:ne_list),
      adjunct_lp_start(H,D,(a_ argument))).

adjunct_lp_modifier(H,D) if
 when((H=synsem:loc:cat:head:(verb,initial:minus),D=phon:ne_list),
      adjunct_lp_start(H,D,(a_ adjunct))).

adjunct_lp_start(H,synsem:New,Kind) if adjunct_lp_walk(H,New,Kind).

adjunct_lp_walk(H,New,Kind) if
 (when(H=head_complement_phrase,adjunct_lp_step(H,New,Kind,(a_ argument))),
  when(H=head_adjunct_phrase,adjunct_lp_step(H,New,Kind,(a_ adjunct)))).

adjunct_lp_step((head_dtr:H,non_head_dtrs:[D]),New,Kind,OtherKind) if
 (adjunct_lp_compare(Kind,OtherKind,D,New),
  adjunct_lp_walk(H,New,Kind)).

% Complement pairs already belong to the existing COMPS-based domain.
adjunct_lp_compare((a_ argument),(a_ argument),_,_) if true.
adjunct_lp_compare((a_ argument),(a_ adjunct),D,New) if
 adjunct_lp_overt(D,New,(a_ adjunct_argument)).
adjunct_lp_compare((a_ adjunct),(a_ argument),D,New) if
 adjunct_lp_overt(D,New,(a_ adjunct_argument)).
adjunct_lp_compare((a_ adjunct),(a_ adjunct),D,New) if
 adjunct_lp_overt(D,New,(a_ adjunct_adjunct)).

adjunct_lp_overt(D,New,Domain) if
 when(D=phon:ne_list,adjunct_lp_pair(D,New,Domain)).

adjunct_lp_pair(synsem:Old,New,(a_ adjunct_argument)) if
 lp_rules(New,Old,fail,domain(adjunct_argument,[])).
adjunct_lp_pair(synsem:Old,New,(a_ adjunct_adjunct)) if
 lp_rules(New,Old,fail,domain(adjunct_adjunct,[])).
