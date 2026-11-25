% -*- coding: utf-8; mode: trale-prolog -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   $RCSfile: speed.pl,v $
%%  $Revision: 1.11 $
%%      $Date: 2006/02/26 18:08:12 $
%%     Author: Stefan Mueller (Stefan.Mueller@cl.uni-bremen.de)
%%    Purpose: Linguistisch nicht signifikante Hacks
%%             zur Effizienzsteigerung/Terminierung
%%             beim Bottom-Up-Parsen
%%             bzw. bei der Semantic-Head-Driven-Generation
%%   Language: Trale
%%     System: TRALE 2.3.7 under Sicstus 3.9.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



:- multifile ':='/2.
:- discontiguous ':='/2.
:- multifile '*>'/2.
:- discontiguous '*>'/2.
:- multifile if/2.
:- discontiguous if/2.
:- multifile fun/1.
:- discontiguous fun/1.

:- multifile macro/2.
:- discontiguous macro/2.

% Die folgenden Regeln schließen die Erzeugung von Phrasenstrukturregeln aus,
% die in der Grammatik nicht gebraucht werden.

head_filler_phrase *>
   (%synsem:v2:plus, steht schon in syntax.pl
    non_head_dtrs:[phon:ne_list]).  % keine Spuren (TRACE-) bzw. leere Elemente (Determinator).
                                    % Evtl. bei Vorfeldellipse ändern.

%head_filler_phrase *> loc:cat:head:dsl:none.
   
% scheint nicht zu funktionieren
%head_filler_phrase *>
%   head_dtr:phon:ne_list.  % keine Spuren (TRACE-) bzw. leere Elemente (Determinator).

% head_filler_phrase *> dtrs:[phon:ne_list,phon:ne_list].

% Phrasen sind natürlich nie Spuren.
phrase *> synsem:trace:minus.


(head_adjunct_phrase,
 non_head_dtrs:[synsem:trace:extraction]) *> head_dtr:synsem:lex:plus. % to avoid spurious ambiguities



% Bedingung, die in rules.pl für kopffinale Regel verwendet wird.
argument_synsem :=
 (loc:cat:(head:(% Linguistisch ist es nicht notwendig, aber TRALE rechnet
                 % die leeren Elemente aus und hängt sich dabei auf, wenn
                 % man nicht Spuren per Hand ausschließt.
                        dsl:none,
                 
                        mod:none, % keine Adjunkte: Adjektive ^ Adverbien
                        spec:none % keine Determinierer
                       ),
                  spr:list_of_spirits)).
                  %comps:list_of_spirits  % Das ist nicht nur eine speed-Beschränkung. Steht jetzt in syntax.pl
                                     % Diese Beschränkung sorgt dafür, dass inkohärente Konstruktionen wirklich
                                     % eine Maximalprojektion verlangen.

% Das könnte man auch wie folgt als Implikation definieren:
%
/*

% ohne diese Bedingung könnten Projektionen der Verbspur
% mit einer weiteren Verbspur kombiniert werden:
% [ [ er _ ] _ ]
(head_complement_phrase,
 synsem:loc:cat:head:initial:minus) *>
  (non_head_dtrs:[synsem:loc:cat:head:dsl:none]).

*/

% Hey, Negation!

%% Type negation - delay until type T and then die.
not(Type) macro not_type(a_ Type).
fun not_type(+,-).
% Compile one worker, not one clause per signature type. For example,
% @not(noun) still waits while its argument could become a noun, fails as
% soon as it is a noun, and retires when the known type excludes noun.
% Type is the atomic type name supplied to the macro, not a feature structure.
% when_type/3 is TRALE's existing runtime primitive for this delayed test.
% bot is excluded immediately because every feature structure is of type bot.
% type/1 also preserves enumeration if the prohibited type is not yet known.
%
% Native check with 1000 fixed noun/verb tests: 957000 -> 0 backtracking
% redos in fs_not_type/2; both versions have exactly 1000 successes.
% 3411 refinement/enumeration observations and 15 complete parser cases agree.
% Current regular-vocabulary control "Von ihm wurde zu lachen versucht.":
% two alternating pairs keep 12 outputs (10 distinct), 878 edges and zero
% residues: 27.251 / 28.306 s CPU before, 25.652 / 25.277 s after.
% "Ein Affe nimmt einen Stock und das Kind lacht." keeps 42 outputs,
% 1687 edges and zero residues, but its single current pair is slower:
% 82.422 -> 86.520 s CPU. These timings do not show a uniform improvement.
% A later balanced baseline/candidate/candidate/baseline control keeps the
% same 42 outputs, scores, 1687 edges and zero residues: baseline CPU
% 77.724 / 77.444 s, candidate 77.162 / 76.943 s (about 0.7% mean gain).
% GC times remain 8.235 / 8.246 s versus 8.235 / 8.129 s. This small repeat
% does not establish a uniform speedup; the earlier slower pair is retained.
% Current item 230 still times out after 1200000 ms at 1393 inactive edges.
% No remaining timeout has been solved by this change.
%
% Previous metarule, retained for reference:
% ( not_type((a_ Type),FS) if
%       when(FS=Type,prolog(fail)) ) :- type(Type).
not_type((a_ Type),FS) if
  prolog(delayed_type_negation(Type,FS)).

delayed_type_negation(Type,FS) :-
  type(Type),
  ( Type == bot ->
      fail
  ; when_type(Type,FS,fail)
  ).


% Folgendes schließt finite Verben als Argumente (der Verbspur) ganz aus, da
% sie in diesem Fragment nicht vorkommen.
(head_complement_phrase,
 synsem:loc:cat:head:initial:minus,
 non_head_dtrs:[synsem:loc:cat:head:verb]) *> non_head_dtrs:[synsem:loc:cat:head:vform:inf].



% ebenfalls linguistisch nicht notwendig, verringert
% aber die Menge der von TRALE berechneten Regeln.

% ohne diese Bedingung könnte die Verbspur beliebig oft
% als Adjunkt auftreten.

head_adjunct_phrase *>
  non_head_dtrs:hd:synsem:loc:cat:head:dsl:none.

% allgemeiner
%head_non_complement_phrase *>
%  (non_head_dtrs:[loc:cat:head:dsl:none]).






% Die folgende Beschränkung erlaubt Extraktion nur,
% wenn der Kopf ein Verb in Letztstellung ist.
% Damit wird gleichzeitig die Modifikation des "bewegten" Verbs
% durch eine Spur ausgeschlossen.

% Extraktion aus NPen ist ebenfalls ausgeschlossen, was empirisch nicht korrekt ist.

(head_adjunct_phrase,
 non_head_dtrs:[synsem:trace:extraction]) *> synsem:loc:cat:head:(verb,
                                                                  initial:minus).

% Wahrscheinlich kann Verbspur mit Extraktionsspur kombiniert werden, diese wird dann mit
% extrahiertem Adverb kombiniert. Das sollte nicht gehen, weil es eine Restriktion in der Anzahl der
% Elemente auf 1 für SLASH gibt. Diese wird aber nur angewendet, wenn sie in der richtigen
% Reihenfolge wie in syntax.pl angegeben verwendet wird.
%
%(head_adjunct_phrase,
% non_head_dtrs:[trace:extraction]) *> nonloc:slash:[].



% Das steht auch im Lexikon bei den Verbmodifikatoren, aber man braucht es hier,
% um sinnlose Spuren auszuschließen.

% [ daß er schläft _ ]

% Außerdem wird das leere Verb bei Initialstellung als Kopf ausgeschlossen.
% Das ist wichtig für die Regelberechnung.

(head_adjunct_phrase,
 head_dtr:synsem:loc:cat:head:verb) *> non_head_dtrs:hd:synsem:loc:cat:head:pre_modifier:plus.

% Adjunkte werden immer als direkte Töchter des Verbs eingeführt,
% da sonst unechte Mehrdeutigkeiten entstünden.
(head_adjunct_phrase,
 non_head_dtrs:[synsem:trace:extraction]) *> head_dtr:synsem:lex:plus.


% Achtung: Oft gibt er nicht dem Mann das Buch.

% er lacht oft.
% ist sonst mehrdeutig.

% * [ oft [ _ _ ]]
%   [ _   [ oft _ ]]

(head_adjunct_phrase,
 head_dtr:head_complement_phrase) *> head_dtr:non_head_dtrs:hd:synsem:trace:minus.




% Entweder in rules.pl spr_h nur für nomina und Determinatoren spezifizieren, oder hier sagen, dass
% Verbspuren keinen Specifier haben. Das kommt sonst erst, wenn das Verb in Initialstellung mit dem
% Rest kombiniert wird. Das bedeutet, dass beliebig viele Elemente mit der Verbspur als Spezifikator
% kombiniert werden könnten.
(phon:[],
 synsem:loc:cat:head:verb) *> synsem:loc:cat:spr:list_of_spirits.


head_specifier_phrase *>
             dtrs:[synsem:(loc:cat:head:det,   % speed + Regelberechnung
                           trace:minus),       % speed: steht eigentlich im Lexikon
                   synsem:loc:cat:head:noun].  % speed + Regelberechnung


% Relativsätze

% Information über Relativpronomina kann nur aus der vorangestellten Relativphrase kommen.
% Die Relativphrase kann aber nur aus dem Relativpronomen selbst oder aus einer PP bestehen.

head_adjunct_phrase *>
  non_head_dtrs:hd:synsem:nonloc:rel:[].

% Das stimmt nicht für zu-Infinitive wie in
% das Buch, das zu lesen ich ihm empfohlen habe
% Deshalb wird diese Beschränkung später revidiert.
(headed_phrase,
 synsem:loc:cat:head:verb) *> synsem:nonloc:rel:[].


% Für Sätze wie "Lachen muß er." braucht man am Satzende
% eine Kombination der Verbspur mit einer Extraktionsspur.
% Die COMPS-Liste der entstehenden Projektion ist unbestimmt,
% so dass dieser Komplex dann mit allem Material, das es
% im Satz gibt, kombiniert werden kann.
% Erst wenn der Füller gefunden wird, stellt sich heraus,
% dass diese Kombinationen sinnlos waren.
% Wir sind schlauer und sagen schon jetzt Bescheid:

fun list_of_arguments(-).
list_of_arguments(L) if
   when( (L=(e_list;ne_list)),
         undelayed_list_of_arguments(L) ).

undelayed_list_of_arguments([]) if true.
undelayed_list_of_arguments([realized:plus|T]) if
   list_of_arguments(T).
undelayed_list_of_arguments([(realized:minus,
                              arg: (@argument_synsem,
                                    @non_complex_forming_synsem
                                   ))|T]) if
   list_of_arguments(T).

% Da der V-Kopf noch als Geist da ist, wird nur etwas über den Rest der
% Liste gesagt.
head_cluster_phrase *> synsem:loc:cat:comps:list_of_arguments. % Extraktionsspur + Verbspur -> danach weitere Cluster


% er ihm müssen mit verbleibendem Verb-Komplement auf der Valenzliste
(head_complement_phrase,
 synsem:loc:cat:head:initial:minus) *> synsem:loc:cat:comps:list_of_non_complex_forming_arguments.



% Ansonsten würde `er lachen' als Verbalkomplexbestandteil mit einer
% Verbspur kombinierbar sein.
(head_cluster_phrase,
 synsem:loc:cat:head:initial:minus) *> non_head_dtrs:hd:synsem:lex:plus.



% Der folgende Satz ist der einzige Satztyp, für den man eine geflippte Verbspur braucht.
% Das Lied wird er [ _ [haben singen wollen]].
%
% * Das Lied wird er [ _ singen wollen].
%   Das Lied wird er [ singen wollen _].

% Verhindert unechte Mehrdeutigkeiten und:

% er wird lachen dürfen wollen.
% ==> 18 min 37.340 sec CPU time.        2 solutions; 1033 passive edges; residues: 0,0
%
% ==>  8 min 45.000 sec CPU time.        1 solutions; 583 passive edges; residues: 0


(head_cluster_phrase,
 synsem:loc:cat:head:dsl:local,
 non_head_dtrs:[synsem:loc:cat:head:flip:plus]) *> non_head_dtrs:hd:phon:hd: (a_ haben).

% Wenn die Nicht-Kopftochter eine Extraktionsspur ist und von der Kategorie Verb, dann muss sie
% FLIP- sein und also vor dem regierenden Verb stehen.
% Das schließt zweite Lesart bei folgendem Satz aus:
%
% Das Buch lesen müssen glaube ich dass er wird.
%
% 233 -> 177 Kanten
%
% Leider geht das nur, wenn FLIP zwei Möglichkeiten hat, also Oberfeldumstellung optional ist. Denn
% ansonsten wird der folgende Satz ausgeschlossen, denn da ist Oberfeldumstellung obligatorisch.
%
% dass er wird haben schlafen wollen
% [Schlafen wollen]_i wird_j er [_j haben _i] 
/*
(head_cluster_phrase,
 non_head_dtrs:[synsem:(nonloc:slash:hd:loc:cat:head:verb;
                        trace:extraction)]) *> non_head_dtrs:hd:synsem:loc:cat:head:flip:minus.
*/
(head_cluster_phrase,
 dtrs:tl:hd:synsem:(nonloc:slash:hd:loc:cat:head:verb;
                    trace:extraction)) *> dtrs:hd:phon:hd: (a_ haben).



% Terminierung: Der Regelberechnung.
% Die Nicht-Kopftochter in Kopf-Cluster-Strukturen kann nur einen
% gefüllten DSL-Wert haben, wenn die Verbspur auch extrahiert wird.
(head_cluster_phrase,
 non_head_dtrs:[ synsem:loc:cat:head:dsl:local]) *> non_head_dtrs:hd:synsem:trace:extraction.


% Das schließt das finite Verb als cluster daughter aus.
% Diese Implikation schließt auch Partikel und Adjektive aus, ist also zu stark.
% Die Einschränkung auf gefüllte PHON läßt Verbspuren für die mehrfache Vorfeldbesetzung zu.
(head_cluster_phrase
% ,phon:ne_list  % funktioniert nicht. TRALE-Bug??
, non_head_dtrs:[synsem:loc:cat:head:(verb,
                                      dsl:none)] 
)         *> non_head_dtrs:hd:synsem:loc:cat:head:vform:non_fin.

/*
Das stand im alten Kapitel 18 statt dem oben.

% Das finite Verb darf nur als Spur innerhalb des Verbalkomplexes stehen:
% [Zum zweiten Mal die Weiltmeisterschaft]_i errang_j Clarc 1965 _i _j.
(head_cluster_phrase,
 non_head_dtrs:hd:synsem:loc:cat:head:vform:fin) *> non_head_dtrs:hd:synsem:loc:cat:head:dsl:local.
*/



optionally_coherent_le *>
  synsem:loc:cat:head:optionally_coherent:plus.

% auxiliaries and modals in German, but also the multiple fronting LR.
coherent_le *>
  synsem:loc:cat:head:optionally_coherent:minus.

% for instance the verb initial LR in German.
% incoherent_le *>
%  @incoherent_le.

% called in macros for intransitive and transitive verbs as well
%incoherent_le :=
%  synsem:loc:cat:head:optionally_coherent:minus.

non_fin_verb_infl_lr *>
( synsem:loc:cat:head:optionally_coherent:OC,
  dtr:synsem:loc:cat:head:optionally_coherent:OC).



% If the head is optionally coherent and it is combined with the most oblique argument,
% then the head_dtr should be a phrase.
% As a consequence of this constraint the VP or AP is intraposed.
% St. Mü. 27.07.2009
% This does not hold true of NPs and PPs. They never enter the predicate complex.
% They always have to be phrases, even if adjacent to an optionally coherent verb.
% St. Mü. 30.07.2009
%
Synsem^(head_complement_phrase,
  head_dtr:synsem:loc:cat:(head:optionally_coherent:plus,   
                           comps:hd:arg:Synsem),
  non_head_dtrs:hd:synsem:(Synsem,
                           loc:cat:head:adj_or_participle_or_verb)) *> head_dtr:phrase.
                                                                       %    non_head_dtrs:hd:synsem:trace:minus).

% They have to be phrases and even head_non_cluster_phrases, since otherwise we could get:
%
% Er bekommt [den Aufsatz zu lesen] [cl_h versprochen _]
%
% Muss zugelassen werden:
%
% Dass [den Kran zu reparieren] versucht wurde.
%
% Das geht nur adjazent als inkohärente Konstruktion. Kohärent wäre es "der Kran".
%
% dass der Kran [[zu reparieren versucht] wurde]
%
%
% Ausschließen:
% [_ von ihm zu lesen] [gezwungen werdendem] mit PP und NP[str] in ARG-ST
%
% Geht alles nicht, denn auch "Er bekommt den Aufsatz zu lesen versprochen" ist ja Passiv.
%
% Wenn die angehobenen Argumente noch ein Subjekt davor haben, dann ist das Objekt im Akkusativ und man
% kann die inkohärente Analyse ausschließen.
%
% Versagt bei dass ihm der Kran/den Kran zu reparieren erlaubt wurde, weil erlauben noch Dativ hat.
%
% Von ihm wurde zu lachen versucht.
%
% Benchmark: je eine Lesart
% Von ihm wurde zu lachen versucht       
% Versucht wird von ihm ihn anzulachen.  
% dem von ihm den Aufsatz zu lesen gezwungen werdenden Mann 
% dass der Kran zu reparieren versucht wurde
% dass den Kran zu reparieren versucht wurde
% hat jemand den kran zu reparieren versucht
% jemand hat den kran zu reparieren versucht
% den kran hat jemand zu reparieren versucht
% den kran wurde zu reparieren versucht
%
Synsem^(head_complement_phrase,
  head_dtr:(non_head_dtrs:hd:synsem:loc:cat:head:optionally_coherent:plus,   % versprochen
            synsem:loc:cat:comps:tl:(hd:arg:Synsem, % versucht bekommt Synsem ist "zu lesen" 
                                    (              %tl:[(arg:loc:cat:head:prep,
                                          %raised:minus, hilft nicht. „Versucht wird von ihm ihn anzulachen.“ Wird hier ausgeschlossen.
                                          % genauso dass von dem Mann den Aufsatz zu lesen versucht wurde
                                     %     realized:minus)];                 % Von ihm wurde zu lachen versucht.
                                     tl:tl:ne_list))),                       % Der Verbalkomplex der kohärenten Konstruktion hat einen Nominativ.
                                                                            % Damit wäre ein aus einer VP angezogenes Objekt an zweiter Stelle und
                                                                            % müsste auch in der kohärenten Konstruktion Akkusativ werden.
                                                                            % Also kann die inkohärente Konstruktion ausgeschlossen werden.
                                                                            % [V[ppp],V[inf],PP[von],NP]
  non_head_dtrs:hd:synsem:(Synsem,
                           loc:cat:head:adj_or_participle_or_verb)) *> (head_dtr:head_non_cluster_phrase,
                                                                           non_head_dtrs:hd:synsem:trace:minus).

% pränominale Adjektive sind Extraktionsinseln
% Das wird eigentlich über ein Constraint auf der ARG-ST-Liste der Adjektive geregelt, aber bei
%
% [_ von ihm zu lesen] [gezwungen werdendem] mit PP und NP[str] in ARG-ST
%
% ist die Liste offen.
(head_complement_phrase,
 synsem:loc:cat:head:attr_adj_or_attr_participle) *> non_head_dtrs:hd:synsem:nonloc:slash:e_list.
 


% If we are combining an optionally coherent verb with an argument via the head-complement-phrase,
% we want to be sure that it is a proper argument. Since the append of the ARG-ST is delayed till
% the VP argument is found, all kinds of phrases may be combined with the head. Any number and any
% kind of phrase. For example, NPs in the genitive. This is especially bad for the generator.
% Parsing:
%
% dass den roman zu lesen der mann versucht
%
% ==> 2.146 sec CPU time.        1 solutions; 139 passive edges; residues: 0
% ==> 1.425 sec CPU time.        1 solutions;  82 passive edges; residues: 0
 

% Durch generator_valence_wait ersetzt; historische Fassung fuer Vergleiche.
/*
(head_complement_phrase,
 synsem:loc:cat:(head:optionally_coherent:plus,
                 comps:hd:realized:minus)) *>
    synsem:loc:cat:comps:hd:arg:loc:cat:attracted_comps_:e_list.
*/

% Die angehobene VP kann auch an zweiter Stelle stehen, wenn ein Verbalkomplex gebildet wurde:
%
% Das den Roman zu lesen den Mann zu zwingen versprechende Kind lacht.
%
% funktioniert nicht, weil das optional kohärent konstruierende Verb eingebettet sein kann.
%
% bekommender ist obligatorisch kohärent, aber versprochen ist optional.
%
% von ihm das von ihm versprochen bekommender
%
% Das werden teilweise mehr Kanten.
% Die Kopftochter ist hier bereits ein Komplex. Seine Nicht-Kopftochter
% kann noch eine VP verlangen, obwohl der obere Kopf obligatorisch kohärent ist.
% Nur für diese Kopf-Cluster-Struktur wird die folgende Bedingung geprüft.
% Historische Hilfsbeschraenkung; die Valenzvorschau arbeitet ohne sie.
/*
(head_cluster_phrase,
 non_head_dtrs:hd:synsem:loc:cat:(head:optionally_coherent:plus,
                                  comps:hd:realized:minus)) *>
 non_head_dtrs:hd:synsem:loc:cat:comps:hd:arg:loc:cat:attracted_comps_:e_list.
*/



% Wiederholt Beschränkungen aus le_macros.pl, damit es dort übersichtlich beleibt.

% attracted_comps_ wird fuer den Live-Versuch nicht mehr verwendet.
/*
np_v_subj_zu_inf_control_verb *>
  (%zu_inf_subj_control_verb,
   synsem:loc:cat:arg_st:[arg:loc:cat:(attracted_comps_:AC,
                                       comps:Comps)|append((AC,
                                                            attract_unrealized(Comps)),[_])]).


np_np_v_subj_zu_inf_control_verb *>
  (%zu_inf_control_verb,
   synsem:loc:cat:arg_st:[arg:loc:cat:(attracted_comps_:AC,
                                       comps:Comps)|append((AC,
                                                            attract_unrealized(Comps)),[_,_])]).

% phase verb

subj_raising_verb *>
 (%raising_verb,
  synsem:loc:cat:arg_st:[arg:loc:cat:(head:subj:(Subj,
                                                 list_of_raised_arguments), % löschen?
                                      attracted_comps_:AC,
                                      comps:Comps)
                        |(AC,
                          raise(append_known_prefix(Comps,Subj)))]).

*/

% If a non-head-dtr in a verbal complex 
%(head_cluster_phrase,
% non_head_dtr:synsem:loc:cat:comps:tl:hd:arg:loc:cat:head:verb) *>

optionally_coherent_le *> synsem:loc:cat:head:optionally_coherent:plus.

coherent_le *> synsem:loc:cat:head:optionally_coherent:minus.

incoherent_le *> synsem:loc:cat:head:optionally_coherent:minus.


% verb_movement_rule *>
%   (synsem:loc:cat:head:optionally_coherent:OC,
%       dtrs:hd:synsem:loc:cat:head:optionally_coherent:OC).

% Die Initial-Regel ist minus, die MVF-Regel ist plus.
verb_initial_rule *>
  synsem:loc:cat:head:optionally_coherent:minus.

fin_verb_infl_lr *>
  (synsem:loc:cat:head:optionally_coherent:OC,
      dtr:synsem:loc:cat:head:optionally_coherent:OC).

part_derivation_lr *>
  (synsem:loc:cat:head:optionally_coherent:OC,
      dtr:synsem:loc:cat:head:optionally_coherent:OC).

v_trace *>
  synsem:loc:cat:head:(dsl:cat:head:optionally_coherent:OC,
                       optionally_coherent:OC).




% Separately written particles require a moved finite verbal head.
(head_cluster_phrase,
 non_head_dtrs:hd:synsem:loc:cat:head:part) *>
 head_dtr:synsem:loc:cat:head:(vform:fin,dsl:local).
