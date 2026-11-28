% -*- coding: utf-8; mode: trale-prolog -*-
% Orthographic weight: Unicode characters in PHON, excluding word spaces.
% Usually PHON is a singleton. The inf_zu rule also builds a complex_word
% with [zu|Phon], so technical words can have more than one PHON entry.
% Morphologically derived words use their resulting PHON.
% Phrases sum their immediate daughters; empty signs contribute zero.

:- multifile '*>'/2.
:- multifile if/2.
:- discontiguous if/2.


word *> (phon:Phon,
         weight:Weight) goal word_weight(Phon,Weight).

non_overt_le *> weight:(a_ 0).

phrase *> (dtrs:Daughters,
           weight:Weight) goal daughter_weight(Daughters,Weight).

word_weight(Phon,Weight) if
  when(Phon=(e_list;ne_list),undelayed_word_weight(Phon,Weight)).

undelayed_word_weight([],(a_ 0)) if true.
undelayed_word_weight([(a_ Word)|Rest],(a_ Weight)) if
  (word_weight(Rest,(a_ RestWeight)),
   prolog(weights_word_length(Word,FirstWeight)),
   prolog(weights_add(FirstWeight,RestWeight,Weight))).

weights_word_length(Word,Weight) :-
  when(nonvar(Word),atom_length(Word,Weight)).

daughter_weight(Daughters,Weight) if
  when(Daughters=(e_list;ne_list),
       undelayed_daughter_weight(Daughters,Weight)).

undelayed_daughter_weight([],(a_ 0)) if true.
undelayed_daughter_weight([weight:(a_ FirstWeight)|Rest],(a_ Weight)) if
  (daughter_weight(Rest,(a_ RestWeight)),
   prolog(weights_add(FirstWeight,RestWeight,Weight))).

weights_add(First,Rest,Weight) :-
  when((nonvar(First),nonvar(Rest)),Weight is First+Rest).


% Gewichtsklasse (wclass, signature.tdl). Sie wird einmal gesetzt, sobald
% die Zeichenzahl feststeht; danach prüfen LP-Regeln nur noch Typen.
% Die Zahl steht auf sign, die Klasse unter synsem (damit LP-Regeln über
% Valenzlisten sie sehen).
word *> (weight:Weight,
         synsem:wclass:Class) goal weight_class(Weight,Class).

phrase *> (weight:Weight,
           synsem:wclass:Class) goal weight_class(Weight,Class).

weight_class((a_ Weight),Class) if
  prolog(weights_class(Weight,Class)).

weights_class(Weight,Class) :-
  when(nonvar(Weight),(weights_class_type(Weight,Type),add_to(Type,Class))).

weights_class_type(0,weight_0) :- !.
weights_class_type(W,short) :- W =< 3,!.
weights_class_type(W,weight_4_6) :- W =< 6,!.
weights_class_type(W,weight_7_10) :- W =< 10,!.
weights_class_type(W,weight_11_15) :- W =< 15,!.
weights_class_type(W,weight_16_20) :- W =< 20,!.
weights_class_type(W,weight_21_30) :- W =< 30,!.
weights_class_type(_,weight_31_plus).
