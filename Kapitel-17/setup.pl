% -*- coding: utf-8; mode: trale-prolog -*-

:- ['../Gemeinsames/setup'].

:- multifile generator_candidate_inventory/3, generator_candidate_filter/3.
:- multifile generator_lexical_parent_required/2.
:- discontiguous generator_candidate_filter/3,generator_lexical_parent_required/2.
:- dynamic generator_nominal_context_provider_positions/1,
           generator_nominal_context_root_disjoint/0,generator_nominal_context_label_links/1.


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

% Tote Konjunkte (TRALE gen_conjunct_dead/1): Eine Kante innerhalb eines
% Konjunkts, die ein von beiden Konjunktköpfen selegiertes Argument schon
% realisiert, wird verworfen. Realisierer sind EPs mit dem Index unter ARG0
% oder, für Pronomen (generator_extra_rels/2), unter GENERATOR_INDEX.
%
% ACHTUNG Reflexiva: Der Filter setzt voraus, dass jedes geteilte Argument
% nur über eine eigene EP realisiert wird. Bekommen Reflexivpronomen später
% keine eigene EP (z. B. nur Bindung über KEY oder einen Typ unter CONT),
% müssen sie wie Personalpronomen einen generator_extra_rels-Eintrag mit
% GENERATOR_INDEX erhalten, sonst verwirft der Filter gültige Kanten.
% Testsatz dafür: siehe test_items.pl, "Er kennt sich und lacht."
generator_conjunct_index_path([generator_index]).

% Phrasen, die einen Selektor brauchen (TRALE gen_selector_dead/1): Eine
% fertige zu-Infinitiv-Phrase, die nicht die ganze Eingabe abdeckt, muss
% später von einem Kopf mit zu-Infinitiv in ARG-ST selegiert werden
% (scheinen, Kontroll- und Phasenverben, modale Infinitive). Alle diese Köpfe
% haben eine eigene Relation. Hat jeder mögliche Selektor seine EP schon in
% der Phrase verbraucht, wird die Phrase verworfen. Die Selektoren werden
% nach der lexikalischen Expansion automatisch ermittelt; VFORM muss dort
% schon spezifischer als vform sein. Angehobene, noch offene Komplemente
% (z. B. promote_dat(Comps) beim bekommen-Passiv hinter dem ppp-Argument)
% zählen nicht: Selegiert das Partizip eine zu-VP, ist es selbst der Selektor.
% Bricht, falls ein Kopf ohne EP oder ein leerer Kopf zu-VPs selegiert.
% Modifikatorinseln (TRALE gen_island_dead/1): Ein Verb, dessen LBL mit dem
% eines Nomens geteilt wird (attributives Partizip oder Relativsatz), bildet
% mit allem, was semantisch von ihm abhängt, eine Insel. Aus ihr kann nichts
% heraus, und innerhalb kann nur ein Relativsatz binden, dessen Relativphrase
% nie ein Partizip ist. Eine Kante ganz in der Insel mit Partizip in SLASH
% ist daher tot. NP-, PP- und zu-Infinitiv-SLASH bleiben erhalten
% (Relativphrase, auch Rattenfänger mit zu-Infinitiv).
% Später: im rein pränominalen Bereich auch diese ausschließen.
generator_modifier_island([lbl],[arg0],event,[synsem,nonloc,slash],
    [type([cat,head],verb),type([cat,head,vform],ppp)]).
% Der Index eines SLASH-Elements. Die Spur erhält LOC vom Füller, der Index
% benennt also die EP des Füllers. Liegt sie in einer Insel, ist auch der
% Füller dort und kann nicht binden: Die Kante ist tot, auch wenn sie selbst
% keine EP abdeckt (z. B. "zu werden" mit "gezwungen" in SLASH).
% 230: 8:12 -> 6:47 min CPU, 4177 -> 3068 Kanten, dieselben 10 Sätze.
generator_modifier_island_element_index([cont,ind]).

generator_phrase_selector_required(zu_infinitive,
    [type([synsem,loc,cat,head],verb),type([synsem,loc,cat,head,vform],inf)],
    [synsem,loc,cat,arg_st],
    [type([arg,loc,cat,head],verb),type([arg,loc,cat,head,vform],inf)]).

% Zeige alle morphologischen Formen, die über Lexikoneregeln erzeugt werden.
% In Kapiteln kann Ausgabe von Flexionsmerkmalen konfiguriert werden.
% Pro Kapitel einschalten.
%:- ale_flag(morphoutput,_,paradigm).
:- ale_flag(morphoutput,_,off).


% TDL signature input; TRALE supplies missing least upper bounds.
:- ale_flag(subintro,_,file).

% feature hiding and ordering
% Inspection-only carrier for existing irregular agreement.
hidden_feat(agreement_generator_).
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

head   <<< da.
da     <<< spr.
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



% Tree labels retain their projection information and append SLASH categories.
grale_abbreviation(
    synsem:(not(trace:plus),
            loc:cat:(head:(noun,case:morph_case:Case),
                     spr:[realized:plus],
                     comps:([];[realized:plus])),
            nonloc:slash:Slash),
    ['NP'(Case),suffixes('/',category,Slash)]).

grale_abbreviation(
    synsem:(not(trace:plus),
            loc:cat:(head:(noun,case:morph_case:Case),
                     spr:[realized:minus],
                     comps:([];[realized:plus])),
            nonloc:slash:Slash),
    ['\x0305\N'(Case),suffixes('/',category,Slash)]).

grale_abbreviation(
    synsem:(not(trace:plus),
            loc:cat:(head:(noun,case:morph_case:Case),
                     spr:[realized:minus],
                     comps:[realized:minus]),
            nonloc:slash:Slash),
    ['N'(Case),suffixes('/',category,Slash)]).

grale_abbreviation(
    synsem:(loc:cat:head:(det,case:morph_case:Case),
            nonloc:slash:Slash),
    ['Det'(Case),suffixes('/',category,Slash)]).

grale_abbreviation(
    synsem:(loc:cat:(head:(comp_prep,
                           pform:PForm),
                     comps:[realized:plus]),
            nonloc:slash:Slash),
    ['PP'(PForm),suffixes('/',category,Slash)]).

% abbreviate(Group,Node) reuses a named part for a captured feature value.
% suffixes(Separator,Group,List) appends one abbreviated element at a time.
% For example, a structural nominative NP with the same LOCAL in SLASH is
% displayed as NP[snom]/NP[snom]. Empty SLASH adds nothing; an open tail adds
% /… without closing the list. Unrecognized elements keep the full AVM view.
grale_abbreviation(
    arg:(not((trace:plus,loc:cat:head:noun)),
         loc:Local,nonloc:slash:Slash),
    [abbreviate(category,Local),suffixes('/',category,Slash)]).

% Known NP traces expose their shared LOCAL/SLASH tags directly.
% Other LOCAL labels apply to SLASH elements at their displayed occurrences.
% Opening a sign or spirit exposes SYNSEM.LOC directly. Shared LOCAL values
% keep their original identity. Sharing tags stay collapsed and open directly
% to a full AVM, including tags reached through SLASH.
grale_abbreviation(
    (local,Local),
    at_feature(slash,abbreviate(category,Local))).

% Reusable abbreviations for LOCAL values in arguments and SLASH lists.
grale_abbreviation_part(category,
    cat:head:det,
    'Det').

grale_abbreviation_part(category,
    cat:head:part,
    'Part').

grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:str,
                           morph_case:nom)),
    'NP'(snom)).

grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:str,
                           morph_case:gen)),
    'NP'(sgen)).
    
grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:str,
                           morph_case:acc)),
    'NP'(sacc)).

grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:lex,
                           morph_case:nom)),
    'NP'(lnom)).

grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:lex,
                           morph_case:gen)),
    'NP'(lgen)).
    
grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:lex,
                           morph_case:dat)),
    'NP'(ldat)).

grale_abbreviation_part(category,
    cat:head:(noun,case:(case_type:lex,
                           morph_case:acc)),
    'NP'(lacc)).

grale_abbreviation_part(category,
    cat:head:(noun,case:case_type:str),
    'NP'(str)).
    
grale_abbreviation_part(category,
    cat:head:(noun,case:morph_case:Case),
    'NP'(Case)).

grale_abbreviation_part(category,
    cat:head:(comp_prep,
              pform:PForm),
    'PP'(PForm)).

grale_abbreviation_part(category,
    cat:head:(verb,dsl:local),
    'VP//V').

grale_abbreviation_part(category,
    cat:head:(verb,dsl:local),
    'V//V').

grale_abbreviation_part(category,
    cat:head:vform:VForm,
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
                     [synsem,loc,cat,da],closed).
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
% Possible nominal hosts for attributive modifiers must admit a determiner.
% This excludes personal pronouns with SPR=[], while including nominalized
% lexical-rule outputs. Only compatibility is tested, without binding sorts.
generator_nominal_host(
    synsem:loc:cat:head:attr_adj_or_attr_participle,
    [synsem,loc,cat,head,mod,loc,cont,ind,sort],
    synsem:loc:cat:(head:noun,spr:ne_list),
    [synsem,loc,cont,ind,sort]).

:- ale_flag(generator_lexical_agreement,_,on).
% Optional generator filters for inflectional agreement.
% This declaration supplies six arguments to generator_lexical_agreement/6;
% it does not itself add a grammatical constraint or instantiate agreement.
% The flag above enables the runtime check after lexical chart initialization.
%
% Arguments 1-3 describe the candidate; arguments 4-6 describe a
% potential nominal host. Paths are relative to the respective lexical sign.
generator_lexical_agreement(
    % 1. Select attributive adjective/participle candidates by their HEAD.
    %    Selecting the sign type attr_adj_infl_lr alone would miss an outer
    %    orthographic LR: "anzulachendes" has sign type complex_word_dtrs.
    synsem:loc:cat:head:attr_adj_or_attr_participle,
    % 2. Read the referential index of the noun described by the modifier's
    %    MOD value. This is a host identifier, NOT an agreement structure.
    [synsem,loc,cat,head,mod,loc,cont,ind],
    % 3. Read that MOD noun's determiner requirement: SPR's first spirit
    %    (HD), its selected SYNSEM (ARG), and that determiner's HEAD.
    %    This contains the syntactic agreement requirements imposed by the
    %    modifier's inflection, including gender, number and case.
    [synsem,loc,cat,head,mod,loc,cat,spr,hd,arg,loc,cat,head],
    % 4. Select potential hosts among nominal lexical chart entries.
    synsem:loc:cat:head:noun,
    % 5. Read the host noun's own referential index. In the shared semantic
    %    context, this must ALREADY be identical to the index from (2).
    %    Mere unifiability does not establish that this noun is the host.
    [synsem,loc,cont,ind],
    % 6. Read the actual noun's determiner HEAD requirement under SPR.
    %    Test its compatibility with (3), including delayed constraints.
    %    These are syntactic requirements, not gender on the semantic index
    %    (important for nouns such as "Mädchen").
    [synsem,loc,cat,spr,hd,arg,loc,cat,head]).
%
% The runtime compares lexical candidates using disjoint semantic coverage
% and a shared input-semantic context. It rejects a modifier only if at least
% one index-identical nominal host is found and ALL such hosts fail the
% agreement check. Compatibility tests are temporary; they do not bind the
% retained chart entries. Missing host/unspecified agreement remains possible.
%
% Example: once (2) identifies the index of "Affe", (3)'s neuter requirement
% for "anzulachendes" conflicts with the masculine requirement read by (6).
% The modifier is excluded; compatible "anzulachende" remains available.
% Limitation: "habendes" already has neuter singular agreement, but its MOD
% index was not linked to the "Affe" index in the chart probe. Thus (5) cannot
% identify that host, and this filter keeps the candidate. Inferring the host
% indirectly from the modifier's semantic context is NOT implemented here.
%
% Why the two candidates differ in this example:
% In the input MRS, gerichtet_auf has ARG2 = x4, the index of affe_rel.
% In "anzulachendes", lexical derivation links this argument to MOD IND,
% so matching gerichtet_auf to the input also identifies the nominal host.
% Modal "haben" contributes müssen_sollen_rel. In this input its ARG1 is x13, the actor, NOT x4. The monkey
% occurs as ARG2 of gerichtet_auf inside the modal's scoped content. Matching
% the modal EP alone therefore does not identify "habendes"'s MOD IND with
% x4. The missing link is host identity, not an undetermined neuter suffix.
%
% Possible additional filter (not implemented by this declaration):
% Even without an identified host, reject a modifier if its syntactic gender
% is incompatible with EVERY possible attributively modifiable nominal host.
% This is a weaker necessary-condition check: one compatible host keeps the
% candidate, without claiming that this host is semantically the right one.
% A cached over-approximation of possible host genders could avoid repeated
% scans. Unknown genders must remain possible. The inventory must also cover
% hosts that can be built later; absence from the current lexical chart alone
% is not sufficient evidence that no host can exist. Use syntactic SPR
% requirements, not semantic index gender, for this check as well.

% Early agreement for overt determiners uses the same read-only runtime.
% The quantifier's ARG0 is shared with SPEC.LOC.CONT.IND. This identifies the
% nominal host in the input context. Agreement comes from that host's
% syntactic SPR requirement, which provides gender, number and case.
% Compare the determiner HEAD with SPR.HD.ARG.LOC.CAT.HEAD under temporary
% unification. Unknown values and hosts remain possible. A candidate is
% removed only when all index-identical lexical nominal hosts conflict.
% Lexical nominalization outputs are included in the initialized inventory.
%
% The full-lexicon initialization probe uses empty_only, a 2048 MiB budget
% and disabled OS memory polling. For "Ein Märchen erzählen muss er dem Kind",
% article candidates fall from 17 to 6, retaining the neuter "ein" entry.
% For "Dem Kind erzählen muss er das Märchen", they fall from 20 to 6.
% Full item 157 paired generation with a fixed 4096 MiB budget reduces the
% chart from 5854 to 5821 edges, retaining all 174 outputs and zero residues.
% CPU time was 362.772 versus 358.437 seconds in this single pair.
% Four small paired controls
% (Märchen, Affe, Mädchen, Frau) retain 1/4/4/4 outputs with fewer chart edges.
% These measurements cover individual examples with the full lexicon.
% Short-input CPU times varied between paired runs.
% Underspecified inflection remains one compatible entry until refined.
generator_lexical_agreement(
    overt_determiner,
    [synsem,loc,cat,head,spec,loc,cont,ind],
    [synsem,loc,cat,head],
    synsem:loc:cat:(head:noun,spr:ne_list),
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
% early checks active and completed candidates, including resumed waits.
% Missing values do not prove violations. Only ground type names/positions
% are cached, never copied semantic indices. Parsing does not call these rules.
%
% The initial-stage order follows observed exclusions per measured check CPU
% in a 25-case Chapter-17 snapshot sample. The generator applies a cheap pass
% before lexical chain support, then rebuilds inventories for the final pass.
% Within each pass, initial exclusions precede support-dependent exclusions.
% Example "Der anzulachende Affe fetzt": chain support ran once instead of
% twice (0.482 s vs 0.922 + 0.111 s CPU), preserving nine outputs/1114 edges.
% Across six paired examples, total CPU was 108.083 vs 109.782 s. Pure rule/
% condition reordering was approximately even across fourteen paired examples.
% Short-run timing varies. These measurements use empty_only, 2048 MiB and
% no OS memory polling. They cover first parses of the selected inputs.
%
% Lexical "gelacht/lachen" still requiring a separate particle cannot realize
% it in a nonfinite phrase. The orthographic LR has already produced separate
% angelacht/anlachen/anzulachen candidates; no intermediate LR input is lost.
generator_candidate_filter(nonfinite_separate_particle,initial,
    [disjoint([synsem,loc,cat,head,vform],fin),
     type([synsem,loc,cat,arg_st,hd,arg,loc,cat,head],part),
     type([synsem,loc,cat,arg_st,hd,realized],minus)]).
%
% Semantically empty auxiliary PPPs (notably "worden") have no covered EP
% for covered_parent_link. For them retain the narrower finite-root
% contract: DA [] blocks further passive embedding, and the continuation
% requires perfect_rel. Independent PPP fragments under @root are retained.
% The modal PPP rule also applies under nonfinite roots.
% DA is declared on CAT. The former CAT.HEAD.DA lookup could not establish
% this test after the DA migration, so the unused "worden" source survived.
% Private Chapter-17 full-vocabulary comparison for
% "Er zwingt ihn, den Aufsatz zu lesen.": 5559 -> 3885 edges, identical 42
% outputs without residues; one CPU pair 570.681 -> 399.778 seconds.
% Both runs also include the private attraction-prefix and early finite
% RAISED-minus trials. This timing is not a measurement of this path fix
% on the live grammar alone.
generator_candidate_filter(empty_auxiliary_participle_needs_perfect,initial,
    [root_type([synsem,loc,cat,head,vform],fin),coverage(empty),
     type([synsem,loc,cat,head,vform],ppp),
     type([synsem,loc,cat,head,aux],plus),
     type([synsem,loc,cat,da],e_list),no_input_type(perfect_rel)]).
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
     type([synsem,loc,cat,da],e_list),
     covered_parent_link(temo,[arg3],modal_rel,[lbl]),
     no_input_type(perfect_rel)]).

% Future werden and AcI sehen select a bare infinitive in this grammar.
% A modal auxiliary PPP needs perfect_rel to continue under either selector.
% DA [] excludes passive embedding, and auxiliary attributive derivation is
% blocked by this grammar. The covered modal label identifies this context.
% Full generation vocabulary, DECL, one local run per example, 13 Nov 2026.
% Adding these two rules retained all outputs and scores from the stored run:
% item 168, 112 outputs, elapsed 21:53 -> 16:43, edges 6441 -> 5953;
% item 279, 138 outputs, elapsed 34:00 -> 20:34, edges 13858 -> 13305.
% The stored comparison and local runs have different concurrent workloads.
generator_candidate_filter(modal_participle_under_future_needs_perfect,initial,
    [type([synsem,loc,cat,head,vform],ppp),
     type([synsem,loc,cat,head,aux],plus),
     type([synsem,loc,cat,da],e_list),
     covered_parent_link(futur_rel,[arg3],modal_rel,[lbl]),
     no_input_type(perfect_rel)]).
generator_candidate_filter(modal_participle_under_seeing_needs_perfect,initial,
    [type([synsem,loc,cat,head,vform],ppp),
     type([synsem,loc,cat,head,aux],plus),
     type([synsem,loc,cat,da],e_list),
     covered_parent_link(sehen_rel,[arg3],modal_rel,[lbl]),
     no_input_type(perfect_rel)]).

% Active finite stems link their own primary ARG1 to the subject index.
% Their full valence can still be open when that index is already specified
% in the input MRS. For example, sehen_rel ARG1 is third/sg in item 279,
% so siehst, seht and plural sehen cannot be the active finite realization.
% The stem type and its first relation establish this subject-link contract.
% These guards do not assume it for arbitrary verbs or secondary relations.
% Test all compatible covered input EPs. An unknown or compatible value
% keeps the candidate, and the test never instantiates the input or affix.
% With the two preceding PPP rules, the same full-vocabulary DECL runs give:
% item 168, elapsed 16:24.630, 5953 edges, all 112 outputs;
% item 279, elapsed 20:13.597, 13293 edges, all 138 outputs.
% Output sets and penalty scores match the stored run exactly, residues 0.
% Single measurements with concurrent work do not isolate a per-rule speedup.
generator_candidate_filter(active_seeing_person_agreement,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([dtr],aci_verb),
     type([dtr,rels,hd],sehen_rel),
     unsupported_covered_value(sehen_rel,[arg1,per],[affix,per])]).
generator_candidate_filter(active_seeing_number_agreement,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([dtr],aci_verb),
     type([dtr,rels,hd],sehen_rel),
     unsupported_covered_value(sehen_rel,[arg1,num],[affix,num])]).
generator_candidate_filter(active_believing_person_agreement,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([dtr],glauben_denken_verb),
     type([dtr,rels,hd],glauben_rel),
     unsupported_covered_value(glauben_rel,[arg1,per],[affix,per])]).
generator_candidate_filter(active_believing_number_agreement,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([dtr],glauben_denken_verb),
     type([dtr,rels,hd],glauben_rel),
     unsupported_covered_value(glauben_rel,[arg1,num],[affix,num])]).

% AcI stems inherit DA [] from raising_verb in this grammar.
% Their PPP cannot be embedded under a passive auxiliary, which requires
% DA [blocked_np_ref]. Ordinary PPP continuation requires perfect_rel.
% Adjectival PPP derivation contributes past_ind. Retain either context.
% The finite-goal guard retains independent PPP fragments under broad roots.
% Retain a nonempty/unknown DA too, so later passive-enabled AcI entries
% are unaffected. This is specific to the current Chapter-17 continuations.
generator_candidate_filter(aci_participle_needs_past_or_perfect,initial,
    [root_type([synsem,loc,cat,head,vform],fin),
     type([synsem,loc,cat,head,vform],ppp),
     type([dtr],aci_verb),
     type([synsem,loc,cat,da],e_list),
     no_input_type(perfect_rel),no_input_type(past_ind)]).
% Item 279, full vocabulary and DECL: with the preceding filters,
% elapsed 2:16.155, 2690 edges, the same 138 outputs and scores,
% residues 0. Previous agreement-only run: 20:14 and 13293 edges.

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
          [head_dtr,synsem,loc,cat,da,hd,arg,loc,cont,ind]),
     no_input_type(lassen_passive_rel)]).
%
%
% Reject a built finite verb-final matrix projection, e.g. "von ihm wird"
% with an extracted PPP, when the chosen finite root requires INITIAL plus.
% The mother INDEX must already be identical to the input MRS INDEX. A merely
% compatible or unknown index does not suffice, so embedded clauses survive.
% PHRASE plus excludes lexical words that can still undergo verb movement.
% DSL none is essential: DSL local verb-trace projections remain necessary
% for valid V2 derivations. Verb movement itself requires PHRASE minus.
% The early stage also checks active candidates and resumed valence waits.
%
% Private current-grammar snapshot, empty_only, 2048 MiB, no OS memory polling.
% "Er liest den Aufsatz": 614 -> 546 edges, the same ten outputs. Two fresh
% runs per mode gave median CPU 9.78 -> 8.83 s. "Er glaubt, dass Aicke schläft":
% 1517 -> 1030 edges, the same sixteen outputs, 34.38 -> 20.76 s CPU.
% All compared outputs were residue-free. Short-input timing varies, including
% an earlier slowdown for lesen. These examples are not a whole-suite result.
% A verb-final finite phrase with the input matrix index cannot reach an
% initially headed finite root in this grammar. Verb movement requires
% PHRASE minus; an already built head-complement phrase has PHRASE plus.
% DSL none distinguishes overt verb heads from verb-trace projections.
% Root identity must already hold. Unknown and embedded indices stay possible.
% INITIAL minus is checked first after the global root guards. Joint-condition
% samples favored this order. In the Affe example it reduced local condition
% calls from 3463 to 2882, with the same twelve matrix-candidate exclusions.
generator_candidate_filter(matrix_verb_final_phrase,early,
    [root_type([synsem,loc,cat,head,vform],fin),
     root_type([synsem,loc,cat,head,initial],plus),
     type([synsem,loc,cat,head,initial],minus),
     type([synsem,phrase],plus),
     type([synsem,loc,cat,head,vform],fin),
     type([synsem,loc,cat,head,dsl],none),
     same_as_input_root([synsem,loc,cont,ind]),
     type([synsem,loc,cat,head],verb)]).
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
% DA is a separate CAT feature. It must accompany a projected VP, otherwise
% without_own_passive_pp waits for an unknown DA and the matrix valence stays
% open. Example: "dass den Aufsatz zu lesen der Mann beginnt" was parseable
% but absent from generation. In a full-lexicon trial restricted to the input
% word forms, sharing DA restores it (2 -> 3 outputs, 222 -> 305 chart edges).
% The benchmark covers this restricted input vocabulary.
% The private attraction-prefix experiment additionally shares its helper
% with the valence shadow. The pending prefix belongs to the same selection
% in the working structure and in its grammatical preview.
generator_valence_wait(
    head_complement_phrase,
    head([synsem,loc,cat,head],participle_or_verb),
    projection([cont],[realized],[cat,head,vform],[[cat,da],[cat,attracted_comps_]])).

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

% Input-context support. Cache ground reference positions, never input AVMs.
% CP matrix filters and nominal/lexical-parent support resolve the private
% timeout controls 52/175/176/178/66 under the 20-minute limit with the regular
% generation vocabulary. These are historical combined-package measurements.
% Integrated source recheck on 2026-11-14, regular generation vocabulary
% Er versucht ihn anzulachen, item 343, 14 outputs and 798 edges, 32.178 s CPU.
% Item 178, 20 outputs and 1687 edges, 122.461 s CPU, 142.147 s elapsed.
% Ein Affe nimmt einen Stock und das Kind lacht, item 69, 42 outputs and
% 1641 edges, 38.934 s CPU. All three retain the checked word sets and
% penalties with zero residues. Runs were concurrent, so elapsed times
% are not isolated timing comparisons. All 44 parse controls agree.
% This package does not establish completion of the remaining timeouts.
% Attribute host labels may be connected by qeq, scopal operators or verbal
% conjunction. Unknown graphs/providers retain candidates. Independent
% attributive roots remain possible when the requested root admits them.
generator_context_reset :-
 retractall(generator_nominal_context_provider_positions(_)),
 retractall(generator_nominal_context_root_disjoint),
 retractall(generator_nominal_context_label_links(_)).
generator_context_start(Input,Tag-_,Nodes) :- generator_nominal_context_graph_start(Input,Tag,Nodes).
generator_context_filter_initial :- generator_nominal_context_safe_start.
generator_context_edge_allowed(Edge) :- generator_nominal_context_edge_allowed(Edge).
generator_nominal_context_label_position(V,FS,Position) :-
 gen_cf_path([synsem,loc,cont,ltop],FS,Label),
 nonvar(V),V=_-Context,nonvar(Context),Context=gen_context(_,Nodes),
 is_list(Nodes),nth1(Position,Nodes,Node),Label==Node,!.
generator_nominal_context_known_nonroot(_,_) :- generator_nominal_context_root_disjoint,!.
generator_nominal_context_known_nonroot(V,FS) :-
 gen_cf_root_index_position(RootPosition),ind_path(Path),gen_cf_path(Path,FS,Index),
 nonvar(V),V=_-Context,nonvar(Context),Context=gen_context(_,Nodes),is_list(Nodes),
 nth1(Position,Nodes,Node),Index==Node,!,Position=\=RootPosition.
generator_nominal_context_safe_start :-
 retractall(generator_nominal_context_provider_positions(_)),retractall(generator_nominal_context_root_disjoint),
 (generator_nominal_context_label_context,
  findall(Status,generator_nominal_context_label_provider(Status),Raw),\+memberchk(unknown,Raw),
  sort(Raw,Providers)
  ->assertz(generator_nominal_context_provider_positions(Providers)),
    (generator_nominal_context_target_disjoint
     ->assertz(generator_nominal_context_root_disjoint);true),
    findall(Ref,(gen_cf_lex(Ref,E),\+generator_nominal_context_edge_allowed(E)),Refs),
    gen_remove_agreement_edges(Refs),length(Refs,N),
    format('{TRALE: Nominal context support excluded ~d lexical entries.}~n',[N]),flush_output
  ;true,flush_output).
generator_nominal_context_target_disjoint :-
 gen_cf_rules(early,Rules),memberchk(cp_matrix_movement-_,Rules),!.
generator_nominal_context_target_disjoint :-
 u_gen_root(Description),add_to(Description,Root),
 gen_cf_value(Root,[synsem,loc,cat,head],RootType),
 \+unify_type(RootType,attr_adj_or_attr_participle,_).
generator_nominal_context_label_provider(Status) :-
 gen_cf_lex(_,edge(V,_,_,FS-_,_,_)),
 gen_cf_possible_types([type([],word),type([synsem,loc,cat,head],noun),type([synsem,loc,cat,spr],ne_list)],FS),
 (generator_nominal_context_label_position(V,FS,Label)
  ->(generator_nominal_context_node_position(V,FS,[synsem,loc,cont,ind],Index)
     ->Status=host(Label,Index);Status=host(Label,unknown))
  ;Status=unknown).
generator_nominal_context_node_position(V,FS,Path,Position) :-
 gen_cf_path(Path,FS,Value),
 nonvar(V),V=_-Context,nonvar(Context),Context=gen_context(_,Nodes),
 is_list(Nodes),nth1(Position,Nodes,Node),Value==Node,!.
generator_nominal_context_missing_host(_,_,[]) :- !.
generator_nominal_context_missing_host(V,FS,Providers) :-
 generator_nominal_context_label_position(V,FS,Label),
 (generator_nominal_context_node_position(V,FS,[synsem,loc,cat,head,mod,loc,cont,ind],I)
  ->Index=known(I);Index=unknown),
 \+ (member(host(HostLabel,HostIndex),Providers),
      generator_nominal_context_index_compatible(Index,HostIndex),
      generator_nominal_context_label_reachable(Label,HostLabel,[])).
generator_nominal_context_edge_allowed(E) :-
 (generator_nominal_context_provider_positions(Providers),
  E=edge(V,_,_,FS-_,_,_),gen_cf_has_type(FS,[synsem,loc,cat,head],attr_adj_or_attr_participle),
  generator_nominal_context_known_nonroot(V,FS),
  generator_nominal_context_missing_host(V,FS,Providers)
  ->gen_cf_rejected(nominal_label_support),fail
  ;true).
generator_nominal_context_graph_start(Input,Tag,Nodes) :-
 retractall(generator_nominal_context_label_links(_)),
 (\+ (member(bitPos(EP-_,_),Input),gen_cf_value(EP,[],Type),unify_type(conjunction_n_rel,Type,_)),
  generator_nominal_context_ep_links(Input,Nodes,EPLinks),
  hcons_path(Path),gen_cf_path(Path,Tag,HCs),
  generator_nominal_context_hcons_links(HCs,Nodes,HCLinks),
  append(EPLinks,HCLinks,All),sort(All,Links)
  ->assertz(generator_nominal_context_label_links(Links));true).
generator_nominal_context_ep_links([],_,[]).
generator_nominal_context_ep_links([bitPos(EP-_,_)|Rest],Nodes,Links) :-
 (gen_cf_has_type(EP,[],arg3_relation)
  ->generator_nominal_context_handle_positions([lbl:handle,arg3:handle],EP,Nodes,Positions)
  ;gen_cf_has_type(EP,[],conjunction_v_rel)
  ->generator_nominal_context_handle_positions([lbl:handle,lhandle:handle,rhandle:handle],EP,Nodes,Positions)
  ;Positions=[]),
 generator_nominal_context_position_links(Positions,Here),
 generator_nominal_context_ep_links(Rest,Nodes,Tail),append(Here,Tail,Links).
generator_nominal_context_handle_positions([],_,_,[]).
generator_nominal_context_handle_positions([F:Declared|Rest],EP,Nodes,Positions) :-
 (sub_type(handle,Declared)
  ->gen_cf_path([F],EP,Value),generator_nominal_context_input_position(Value,Nodes,P),
    Positions=[P|Tail]
  ;Positions=Tail),
 generator_nominal_context_handle_positions(Rest,EP,Nodes,Tail).
generator_nominal_context_input_position(Value,Nodes,P) :-
 nth1(P,Nodes,Node),Value==Node,!.
generator_nominal_context_position_links([],[]).
generator_nominal_context_position_links([P|Rest],Links) :-
 findall(link(P,Q),member(Q,Rest),Here),
 generator_nominal_context_position_links(Rest,Tail),append(Here,Tail,Links).
generator_nominal_context_hcons_links(List,Nodes,Links) :-
 get_type(List,T),T\==0,
 (sub_type(e_list,T)->Links=[]
 ;sub_type(ne_list,T),gen_cf_path([hd],List,HC),
  gen_cf_has_type(HC,[],qeq),
  gen_cf_path([harg],HC,H),gen_cf_path([larg],HC,L),
  generator_nominal_context_input_position(H,Nodes,HP),
  generator_nominal_context_input_position(L,Nodes,LP),
  Links=[link(HP,LP)|Tail],gen_cf_path([tl],List,Rest),
  generator_nominal_context_hcons_links(Rest,Nodes,Tail)).
generator_nominal_context_label_context :- generator_nominal_context_label_links(_).
generator_nominal_context_label_reachable(P,P,_) :- !.
generator_nominal_context_label_reachable(P,Q,Seen) :-
 \+memberchk(P,Seen),generator_nominal_context_label_links(Links),
 (member(link(P,Next),Links);member(link(Next,P),Links)),
 generator_nominal_context_label_reachable(Next,Q,[P|Seen]),!.
generator_nominal_context_index_compatible(unknown,_) :- !.
generator_nominal_context_index_compatible(_,unknown) :- !.
generator_nominal_context_index_compatible(known(I),I).

generator_candidate_filter(cp_matrix_movement,early,
    [root_type([synsem,loc,cat,head],comp),
     root_type([synsem,loc,cat,head,cform],dass),
     type([],verb_movement_rule),
     same_as_input_root([synsem,loc,cont,ind])]).

generator_candidate_filter(cp_matrix_verb_trace,early,
    [root_type([synsem,loc,cat,head],comp),
     root_type([synsem,loc,cat,head,cform],dass),
     type([synsem,loc,cat,head,dsl],local),
     type([synsem,loc,cat,head,vform],fin),
     type([synsem,loc,cat,head],verb),
     same_as_input_root([synsem,loc,cont,ind])]).

generator_candidate_filter(cp_empty_passive_ppp,initial,
    [root_type([synsem,loc,cat,head],comp),
     coverage(empty),
     type([synsem,loc,cat,head,vform],ppp),
     type([synsem,loc,cat,head,aux],plus),
     type([dtr],agentive_passive_aux_verb),
     type([synsem,loc,cat,da],e_list),
     no_input_type(perfect_rel)]).

generator_candidate_filter(second_singular_indicative_support,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([affix,num],sg),
     type([affix,per],second),
     type([affix,temo],ind_conj),
     unsupported(nominal_person_number,[[affix,per],[affix,num]])]).

generator_candidate_filter(plural_indicative_support_without_nominal_coordination,initial,
    [type([synsem,loc,cat,head,vform],fin),
     type([affix,num],pl),
     type([affix,temo],ind_conj),
     no_input_type(conjunction_n_rel),
     unsupported(nominal_person_number,[[affix,per],[affix,num]])]).

% Bare/zu words need lexical parents for finite or retained dass-CP roots.
generator_lexical_parent_required(bse_verb_infl_lr,
 head([synsem,loc,cat,head],participle_or_verb)) :- cp_root_parent_contract.
generator_lexical_parent_required(inf_verb_infl_lr,
 head([synsem,loc,cat,head],participle_or_verb)) :- cp_root_parent_contract.
cp_root_parent_contract :-
 gen_cf_rules(early,Rules),memberchk(cp_matrix_movement-_,Rules).
generator_lexical_parent_required(
 selector([type([synsem,loc,cat,head],verb),type([synsem,loc,cat,head,vform],bse)]),
 head([synsem,loc,cat,head],participle_or_verb)) :- noninfinitival_root_contract.
generator_lexical_parent_required(
 selector([type([synsem,loc,cat,head],verb),type([synsem,loc,cat,head,vform],inf)]),
 head([synsem,loc,cat,head],participle_or_verb)) :- noninfinitival_root_contract.
noninfinitival_root_contract :-
 (gen_candidate_root_type([synsem,loc,cat,head,vform],fin)
  ;cp_root_parent_contract),!.
generator_lexical_parent_required(
 selector([type([synsem,loc,cat,head],verb),type([synsem,loc,cat,head,vform],bse_or_inf)]),
 head([synsem,loc,cat,head],participle_or_verb)) :- noninfinitival_root_contract.


% Necessary-condition filters for existing irregular agreement values.
% Irregular finite entries have no regular AFFIX agreement carrier. Example:
% the phase-2 inventory for item 72 still contains werde/wirst/werdet although
% no compatible first/second-person nominal source is available with Aicke.
% Read the specifications already passed to subj_verb_agreement; do not force
% an unknown subject, realization flag, nominal index, or inflection reading.
% Retain third-person forms: an impersonal or clausal subject can supply 3sg.
% Missing nominal information remains compatible through the existing runtime.
% The combined package passes the documented native counterprobes; no
% independent speedup is attributed to these agreement filters alone.
generator_candidate_filter(irregular_first_person_support,initial,
    [type([],irreg_fin_verb_infl_lr),
     type([agreement_generator_,per],first),
     unsupported(nominal_person_number,
                 [[agreement_generator_,per],[agreement_generator_,num]])]).
generator_candidate_filter(irregular_second_person_support,initial,
    [type([],irreg_fin_verb_infl_lr),
     type([agreement_generator_,per],second),
     unsupported(nominal_person_number,
                 [[agreement_generator_,per],[agreement_generator_,num]])]).

% Irregular counterpart of the existing regular plural support check.
% Irregular finite forms use AGREEMENT_GENERATOR instead of AFFIX. A plural
% finite subject needs a compatible nominal provider unless nominal
% coordination in the input can create a plural subject. Impersonal and
% clause-subject default agreement is 3sg, so this rule never removes it.
% Example: item 72 has only singular nominal referents; werden is still in
% its second-phase inventory after the first/second-person-only filters.
% Unknown nominal providers remain supported; no isolated speed claim.
:- multifile generator_candidate_filter/3.
generator_candidate_filter(irregular_plural_support_without_nominal_coordination,initial,
 [type([],irreg_fin_verb_infl_lr),
  type([agreement_generator_,num],pl),
  no_input_type(conjunction_n_rel),
  unsupported(nominal_person_number,
              [[agreement_generator_,per],[agreement_generator_,num]])]).

% Mutter-Packen (generator4.pl, gen_mother_redundant/2): Eine fertige Kante
% wird nicht gespeichert, wenn eine gespeicherte Kante mit denselben Wörtern
% und derselben Abdeckung ihre Mutter-AVM abdeckt. Ignoriert werden Töchter,
% Hilfsmerkmale, ARG-ST (nur für Kasuszuweisung) und der Inhalt realisierter
% overter Valenzelemente (realisierte Spuren werden verglichen). LP-Beobachtungen
% der gespeicherten Kante gelten für beide (loose). NONLOC wird vollständig
% verglichen, weil ein Füller noch mit SLASH unifizieren muss. Entfernt
% scheinbare Mehrdeutigkeit optional kohärenter Verben (Items 230, 269).
generator_mother_ignore(head_dtr).
generator_mother_ignore(non_head_dtrs).
generator_mother_ignore(dtrs).
generator_mother_ignore(attracted_comps_).
generator_mother_ignore(arg_st).
generator_mother_realized([realized],plus,arg,[arg,trace],minus).
generator_mother_lp(loose).
generator_mother_full([synsem,nonloc]).
% Ein Ergebnis mit denselben Wörtern wie ein früheres Ergebnis bei höchstens
% gleichen Strafpunkten wird nicht noch einmal ausgegeben (generator4.pl,
% gen_result_surface_redundant/2). Das Mutter-Packen kann z. B. bei
% "von ihm den Aufsatz zu lesen gezwungen wird er" nicht greifen: kohärentes
% und inkohärentes Vorfeld unterscheiden sich in SLASH, bis der Füller
% kombiniert ist (Items 182, 232).
generator_unique_surface_results.
