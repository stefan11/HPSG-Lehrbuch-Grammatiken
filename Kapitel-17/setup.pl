% -*- coding: utf-8; mode: trale-prolog -*-

:- ['../Gemeinsames/setup'].

:- multifile generator_candidate_inventory/3, generator_candidate_filter/3.
:- multifile generator_lexical_parent_required/2.

% Zusaetzliche Wörter ohne eigene Semantikrelation für Paraphrasen.
% Die übrigen semantisch leeren Wörter bleiben auf die Eingabe beschränkt.
generator_input_lexicon_exceptions([von,durch]).
% Relativpronomen erlauben Paraphrasen zwischen Attribut und Relativsatz.
% Andere Lesarten derselben Wortformen bleiben auf die Eingabe beschraenkt.
generator_input_lexicon_exception_type(rel_pronoun).

% Admit passive auxiliary inflections through their morphological stem type.
% Example: Der Mann hat ihm zu helfen. -> Ihm hat von dem Mann geholfen zu werden.
% Only zero-EP entries are affected; ordinary semantic matching is retained.
% Bounded Chapter-17 test (empty_only, restricted content vocabulary):
% the requested passive appears among 19 outputs (12.455 s CPU, 841 edges).
% This is a diagnostic, not a full-suite timing measurement.
generator_input_lexicon_exception_stem_type(agentive_passive_aux_verb).

% Modalrelationen duerfen beim Generieren nicht spezifischer werden als
% die Eingabe: z.B. müssen_sollen_rel darf nicht zu müssen_rel werden.
% Er hat das Buch zu lesen. -/-> Er muss das Buch lesen.
% Allgemeinere Lexikoneintraege koennen weiterhin die Eingabesemantik erben.
% TEMO bleibt von dieser Beschraenkung unberuehrt (synkretische Flexion).
%
% Generated phrases: 18.
% Generation: 240.183 s CPU time.
% Chart: 3586 edges (1240 active, 2346 inactive).
%
% Generated phrases: 13.
% Generation: 112.562 s CPU time.
% Chart: 2534 edges (1020 active, 1514 inactive).
generator_no_semantic_specialization(modal_rel).

% Auch SORT-Werte in semantischen Indizes duerfen nicht spezifischer werden.
% Z.B. object im Input lizenziert weder agentive (jemand) noch non_agentive
% (etwas), sofern diese zusaetzliche Einschraenkung nicht schon gegeben ist.
generator_no_semantic_specialization(anything).

% PASSIVE records grammatical licensing, not semantic content.
% Active/passive realizations may differ here; grammar rules still enforce it.
generator_semantic_metadata(verbal_relation,passive).

% Zusaetzlich exakt: Auch allgemeinere lexikalische Modalrelationen werden
% ausgeschlossen. Bei muessen_rel im Input sollen modales haben/sein mit
% muessen_sollen_rel bzw. duerfen_koennen_muessen_sollen_rel nicht antreten.
% Geprueft wird der Typ VOR der Unifikation mit der Eingabe.
% TEMO bleibt weiterhin synkretisch; die Typhierarchie bleibt unverändert.
% Zum schwächeren Verhalten oben zurück: folgende Zeile auskommentieren.
% Ein Märchen erzählen wird er ihr müssen.
% Er wird ihr ein Märchen zu erzählen haben.
% Ein Märchen wird ihr von ihm zu erzählen sein.
%
% Ohne den strikten Test wird auch folgendes zugelassen:
%
%   Er wird lachen können wollen.
% * Von ihm wird zu lachen sein wollen.
%
% generator_exact_semantic_type(modal_rel).

% Distributive Tempus-/Modussemantik bei verbaler Koordination.
generator_distributive_relation(temo,conjunction_rel).
generator_distributive_operator(temo,[lbl],[arg0],[arg3]).
generator_distributive_conjunction(conjunction_rel,[lbl],[arg0],[[lhandle],[rhandle]],[[lindex],[rindex]]).

% Zeige alle morphologischen Formen, die über Lexikoneregeln erzeugt werden.
% In Kapiteln kann Ausgabe von Flexionsmerkmalen konfiguriert werden.
% Pro Kapitel einschalten.
:- ale_flag(morphoutput,_,paradigm).
%:- ale_flag(morphoutput,_,off).


% TDL signature input; TRALE supplies missing least upper bounds.
:- ale_flag(subintro,_,file).

% feature hiding and ordering
hidden_feat(dtrs).          % hide the dtrs attribute (shown by tree)
hidden_feat(head_dtr).      % hide the dtrs attribute (shown by tree)
hidden_feat(non_head_dtrs). % hide the dtrs attribute (shown by tree)
hidden_feat(dtr).           % hide the dtrs attribute (shown by tree)
hidden_feat(affix).         % hide the affix attribute 
hidden_feat(infl).          % hide the affix attribute 
hidden_feat(inf_marking).   % hide technical feature

% Binäres Merkmal, das aus Effizenzgründen verwendet wird.
% Sieht nicht gut aus in Demos ... =;-)
hidden_feat(trace).
hidden_feat(phrase).    % V1 ist eine unäre Projektion, keine Lexikonregel
                        % Koordinationen von Wörtern dürfen Töchter sein, echte Phrasen nicht.
                        % Da das Merkmal im Buch nicht eingeführt wurde, wird es nciht angezeigt.

hidden_feat(max_).

>>> phon.        % phon shall be shown first
>>> lbl.

head   <<< spr.
spr    <<< comps.
comps  <<< arg_st.

%gtop <<< ltop.
ltop <<< ind.
ind  <<< key.
key  <<< aktionsart.

arg0 <<< rstr.
rstr <<< body.

loc <<< nonloc.
nonloc <<< lex.

synsem <<< rels.
rels   <<< hcons.
hcons  <<< root_cont.
root_cont <<< dtrs.
root_cont <<< dtr.
dtr <<< affix.

v2 <<< cannonical.

arg0   <<< lindex.
lindex <<< rindex.
rindex <<< lhandle.
lhandle <<< rhandle.

%:- fs. print AVM after parsing
%:- nofs. % do not print feature structures after parsing

% display MRSes after each parse in the interactive mode.
:- mrs.

% send MRSes to utool for display
:- display_mrs.

% send MRSes to utool for scoping
:- scope_mrs.

% If a description that should be used for generation is produced from a chart edge,
% which pathes of the input sign shall be considered?
%gen_pathes([[synsem,loc,cat,head],[synsem,loc,cat,spr],[synsem,loc,cat,comps],[synsem,loc,cont],[rels],[hcons]]).
gen_pathes([[synsem,loc,cat,head]]).
% Preserve the NP category while allowing all grammatical cases.
gen_pathes_exclude([[synsem,loc,cat,head,case]]).
% Require complete results without copying the input valence/spirits.
gen_root_condition(@root).

% Nur diese spielen in der Syntax eine Rolle. Töchter in syntaktischen Regeln sind alle vom Typ syntactic_sign.
syntactic_object(syntactic_sign).

ind_path([synsem,loc,cont,ind]).
% Just use h1 and add a qeq to the local top. This does not have any effect in Utool.
% gtop_path(implicit).

% Just print h1 and do not do anything else.
gtop_path(none).

ltop_path([synsem,loc,cont,ltop]).
cont_path([synsem,loc,cont]).
liszt_path([rels]).
hcons_path([hcons]).

% Generator: Die Verbspur bezieht Valenz und Semantik von einem ausgewaehlten
% Verb (auch einer Wortkoordination). Sie verbraucht dessen Relationen nicht
% ein zweites Mal. Die Quellbeschreibung entspricht der Tochter der V1-Regel.
generator_empty_anchor([synsem,loc,cat,head,dsl],[synsem,loc],
                       (synsem:(loc:cat:head:(verb,initial:minus),
                                phrase:minus,trace:minus))).

% Extraktionsspuren erhalten ihren LOC-Wert vom ausgewaehlten Filler.
% Das gilt auch fuer eine PP innerhalb einer NP (z.B. "von dessen Kind").
generator_empty_anchor([synsem,loc],[synsem,loc],
                       (synsem:(loc:cat:(spr:list_of_spirits,comps:list_of_spirits),
                                nonloc:(slash:[],rel:ne_list),trace:minus))).

% Argument attraction: anchor verbal extraction traces before projecting
% empty clusters with an otherwise open COMPS list.
generator_empty_anchor([synsem,loc],[synsem,loc],
                       (synsem:(loc:cat:head:(verb,dsl:none),
                                nonloc:slash:[],trace:minus))).

% Gewöhnliche gesättigte Modifikatoren liefern den LOC-Wert der Spur.
% Relative Füller (REL nicht leer) sind durch den Anker oben abgedeckt.
generator_empty_anchor([synsem,loc],[synsem,loc],
  synsem:(loc:cat:(head:modifier_head,
                  spr:list_of_spirits,comps:list_of_spirits),
          nonloc:(slash:[],rel:[]),trace:minus)).

% Auch gesättigte Modifikatorspuren benötigen einen passenden sichtbaren
% Füller. Sonst können unbestimmte leere Adjunkte beliebig kombiniert werden.
%
% Das Buch ist zu lesen.
% Alt:
% Generation: 736.718 s CPU time.
% Chart: 8709 edges (2038 active, 6671 inactive).
% Neu:
% Generation: 363.001 s CPU time.
% Chart: 5441 edges (1526 active, 3915 inactive).
generator_empty_anchor_required(
  synsem:(trace:extraction,loc:cat:head:modifier_head)).


% Eine verbale Extraktionsspur kann trotz geschlossener COMPS-Liste noch
% eine offene SUBJ-Liste haben. AcI-Verben ziehen beide Listen an.
% Deshalb muss vor der Projektion stets ein passender verbaler Filler den
% gesamten LOC-Wert liefern, auch wenn COMPS bereits leer ist.
generator_empty_anchor_required(
  synsem:(trace:extraction,loc:cat:head:verb)).

generator_valence_path([synsem,loc,cat,comps]).
% Nominal spirits may stay open until their filler is known; verbal valence
% must be anchored before the generator projects an empty category.
generator_valence_anchor_required(synsem:loc:cat:head:verb).

outscoped_feat(larg).
sc_arg_feat(harg).
scopable_description([@decl,@interrog,@ass_or_imp]).

quantifiers([udef_q,def_q,some_q,demonstrative_q,proper_q]).



% Nodes in Trees
grale_abbreviation(
    synsem:loc:cat:(head:(noun,case:morph_case:Case),
                    spr:[realized:plus],
                    comps:([]
                          ;[realized:plus])),
    'NP'(Case)).

    
grale_abbreviation(
    synsem:loc:cat:(head:(noun,case:morph_case:Case),
                    spr:[realized:minus],
                    comps:([]
                          ;[realized:plus])),
    '\x0305\N'(Case)). % N̅[nom].
    % 'N'''(Case)      % N'[nom]                   

    
grale_abbreviation(
    synsem:loc:cat:(head:(noun,case:morph_case:Case),
                    spr:[realized:minus],
                    comps:[realized:minus]),
    'N'(Case)).

grale_abbreviation(
    synsem:loc:cat:head:(det,case:morph_case:Case),
    'Det'(Case)).

    
grale_abbreviation(
    synsem:loc:cat:(head:(comp_prep,pform:PForm),
                    comps:[realized:plus]),
    'PP'(PForm)).

% Elements in ARG-ST Lists
grale_abbreviation(arg:loc:cat:head:det, 'Det').

grale_abbreviation(arg:loc:cat:head:part, 'Part').

grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:str,
                                 morph_case:nom)),
    'NP'(snom)).

grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:str,
                                 morph_case:gen)),
    'NP'(sgen)).
    
grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:str,
                                 morph_case:acc)),
    'NP'(sacc)).

grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:lex,
                                 morph_case:nom)),
    'NP'(lnom)).

grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:lex,
                                 morph_case:gen)),
    'NP'(lgen)).
    
grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:lex,
                                 morph_case:dat)),
    'NP'(ldat)).

grale_abbreviation(
    arg:loc:cat:head:(noun,case:(case_type:lex,
                                 morph_case:acc)),
    'NP'(lacc)).

grale_abbreviation(
    arg:loc:cat:head:(noun,case:case_type:str),
    'NP'(str)).
    
grale_abbreviation(
    arg:loc:cat:head:(noun,case:morph_case:Case),
    'NP'(Case)).

grale_abbreviation(
    arg:loc:cat:head:(comp_prep,pform:PForm),
    'PP'(PForm)).

grale_abbreviation(
    arg:loc:cat:head:(verb,dsl:local),
    'VP//V').

grale_abbreviation(
    arg:loc:cat:head:(verb,dsl:local),
    'V//V').

grale_abbreviation(
    arg:loc:cat:head:vform:VForm,
    'V'(VForm)).

    
strike_out_pattern(realized:plus).

% German display templates; no linguistic constraint is changed.
:- dynamic morphology_paradigm_info/3.
:- retractall(morphology_paradigm_info(_,_,_)).

morphology_paradigm_info(reg_fin_verb_infl_lr,
    (affix:(per:Per,num:Num),rels:hd:Tense),
    [Per,Num,type(Tense)]) :-
    member(Per,[first,second,third]),
    member(Num,[sg,pl]).

morphology_paradigm_info(non_fin_verb_infl_lr,
    synsem:loc:cat:head:vform:VForm,
    [type(VForm)]).

:- dynamic morphology_info/2.

:-retractall(morphology_info/2).

/*
morphology_info((synsem:loc:cat:(head:(verb,
                                       vform:fin),
                                 arg_st:last(arg:loc:cont:ind:(per:Per,
                                                               num:Num))),
                 rels:hd:Relation),
                [Per,Num,type(Relation)]).

morphology_info(synsem:loc:cat:head:(verb,
                                     vform:VForm),
                [VForm]).

morphology_info(synsem:loc:cat:head:(attr_participle,
                                     mod:loc:cat:spr:hd:arg:loc:cat:head:(case:morph_case:Case,
                                                                          dtype:DType,
                                                                          gen:Gen,
                                                                          num:Num)),
                [adj,Gen,Num,Case,DType]).

*/
% Additional coverage records, separate from the linguistic MRS.
generator_rels_path([generator_rels]).
generator_extra_rels(FS,Extra) :-
   get_type(FS,Type),
   (Type \== 0,
    (sub_type(pers_pronoun,Type) -> Kind=generator_pers_pronoun_rel
     % Alte Variante: Relativpronomen waren an die Eingabe gebunden.
     % Das verhindert Paraphrasen wie Partizipialattribut <-> Relativsatz.
     %; sub_type(rel_pronoun,Type) -> Kind=generator_relative_pronoun_rel
    )
    -> add_to(Kind,EP),ind_path(Path),gen_pathval(Path,FS,bot,Index,bot),
       gen_pathval([generator_index],EP,bot,Argument,bot),Argument=Index,Extra=[EP]
    ; Extra=[]).

% Optionaler Head-Movement-Filter: Implementierung in TRALE, Angaben hier.
% Einschalten: ale_flag(head_movement_filter,_,on).
% Ausschalten: ale_flag(head_movement_filter,_,off).
% Der Lizenzgeber muss vor der geprüften Kante stehen. Der Vergleich bindet
% die Kante nicht. Ohne Flag oder Konfiguration bleibt der Parser ungefiltert.
% Bei möglicher Koordination nicht filtern: koordinierte Köpfe können einen
% LOCAL-Wert beitragen, der in keinem einzelnen Lexikoneintrag vorkommt.
:- multifile parser_head_movement_filter/6.
parser_head_movement_filter(
  (synsem:(loc:cat:head:(verb,initial:minus,vform:fin),phrase:minus,trace:minus)),
  [synsem,loc],                         % Wert des lexikalischen Lizenzgebers
  [synsem,loc,cat,head,dsl], % zu lizenzierender Wert
  local, before, bypass(synsem:loc:cat:head:coord)).

% Valenzdiagnose auf fertigen Lexikoneinträgen; verändert keine Beschränkungen.
% DA muss geschlossen sein. Bei ARG-ST muss nur das erste Argument samt
% Wortart feststehen; der Rest darf für Argumentanziehung offen bleiben.

% Die vier Argumente bedeuten:

% 1. **`[synsem,loc,cat,head]`**: Pfad vom Lexikoneintrag zu dem Wert, der die Auswahl der zu prüfenden Einträge bestimmt.
% 2. **`verb`**: Nur wenn dieser Wert bereits vom Typ `verb` oder einem Untertyp ist, wird geprüft.
% 3. **`[synsem,loc,cat,arg_st]`**: Pfad zur zu prüfenden Liste.
% 4. **`first([arg,loc,cat,head],head)`**: Beim ersten Listenelement wird dem Pfad `arg:loc:cat:head` gefolgt. Dort muss ein spezifischerer Typ als der allgemeine Typ `head` stehen, beispielsweise `noun`, `verb` oder `prep`.

% Die Prüfung warnt also, wenn die erste Listenzelle noch unbestimmt ist oder die Wortart ihres Arguments noch nicht feststeht. **Der Listenrest darf offen bleiben**, damit Argumentanziehung möglich bleibt. Eine leere ARG-ST-Liste wird akzeptiert.

% Allgemein lautet das Format:

% lexical_valence_check(Auswahlpfad, Auswahltyp, Listenpfad, Prüfung).

% Als Prüfung sind außerdem `closed` für eine vollständig geschlossene Liste und `first` für ein bereits typmäßig spezifiziertes erstes Element möglich. Es werden ausschließlich Warnungen ausgegeben, keine Werte ergänzt.


:- ale_flag(lexical_valence_checks,_,on).
lexical_valence_check([synsem,loc,cat,head],verb,
                     [synsem,loc,cat,head,da],closed).
lexical_valence_check([synsem,loc,cat,head],verb,
                     [synsem,loc,cat,arg_st],first([arg,loc,cat,head],head)).

% Semantisch leeres Präpositions-zu braucht eine passende PFORM-Selektion.
% Infinitiv-zu wird direkt von inf_zu über token> zu bereitgestellt.
:- ale_flag(generator_lexical_selection,_,on).
generator_lexical_selection(
    (comp_preposition,synsem:loc:cat:head:pform:zu_pform),
    bot,[synsem,loc,cat,arg_st],
    [[synsem,loc,cat,head,pform]-[arg,loc,cat,head,pform]]).

% Attributive Kongruenz: Der Index ordnet nur das Bezugsnomen zu.
% Verglichen werden die syntaktischen Anforderungen an den Artikel,
% nicht GEN/NUM am semantischen Index (vgl. Mädchen).
:- ale_flag(generator_lexical_agreement,_,on).
% This addresses inflectional agreement, independently of the movement filter
% below. Select the resulting HEAD type so that orthographic wrappers such as
% complex_word_dtrs around "anzulachendes" are included. MOD IND identifies the
% nominal host; the existing paths compare syntactic determiner requirements.
% Thus the neuter form cannot modify masculine "Affe". The semantic index's
% gender is not equated with syntactic agreement gender (cf. "Mädchen").
generator_lexical_agreement(
    synsem:loc:cat:head:attr_adj_or_attr_participle,
    [synsem,loc,cat,head,mod,loc,cont,ind],
    [synsem,loc,cat,head,mod,loc,cat,spr,hd,arg,loc,cat,head],
    synsem:loc:cat:head:noun,
    [synsem,loc,cont,ind],
    [synsem,loc,cat,spr,hd,arg,loc,cat,head]).

% Exclude verb movement in intersective nominal modifier contexts.
%
% General format:
% generator_label_context_exclusion(CandidateType, CandidateLabelPath,
%     ep(InputIndexPath, InputIndexType, InputLabelPath)).
%
% 1. CandidateType selects a generator candidate whose type is already this
%    type or a subtype. Here verb_movement_rule includes the V1/V2 rule.
% 2. CandidateLabelPath locates the label to check in that candidate. Here it
%    is the candidate's SYNSEM|LOC|CONT|LTOP.
% 3. ep(...) describes which input EPs supply the labels to compare against.
%    It is a configuration term, not a grammatical relation or a new MRS EP.
%    ep([arg0],ref,[lbl]) selects input EPs whose ARG0 is already of type ref
%    or a subtype, and reads their LBL. ref describes ARG0, not the EP itself.
%
% At initialization, the filter keeps only labels already shared by at least
% two distinct input EPs. During generation it rejects a selected candidate
% if its LTOP is IDENTICAL to one of those labels. Mere unifiability is not
% sufficient. Unknown values remain possible; the filter instantiates nothing.
% The check runs before putting the candidate on the agenda and can reject an
% incomplete candidate. Only input EP positions are cached, not copied AVMs.
%
% In "der anzulachende Affe fetzt", affe_rel(ARG0 x4:ref) and the embedded
% pres_ind have the same LBL h10. Hence h10 is a qualifying label. A moved
% realization of that embedded predicate would have LTOP h10 and is rejected.
% In this grammar, rc requires a verb-final clause, and attributive lexical
% derivation precedes syntactic verb movement. These are the grammatical
% reasons for declaring the exclusion. The runtime does not infer them from
% the shared label. Revise the declaration if those grammatical options change.
% A verb-final "hat" in "der Affe, den jemand anzulachen hat" remains possible.
% The matrix predicate "fetzt" has a different label and retains movement.
%
% Example: der anzulachende Affe fetzt, full 2222-entry lexicon, empty_only.
% Baseline: 304.388 s CPU, 2837 edges. With these filters and the broader
% agreement target above: 222.339 s, 2196 edges, identical 5 outputs, 0 residues.
% One example measurement, not a full-suite benchmark. No root-type restriction.
generator_label_context_exclusion(
    verb_movement_rule,
    [synsem,loc,cont,ltop],
    ep([arg0],ref,[lbl])).

% Apply the same exclusion before constructing the corresponding verb trace.
% The first argument identifies the exact generator_empty_anchor/3 mapping
% whose empty-side path is SYNSEM|LOC|CAT|HEAD|DSL. It is a mapping identifier,
% not the label path. The second argument reads LTOP from its overt source.
% The third argument selects shared input labels exactly as above.
% If the source's LTOP is such a label, it cannot license this verb trace.
% Reject it before resolving the empty category's valence. Other anchor
% mappings, including ordinary extraction traces, remain available.
% This early guard supplied the measured saving: 11189 rejected anchor
% attempts in the example; these are attempts, not distinct saved chart edges.
generator_anchor_context_exclusion(
    [synsem,loc,cat,head,dsl],
    [synsem,loc,cont,ltop],
    ep([arg0],ref,[lbl])).

% Necessary-condition filters for the Chapter-17 generator.
% These declarations describe properties of THIS grammar, not universal
% restrictions on German. Revisit them if particle realization, auxiliary
% selection, nominal formation or independent nonfinite roots are extended.
% Runtime documentation: docs/generator-candidate-filters.md.
%
% generator_candidate_inventory(Name, PossibleSourceTypes, ValuePaths)
% collects ground type tuples from all initial lexical candidates, including
% multiword entries. Unknown types/paths contribute bot and keep alternatives.
% Contract: every possible nominal host/agreement provider in this grammar
% is represented by such a lexical source. Derivation is already complete.
% Phrasal composition preserves these requirements; it does not create a new
% gender/person option absent from every possible lexical source.
generator_candidate_inventory(nominal_genders,
    [type([synsem,loc,cat,head],noun),type([synsem,loc,cat,spr],ne_list)],
    [[synsem,loc,cat,spr,hd,arg,loc,cat,head,gen]]).
generator_candidate_inventory(nominal_person_number,
    [type([synsem,loc,cat,head],noun)],
    [[synsem,loc,cont,ind,per],[synsem,loc,cont,ind,num]]).
%
% generator_candidate_filter(Name, Stage, ConjunctionOfTests)
% rejects a candidate only when EVERY test already holds. type(P,T) requires
% entailment, disjoint(P,T) proven type incompatibility; neither instantiates
% a node. initial works on a snapshot after lexical/orthographic expansion.
% support runs after initial deletions. edge checks completed new phrases.
% Missing values do not prove violations. Only ground type names/positions
% are cached, never copied semantic indices. Parsing does not call these rules.
%
% "habendes": its MOD index need not be linked to Affe, so the older anchored
% agreement filter cannot select that host. Here unsupported means that NO
% possible nominal host has compatible syntactic gender. One compatible or
% unknown host keeps the modifier; it need not be the actual semantic host.
% SPR agreement, not semantic index gender, handles the Mädchen distinction.
generator_candidate_filter(attributive_gender_support,initial,
    [type([synsem,loc,cat,head],attr_adj_or_attr_participle),
     unsupported(nominal_genders,
        [[synsem,loc,cat,head,mod,loc,cat,spr,hd,arg,loc,cat,head,gen]])]).
%
% "habe" FIRST/SG: an existential actor can be realized by "jemand", but
% that is not a FIRST/SG nominal realization. Check lexical providers instead
% of assigning THIRD/SG/MAS to the implicit semantic referent. "Ich lache"
% keeps FIRST/SG. Restrict this rule to FIRST/SG: impersonal predicates and
% clause subjects can supply default THIRD/SG without a corresponding NP.
generator_candidate_filter(first_singular_support,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([affix,per],first),type([affix,num],sg),
     unsupported(nominal_person_number,[[affix,per],[affix,num]])]).
%
% Modal "gehabt/gewesen": the input itself requires a TEMO immediately
% above the covered modal EP. A PPP continuation would insert perfect_rel,
% which the input lacks. Own DA [] blocks another passive embedding; the
% forbidden attributive gehabt derivative has already been excluded.
% covered_parent_link tests the actual input labels and coverage, without
% adding a handle constraint. This is independent of @decl/@interrog/@root:
% it also applies inside a nominal modifier. No input index is instantiated.
generator_candidate_filter(modal_participle_needs_perfect,initial,
    [type([synsem,loc,cat,head,vform],ppp),
     type([synsem,loc,cat,head,aux],plus),
     type([synsem,loc,cat,head,da],e_list),
     covered_parent_link(temo,[arg3],modal_rel,[lbl]),
     no_input_type(perfect_rel)]).
%
% Semantically empty auxiliary PPPs (notably "worden") have no covered EP
% for that input-label test. For them retain the narrower finite-root
% contract: DA [] blocks further passive embedding, and the continuation
% requires perfect_rel. Independent PPP fragments under @root are retained.
% This separate fallback does NOT restrict the modal rule above to FIN.
generator_candidate_filter(empty_auxiliary_participle_needs_perfect,initial,
    [root_type([synsem,loc,cat,head,vform],fin),coverage(empty),
     type([synsem,loc,cat,head,vform],ppp),
     type([synsem,loc,cat,head,aux],plus),
     type([synsem,loc,cat,head,da],e_list),no_input_type(perfect_rel)]).
%
% Separate "an" requires V2 here; this grammar excludes its extraction.
% The particle's MOD LTOP reaches the intersective nominal label through
% müssen_sollen_rel -> pres_ind -> affe_rel in the motivating input. Follow
% only modal_rel/temo ARG3 links: an arbitrary embedding could license V2.
% Shared labels and links must ALREADY be identical, not merely unifiable.
% Matrix "fetzt" and ordinary matrix particle constructions remain possible.
generator_candidate_filter(particle_in_nominal_context,initial,
    [type([],subj_isect_modifying_particle),
     shared_label_context([synsem,loc,cat,head,mod,loc,cont,ltop],
        ep([arg0],ref,[lbl]),
        [scope(modal_rel,[arg3],[lbl]),scope(temo,[arg3],[lbl])])]).
%
% Lexical "gelacht/lachen" still requiring a separate particle cannot realize
% it in a nonfinite phrase. The orthographic LR has already produced separate
% angelacht/anlachen/anzulachen candidates; no intermediate LR input is lost.
generator_candidate_filter(nonfinite_separate_particle,initial,
    [disjoint([synsem,loc,cat,head,vform],fin),
     type([synsem,loc,cat,arg_st,hd,arg,loc,cat,head],part),
     type([synsem,loc,cat,arg_st,hd,realized],minus)]).
%
% Plain "lachen" can lack that particle slot altogether. If it consumes
% lachen_rel but leaves gerichtet_auf whose ARG1 is the SAME laughter event,
% there is no later nonfinite phrase rule that can add this particle.
% This is intentionally the tested lachen/gerichtet_auf pair, not a global
% ban on laughter or an assumption about every modifying relation.
generator_candidate_filter(unconsumed_directed_particle,initial,
    [disjoint([synsem,loc,cat,head,vform],fin),
     uncovered_link(lachen_rel,[arg0],gerichtet_auf,[arg1])]).
%
% After removing the impossible "an", finite/attributive variants still
% selecting a separate particle also lack a partner. Check all surviving
% particle candidates with disjoint semantic coverage. An unknown compatible
% source keeps the target; unrelated lexical entries are not instantiated.
generator_candidate_filter(missing_particle_partner,support,
    [type([synsem,loc,cat,arg_st,hd,arg,loc,cat,head],part),
     type([synsem,loc,cat,arg_st,hd,realized],minus),
     no_disjoint_candidate([type([synsem,loc,cat,head],part)])]).
%
% "von jemandem anlachen" (BSE): an overt own passive PP can continue only
% under lassen-passive in this grammar. The actual non-head daughter and its
% TRACE minus establish overt realization; REALIZED plus alone also marks
% omitted PPs and is therefore insufficient. DA/PP indices must be identical.
% If lassen_passive_rel is available (even underspecified), retain the phrase.
generator_candidate_filter(bare_infinitive_passive_pp,edge,
    [type([],head_complement_phrase),
     type([head_dtr,synsem,loc,cat,head,vform],bse),
     type([non_head_dtrs,hd,synsem,loc,cat,head,pform],von_pform),
     type([non_head_dtrs,hd,synsem,trace],minus),
     same([non_head_dtrs,hd,synsem,loc,cont,ind],
          [head_dtr,synsem,loc,cat,head,da,hd,arg,loc,cont,ind]),
     no_input_type(lassen_passive_rel)]).
%
% Existing upward lexical support: a bare/zu infinitive needs a selector in
% a finite-root generation. The selector must have disjoint semantic coverage
% and a possible input-semantic connection. Unknown links stay possible.
% The selector projections are supplied by generator_lexical_support below.
% This tests FIN, not @decl: questions and imperatives are included. @root
% does not entail FIN and therefore leaves this additional policy disabled.
generator_lexical_parent_required(bse_verb_infl_lr,
    head([synsem,loc,cat,head],participle_or_verb)) :-
    gen_candidate_root_type([synsem,loc,cat,head,vform],fin).
generator_lexical_parent_required(inf_verb_infl_lr,
    head([synsem,loc,cat,head],participle_or_verb)) :-
    gen_candidate_root_type([synsem,loc,cat,head,vform],fin).
%
% Private full-lexicon prototype, "Der anzulachende Affe fetzt", @decl,
% empty_only, 2048 MiB, no OS memory polling: baseline 206.858 s CPU/2196
% edges; combined filters 42.823 s/880 edges in the repeat (one run 25.292 s).
% Exactly the same five outputs, zero residues. Without the PP edge check:
% 43.683 s/897 edges; its separate CPU benefit is not established.
% Prepared live implementation: 25.673 s CPU/880 edges, same 5 outputs,
% zero residues; this is another single run, not a stable 25-second promise.
% Six positive checks preserved all outputs: Ich lache (7), Er lacht ihn an
% (10), Aicke hat gelacht incl. worden (7), Das angelachte Kind fetzt (5),
% Kennt Aicke Conny (14), Er lässt von ihm lachen (5). No whole-suite claim.

% Fruehe Partnerpruefung fuer argumentanziehende Verben.
% Die Projektion erhaelt HEAD und die COMPS-Argumente, aber nicht deren
% REALIZED/RAISED-Werte: Diese koennen sich bei der Phrasenbildung aendern.
% Bekannte IND-/LTOP-Bezuege ordnen moegliche lexikalische Partner zu.
% Unbekannte oder nur phrasal verfuegbare Bezuege werden nicht ausgeschlossen.
% Delays werden nur auf Kopien durch die Partnerprobe geweckt.
%:- ale_flag(generator_lexical_support,_,on).
%:- ale_flag(generator_lexical_support,_,chains).
:- ale_flag(generator_lexical_support,_,tabled).
:- ale_flag(generator_chain_anchor_matching,_,strict).
%:- ale_flag(generator_chain_anchor_matching,_,permissive).

generator_lexical_support(
    [synsem,loc,cat,arg_st,hd,arg,loc],
    [synsem,loc],head([cat,head],verb),
    [[cont,ind],[cont,ltop]],valence([cat,comps],[arg])).

% Experimentelle Valenzvorschau bei der Generierung (ohne Hilfsmerkmale).
% Offene Kopf-Komplement-Kanten warten auf eine passende verbale Projektion.
% participle_or_verb umfasst auch die attributiven Partizipien: Deren offene
% Valenz darf nicht an der Pruefung vorbeigehen. Die uebrigen Pfade stammen
% aus generator_lexical_support/5 oben. REALIZED bleibt bei der Projektion
% erhalten; RAISED wird nicht geteilt. Vergleich: Flag auf off setzen.
:- ale_flag(generator_valence_wait,_,on).
generator_valence_wait(
    head_complement_phrase,
    head([synsem,loc,cat,head],participle_or_verb),
    projection([cont],[realized],[cat,head,vform])).

% Lexikalische Valenzvorschau auch beim Parsen, ohne attracted_comps_.
% Nutzt die obigen generator_valence_wait-/generator_lexical_support-Pfade.
% COMPS behaelt in dieser Grammatik realisierte Argumente als "spirits";
% deshalb koennen Listenlaenge und Argumenttypen vorab verglichen werden.
% Kein Wortstellungsfilter: auch Scrambling/Voranstellung bleibt moeglich.
% Keine Bindung der Kante durch die Probe. Bei Koordination oder zu grosser
% Vorschau wird normal geparst. Ausschalten: ale_flag(parser_valence_filter,_,off).
%:- ale_flag(parser_valence_filter,_,on).
% Der Filter verringert bei einem Gesamtlauf die Kanten um 1016, braucht aber 38 Sekunden länger (5:54 gesamt)
:- ale_flag(parser_valence_filter,_,off).
:- multifile parser_valence_filter/4.
parser_valence_filter(
 [cat,head,subj],
 restructured([synsem,loc,cat,head,initial],plus), % V1/V2 ersetzt die Valenz
 argument([loc],head([cat,head],participle_or_verb),
   [[loc,cat,head],[loc,cat,head,case],[loc,cat,head,pform],
    [loc,cat,head,vform],[loc,cont,ind,per],[loc,cont,ind,num]]),
 bypass(synsem:loc:cat:head:coord)).

% Experimental generic runtime contract; closure itself is grammar code.
root_cont_paths([utterance],plus,[root_cont,rels],[root_cont,hcons]).
generator_root_cont_relations([exists_q,ec_trial_entity_rel]).

% Unrealisierte Partikelargumente brauchen eine kompatible Partikel im Satz.
% Bereits durch die Zusammenschreibungsregel realisierte Partikeln bleiben frei.
% Gezielter Test mit der Schreibungsbeschränkung: „er lacht“, Filter aus -> an:
% 13 -> 9 Chart-Kanten; beide Analysen bleiben erhalten. Kein Gesamtlauf.
% Gesamt-Parsezeit von 3:02 auf 1:26 min
:- multifile parser_argument_support/6.
:- ale_flag(parser_argument_support,_,on).
parser_argument_support(
    synsem:loc:cat:head:verb,
    [synsem,loc,cat,arg_st],
    argument([arg],[loc,cat,head],part,[realized]),
    synsem:loc:cat:head:part,
    [synsem],
    bypass(synsem:loc:cat:head:coord)).


% Zeige Verletzung von verletzbaren Beschränkungen.
%:- constraint_debug(on).
:- constraint_debug(off).