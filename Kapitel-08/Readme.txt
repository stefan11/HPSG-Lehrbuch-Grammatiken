13.04.2026

Ich benutze jetzt eine Spur, die nicht zyklisch ist.

Wenn man die zyklische Spur verwenden will, muss man in lexicon.pl ganz am Ende die zyklische Spur einkommentieren.

In der Date le_macros.pl in verb_word dsl:none auskommentieren.

verb_word *>
 (%word,
  %arg0_ltop_lbl_le
  loc:(cat:(head:(verb,
                  vform:fin,
                  initial:minus,
                  dsl:none),
            spr:[]),
       cont:ind:event)).

Und in der Datei coordination.pl das head:dsl:none auskommentieren.

conj_word *>
    %relational_arg0_word,
    %nö non_scopal_le,
    loc:(cat:(head:(coord,
                    spec:loc:(cat:Cat,
                              cont:(ltop:LHandle,
                                    ind:LInd))),
              spr:[],
              arg_st:[(loc:(cat:(Cat,
                                 head:dsl:none),  % auskommentieren bei zyklischer Verbspur.
                            cont:(ltop:RHandle, 
                             % =\=LH\), % Nicht mehr nötig
                                % Wenn zwei Verben zu V1-Verben werden, haben sie LBL und IND
                                % innerhalb ihrer DSL-Werte. Bei der Koordinatoin werden diese
                                % identifiziert. Der Dominanzgraph ist dann nicht wohlgeformt. Man
                                % kann die Analyse schon hier durch eine Ungleichheitsbedingung
                                % ausschließen. Hätte man den KEY in CONT, würden die beiden KEYs
                                % nicht kompatibel sein. Ausnahme: Schläft und schläft Aicke? Für
                                % diesen Fall hilft nur die Ungleichheitsbedingung.
                                  ind:RInd)),
                       trace:minus)]),
         cont:(rels:coord_sem(LInd,RInd,LHandle,RHandle,HCons),
               hcons:HCons)).

Folgendes muss wieder auskommentiert werden:

(headed_phrase,
 head_dtr:(word,
           phon:ne_list)) *> head_dtr:loc:cat:head:dsl:none.


Leider hängt sich dann "Kennt sie den Film und den Roman?" auf. Das war in der ursprünglichen Testsatzsammlung nicht enthalten.
