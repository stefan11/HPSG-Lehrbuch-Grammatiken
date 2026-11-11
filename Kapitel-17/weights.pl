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
         synsem:weight:Weight) goal word_weight(Phon,Weight).

non_overt_le *> synsem:weight:(a_ 0).

phrase *> (dtrs:Daughters,
           synsem:weight:Weight) goal daughter_weight(Daughters,Weight).

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
undelayed_daughter_weight([synsem:weight:(a_ FirstWeight)|Rest],(a_ Weight)) if
  (daughter_weight(Rest,(a_ RestWeight)),
   prolog(weights_add(FirstWeight,RestWeight,Weight))).

weights_add(First,Rest,Weight) :-
  when((nonvar(First),nonvar(Rest)),Weight is First+Rest).
