% -*- coding: utf-8; mode: trale-prolog -*-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   $RCSfile: lexrules.pl,v $
%%  $Revision: 1.4 $
%%      $Date: 2005/03/03 15:11:24 $
%%     Author: Stefan Mueller (Stefan.Mueller@cl.uni-bremen.de)
%%    Purpose: Eine kleine Spielzeuggrammatik für die Lehre
%%   Language: Trale
%      System: TRALE 2.7.5 (release ) under Sicstus 3.12.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- multifile '--->'/2.
:- multifile ':='/2.
:- discontiguous ':='/2.
:- multifile rule/2.
:- multifile '*>'/2.
:- discontiguous '*>'/2.
:- multifile if/2.
:- discontiguous if/2.
:- multifile fun/1.
:- discontiguous fun/1.

% Koordination von verbalen Projektionen

% Wenn Verbletztverben nichts in DSL haben, kann man bei Koordination DSL gleich ausschließen.

conj_word *>
   (%relational_arg0_word,
    %nö non_scopal_le,
    %overt_word,
    %empty_rel_word
    synsem:loc:(cat:(head:(coord,
                           spec:(loc:(cat:head:Head,
                                      cont:Cont1),
                                 %(ltop:LHandle,
                                 %           ind:LInd)\),
                                 nonloc:Nonloc,
                                 v2:V2)),
                     da:[], % nicht wichtig
                     spr:[],
                     arg_st:[(@argument,
                              arg:(loc:(cat:head:Head,
                                                  %dsl:none\), % auskommentieren bei zyklischer Verbspur.
                                        cont:Cont2),
                                        %\(ltop:RHandle,
                                        % =\=LHandle\), % ohne das loopt Ein Affe nimmt einen Stock und ein Affe lacht.
                                        %      ind:RInd\)\),
                                   nonloc:Nonloc,
                                   v2:V2,
                                   trace:minus))]),
                cont:Cont),
%     rels:coord_sem(LInd,RInd,LHandle,RHandle,Cont,HCons),
     rels:coord_sem(Cont1,Cont2,Cont,HCons),
     hcons:HCons).


/*
rels:[(lhandle:LH,
            rhandle:(RH,
                     =\=LH),  % Wenn zwei Verben zu V1-Verben werden, haben sie LBL und IND
                              % innerhalb ihrer DSL-Werte. Bei der Koordinatoin werden diese
                              % identifiziert. Der Dominanzgraph ist dann nicht wohlgeformt. Man
                              % kann die Analyse schon hier durch eine Ungleichheitsbedingung
                              % ausschließen. Hätte man den KEY in CONT, würden die beiden KEYs
                              % nicht kompatibel sein. Ausnahme: Schläft und schläft Aicke? Für
                              % diesen Fall hilft nur die Ungleichheitsbedingung.
            lindex:LI,
            rindex:RI)]).

*/

fun coord_sem(+,+,+,-,+).
%coord_sem(Ind1,Ind2,LHandle,RHandle,Cont,Rels,HCons)

coord_sem((Cont1,ind:Ind1),(Cont2,ind:Ind2),Cont,Rels,HCons) if
  when((Ind1=(index;event),
        Ind2=(index;event))
      ,undelayed_coord_sem(Cont1,Cont2,Cont,Rels,HCons)).


% What about scope of the quantifiers in the coordinated NP?
%
% Alle Studenten lesen ein Buch und eine Zeitung.
%
% exists x buch(x) exists y Zeitung(y) alle studenten lesen x+y.
%
% exists x buch(x) alle studenten exists y Zeitung(y) lesen x+y.

% The nominal case with `and' we get a plural Index
undelayed_coord_sem(ind:Ind1,ind:(index,
                                  Ind2),
          (ind:Ind0,
           ltop:ConjHandle),
         [(%und_rel
           lbl:ConjHandle,
           arg0:(Ind0,
                 ref,
                 per:third,
                 num:pl),
           lindex:(ref,     % * es-expl und er
                   Ind1),
           rindex:(ref,     % * er und es-expl
                   Ind2)
% In the case of nouns, it is not the handle of the noun that is plugged in here.          
%           ,l_handle:LHandle,
%           r_handle:RHandle
          ),
          (udef_q,        
           lbl:_QHandle,
           arg0:Ind0,
           rstr:Restr)          
          ],

         [(qeq,
           harg:Restr,
           larg:ConjHandle)]) if true.

% Wait for the first conjunct's KEY before selecting finite coordination.
% During generation, the event indices can be known before the KEY type.
undelayed_coord_sem(Cont1,(Cont2,ind:event),Cont,Rels,HCons) if
  when(Cont1=key:(temo;verbal_relation),
       verbal_coord_sem(Cont1,Cont2,Cont,Rels,HCons)).

% finite verbs are not passivized
verbal_coord_sem((ind:Ind1,
                     ltop:LHandle,
                     key:temo),
                    (ind:(event,
                          Ind2),
                     ltop:RHandle),
          (ind:Ind0,
           ltop:ConjHandle),
         [(%und_rel,
           lbl:ConjHandle,
           arg0:(Ind0,
                 event),
           lindex:Ind1,
           rindex:Ind2,
           lhandle:LHandle,
           rhandle:RHandle)
          ],
         []) if !,true.

% the rest with event indices
verbal_coord_sem((ind:Ind1,
                     ltop:LHandle,
                     key:passive:Passive1),
                    (ind:(event,
                          Ind2),
                     ltop:RHandle,
                     key:passive:Passive2),
          (ind:Ind0,
           ltop:ConjHandle,
           key:passive:passive(Passive1,Passive2)),
         [(%und_rel,
           lbl:ConjHandle,
           arg0:(Ind0,
                 event),
           lindex:Ind1,
           rindex:Ind2,
           lhandle:LHandle,
           rhandle:RHandle)
          ],
         []) if true.



conj_word(Relation) :=
  (conj_word,
   rels:hd:Relation).

und ---> @conj_word(und_rel).

coord_phrase *>
  dtrs:[(phon:ne_list,
         synsem:trace:minus),
        synsem:trace:minus].

% Das wird gebraucht, weil die Kombination aus Verbspur und Extraktionsspur trace:minus ist und
% somit nicht ausgeschlossen.
(head_complement_phrase,
 head_dtr:conj_word) *> non_head_dtrs:hd:phon:ne_list.

% Unklar warum bei EFD-Berechnungt 4 x conj y phrasen lizenziert werden.
%coord_phrase *>
%  dtrs:[phon:ne_list,phon:ne_list].

% Ohne diese Einschränkung könnten zwei V1-Verben koordiniert werden, es sollen aber erst die
% Verbletztverben koordiniert werden und dann die V1-Regel angewendet werden. Würde man das nicht
% machen, käme eine nicht wohlgeformte MRS heraus, denn die hooks der beiden Verben würden
% identifiziert, weil die CAT-Werte identifiziert werden und in denen ist der DSL drin und damit
% auch CONT.
(head_complement_phrase,
 dtrs:hd:synsem:loc:cat:head:coord) *> dtrs:tl:hd: @not(verb_initial_rule).

%coord_phrase *> dtrs:hd: @not(verb_initial_rule).

% Die V2-Werte müssen geteilt werden, weil sonst V2 und V1-Sätze dieselben Eigenschaften haben und man so etwass entsteht wie:
% 
% Das Buch gefällt mir und wird gelesen.
%
% wobei das erste Konjunkt ein V2-Satz und das zweite eine Frage ist: "Wird gelesen?"

coord_phrase *>
  (synsem:(loc:(cat:(head:Head,
                     da:get_da_value(DA1,DA2),
                     spr:(unrealized_args(Spr1),
                          unrealized_args(Spr2)),
                     comps:(unrealized_args(Comps1),
                            unrealized_args(Comps2))),
                cont:Cont),
           nonloc:Nonloc,
           v2:V2),
   dtrs:[synsem:(Spec,
                 loc:cat:(head:Head,
                          da:DA1,
                          spr:Spr1,
                          comps:Comps1),
                 nonloc:Nonloc,
                 v2:V2),
         synsem:loc:(cat:(head:(coord,
                                spec:Spec),
                          comps:%list_of_spirits
                                [(arg:loc:cat:(da:DA2,
                                               spr:Spr2,
                                               comps:Comps2),
                                  realized:plus)]),
                     cont:Cont)]).

x_conj_y rule (coord_phrase,
                  dtrs:[Dtr1,Dtr2])
  ===>
cat> Dtr1,
cat> Dtr2.


fun unrealized_args(+,-).
unrealized_args(L1,L2) if
   when( (L1=(e_list;ne_list)),
         undelayed_unrealized_args(L1,L2) ).

undelayed_unrealized_args([],[]) if true.
undelayed_unrealized_args([(Arg,
                            realized:minus)|T1],[Arg|T2]) if 
   unrealized_args(T1,T2).


% Ohne das raised:minus wird analysiert und generiert:
% * Des Romans wird gekannt und von dem Kind geliebt.
%
% trace:minus schließt Extraktion von Argumenten aus, die zu gemeinsamen Argumenten der Koordination werden können.
% Damit wird der folgenden Satz eindeutig. Der zweite Satz ist davon nicht betroffen, weil die Spuren innerhalb des dass-Satzes sind.
%
% Dem Mann glaube ich, dass er ein Buch gibt und ein Märchen erzählt.
% Dem Mann glaube ich, dass er ein Buch gibt und dass er ein Märchen erzählt.
% 
undelayed_unrealized_args([(arg:trace:minus,
                            raised:minus,
                            realized:plus)|T1],T2) if 
   unrealized_args(T1,T2).

% if both passive values are compatible with plus, the PASSIVE value of the coordination is plus.
fun passive(+,+,-).
passive(plus,plus,plus) if !,true.
passive(_,_,minus)      if true.


% Wenn zwei Partizipien koordiniert werden, bekommt die Koordination einen neuen DA-Wert.  Das ist
% wichtig, weil die nicht einfach identifiziert werden dürfen, denn sonst könnte die von-PP nur in
% einem Konjunkt sein und man würde dennoch dieselbe Semantik bekommen, als wäre sie ein Argument
% beider Konjunkte.  Das Passivhilfsverb verlangt eine gefüllte DA-Liste. Diese darf nur vorliegen,
% wenn beide Partizipien eine gefüllte DA-Liste haben.  Die von-Phrase kann Argument beider
% Konjunkte sein, dann wird sie in der Koordination zu einem gemeinsamen Argument und damit stimmt
% dann auch die Semantik.

fun get_da_value(+,+,-).
get_da_value(DA1,DA2,DA) if
  when( (DA1=(e_list;ne_list),
         DA2=(e_list;ne_list)),
         undelayed_get_da_value(DA1,DA2,DA) ).

undelayed_get_da_value([],_,[]) if true.
undelayed_get_da_value(_,[],[]) if true.

% Hier muss noch sichergestellt werden, dass für das Passiv beide DA-Listen einen referentiellen
% Index haben. Im Perfekt ist das aber egal.
undelayed_get_da_value([_],[_],[_]) if true.

