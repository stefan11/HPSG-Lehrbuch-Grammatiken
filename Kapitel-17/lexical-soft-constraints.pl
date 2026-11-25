% -*- coding: utf-8; mode: trale-prolog -*-

%:- dynamic soft_constraint/3, soft_constraint/4.
:- multifile soft_constraint/3, soft_constraint/4.
:- discontiguous soft_constraint/3, soft_constraint/4.

% Passiv mit „kennen“ ist möglich aber sehr markiert.
%
% ?  Der Aufsatz wurde gekannt.
% ?* Der Aufsatz wurde von Aicke gekannt.
%
/*
% Funktioniert nicht, wenn „kennen“ in einer Koordination ist:
%
% Wird das Buch gekannt und geliebt?
%
soft_constraint('no passivization of kennen',
    (passive_aux_verb,
     synsem:loc:cat:arg_st:hd:arg:loc:cont:key:kennen_rel),
%    [apply(both),penalty(hard)]).
    [apply(generation),penalty(60)]).

*/
% Irgendwie wird die Passivierung von kennen aber durch die Koordination besser.
%
soft_constraint('no passivization of kennen',
    (word,
     synsem:loc:(cat:(head:verb,           % muss hier stehen, so lange Artikel keinen key haben.
                      da:hd:raised:minus), % Perfekt ist raised:plus
                 cont:key:kennen_rel)),
%    [apply(both),penalty(hard)]).
    [apply(generation),penalty(60)]).