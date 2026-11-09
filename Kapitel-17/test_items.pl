% -*- coding: utf-8; mode: trale-prolog -*-

% ts(Nr, Satz, Root, Parses, Skopuslesarten, Generiert, Kommentar).
% Generiert: erwartete Anzahl pro Parsing-Lesart, z.B. [7] oder [7,7].
% _Generated: noch keine genaue Erwartung festgelegt.

% ts(Nr, Satz, Root, Parses, Skopuslesarten, Generiert, Kommentar),var(Generiert),write(Nr),p_and_g(Satz,Root),order,fail,nl,nl. 

% Beispiele, die Permutationen voneinander sind, muss man nicht erneut testen.
% skip_generator_test([37,43,47,53,54,55,129,130,131,133,135,136]).

% Diese Wortform darf auch durch Lexikonregeln nicht erzeugt werden.
% geschlafene und gegraute existieren jetzt für die Partikelverben. =:-(
unknown_words([geholfene,geregnete,gedurft,gehabte,seiende,wordene]).

% Bei Beispielen mit mehreren Analysen kann man nur von einer bestimmten generieren lassen.
% g enerate_only([[270,1]]).

% Im Skopusfeld kann stehen
% [utool_error(distinct_quantifiers)]
% ts(1, "Beispielsatz.", @decl, 1, [utool_error(distinct_quantifiers)], _Generated, '').
%
% Damit wird genau dieser Utool-Fehler erwartet; der Variablenname `x4` darf abweichen. Andere Fehler, eine falsche Parse-Anzahl oder das Ausbleiben des erwarteten Fehlers bleiben Abweichungen.

% Für mehrere Analysen geht etwa:

% [1, utool_error(distinct_quantifiers)]



ts(2,"Der Affe schläft.",@decl,1,[1],[4],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(3,"der Affe das Kind kennt",@root,1,[],[4],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(4,"der Affe an das Kind denkt",@root,1,[],[4],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(5,"Ihm graut.",@decl,1,[1],[1],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen').
ts(6,"Der Affe graut",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen').
ts(7,"Affe schläft",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen').
ts(8,"der Affe kennt",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(9,"an das Kind schläft",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(10,"an das Kind den Affe kennt",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(11,"Die Tochter des Mannes schläft.",@decl,1,[1],[8],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(12,"die Tochter Mannes",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Komplement-Strukturen, Kopf-Spezifikator-Strukturen').
ts(13,"der kleine Affe",@root,1,[],[4],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Spezifikator-Strukturen, Kopf-Adjunkt-Strukturen').
ts(14,"kleine der Affe",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Spezifikator-Strukturen, Kopf-Adjunkt-Strukturen').
ts(15,"kleine Affe der",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Spezifikator-Strukturen, Kopf-Adjunkt-Strukturen').
ts(16,"Das Eis in der Speisekammer schmilzt.",@decl,1,[1],[1],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Spezifikator-Strukturen, Kopf-Adjunkt-Strukturen').
ts(17,"das Eis in schmilzt",@root,0,[],[],'Kapitel 4: Valenz, Kopfmerkmale, Kopfmerkmalsprinzip, Kopf-Spezifikator-Strukturen, Kopf-Adjunkt-Strukturen').

ts(18,"Jede Tochter eines Mitarbeiters schläft.",@decl,1,[2],[8],'Kapitel 5: Semantik, Skopus').
ts(19,"der mutmaßliche Affe",@root,1,[],[4],'Kapitel 5: Semantik, Skopus').
ts(20,"Sein Affe schläft.",@decl,1,[1],[4],'Kapitel 5: Semantik, Skopus').
ts(21,"Der angeblich kleine Affe schläft.",@decl,1,[1],[4],'Kapitel 5: Semantik, Skopus').
ts(22,"Der Affe schläft wahrscheinlich.",@decl,1,[2],[7],'Kapitel 5: Semantik, Skopus').
ts(23,"Jeder Affe glaubt, dass ein Einhorn schläft.",@decl,1,[3],[36],'Kapitel 5: Semantik, Skopus').
ts(24,"Aicke schläft.",@decl,1,[1],[4],'Kapitel 5: Semantik, Skopus').
ts(25,"Er schläft.",@decl,1,[1],[4],'Kapitel 5: Semantik, Skopus').

ts(26,"Aicke kennt Conny.",@decl,2,[1,1],[10,10],'Kapitel 5: Semantik, Skopus').
ts(27,"Der Affe kennt das Kind.",@decl,1,[1],[10],'Kapitel 5: Semantik, Skopus').
ts(28,"Der Affe kennt ein Kind.",@decl,1,[1],[10],'Kapitel 5: Semantik, Skopus').
ts(29,"Jeder Affe kennt jedes Kind.",@decl,1,[1],[10],'Kapitel 5: Semantik, Skopus').
ts(30,"Ein Kind kennt einen Mann.",@decl,1,[1],[10],'Kapitel 5: Semantik, Skopus').
ts(31,"Jeder Affe kennt ein Kind.",@decl,1,[2],[10],'Kapitel 5: Semantik, Skopus').
ts(32,"Eine Tochter eines Mitarbeiters kennt einen Affen.",@decl,1,[1],[20],'Kapitel 5: Semantik, Skopus').

% Unterspezifikation des Linkings für Satzargument und NP-Argument
ts(33,"Dass der Affe lacht, fetzt.",@decl,1,[1],[2],'Kapitel 5: Semantik, Skopus').
ts(34,"Der Affe fetzt.",@decl,1,[1],[1],'Kapitel 5: Semantik, Skopus').

ts(35,"das Eis der Speisekammer in",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(36,"dass das Kind dem Affen den Stock gibt",@root,1,[],[18],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(37,"dass das Kind den Stock dem Affen gibt",@root,1,[],[18],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(38,"Schläft er?",@interrog,1,[1],[6],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(39,"Lacht das Kind oft?",@interrog,1,[1],[11],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(40,"Lacht das Kind oft nicht?",@interrog,1,[2],[20],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(41,"Lacht das Kind nicht oft?",@interrog,1,[2],[20],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(42,"Kennt ein Kind den Roman?",@interrog,1,[1],[14],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(43,"Kennt den Roman ein Kind?",@interrog,1,[1],[14],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(44,"Aicke schläft schläft.",@decl,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(45,"Den Roman kennt und schläft er",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(46,"Kennt und liebt das Kind den Roman?",@interrog,1,[1],[13],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(47,"Kennt und liebt den Roman das Kind?",@interrog,1,[1],[13],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(48,"Kennt sie den Film und den Roman?",@interrog,1,[1],[14],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
% Grammatiken mit zyklischer Spur lassen Folgendes zu:
% Koordination eines Verbletztverbs als Verbspur mit [den Stock _]
% Valenz der beiden Konjunkte muss gleich sein. Verb muss lexikalisch sein, weil sonst DSL zu none werden würde.
ts(49,"Kennt der Affe lacht und den Stock?",@interrog,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
% parallel
ts(50,"Gibt der Affe lacht und dem Kind den Stock?",@interrog,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').

% Spielt das Kind [spielt und lacht]. mit [spielt und lacht] statt Spur.
ts(51,"Spielt das Kind spielt und lacht",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').

% 12.10.2026
% Generation: 3432.569 s CPU time.
% Chart: 19876 edges (4790 active, 15086 inactive).
ts(52,"dass das Kind dem Affen den Stock morgen gibt",@root,1,[],[72],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(53,"dass das Kind dem Affen morgen den Stock gibt",@root,1,[],[72],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(54,"dass das Kind morgen dem Affen den Stock gibt",@root,1,[],[72],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(55,"dass morgen das Kind dem Affen den Stock gibt",@root,1,[],[72],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(56,"Mann der",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(57,"der Speisekammer in",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(58,"das Kind kluge",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(59,"die in der Speisekammer Wurst",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(60,"dass Aicke den Stock gibt ihm",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').
ts(61,"dass das Kind den Roman",@root,0,[],[],'Kapitel 8: Argument- und Adjunktstellung im Mittelfeld und Verbbewegung').

ts(62,"Den Roman kennt er.",@decl,1,[1],[10],'Kapitel 9: Vorfeldbesetzung').
ts(63,"Er lacht oft.",@decl,1,[1],[7],'Kapitel 9: Vorfeldbesetzung').
ts(64,"Oft lacht er.",@decl,1,[1],[7],'Kapitel 9: Vorfeldbesetzung').
ts(65,"Oft lacht er nicht.",@decl,2,[1,1],[14,14],'Kapitel 9: Vorfeldbesetzung').

% 
% Generated phrases: 191.
% Generation: 2007.529 s CPU time.
% Chart: 95476 edges (21599 active, 73877 inactive).

ts(66,"Oft gibt er nicht dem Affen den Stock.",@decl,2,[4,4],[191,191],'Kapitel 9: Vorfeldbesetzung').
% Vorfeld kann nur einmal besetzt werden
ts(67,"Er den Stock gibt dem Affen.",@decl,0,[],[],'Kapitel 9: Vorfeldbesetzung').
% Nur eine Lesart: [den Stock _i und lacht] muss ausgeschlossen werden.
ts(68,"Der Affe nimmt den Stock und lacht.",@decl,1,[1],[8],'Kapitel 9: Vorfeldbesetzung').
% Satztyp:
ts(69,"Ein Affe nimmt einen Stock und das Kind lacht.",@decl,1,[1],_Generated,'Kapitel 9: Vorfeldbesetzung').
% Klaus ist ein Idiot und warum merkt das außer mir niemand?

ts(70,"Ein Affe nimmt einen Stock und lacht das Kind",@root,0,[],[],'Kapitel 9: Vorfeldbesetzung').


% Extraktion ist nicht Across-the-board (ATB)
ts(71,"Dem Mann glaube ich, dass er ein Buch gibt und ein Märchen erzählt.",@decl,1,[8],_Generated,'Kapitel 9: Vorfeldbesetzung').
% Extraktion ist ATB
ts(72,"Dem Mann glaube ich, dass er ein Buch gibt und dass er ein Märchen erzählt.",@decl,1,[8],_Generated,'Kapitel 9: Vorfeldbesetzung').

ts(73,"Der Affe, der schläft, kennt das Kind.",@decl,1,[1],[30],'Kapitel 10: Relativsätze').
ts(74,"die Speisekammer, in der er schläft",@root,1,[],[4],'Kapitel 10: Relativsätze').
% Relativsatz als Prämodifier
ts(75,"der, der schläft, Affe",@root,0,[],[],'Kapitel 10: Relativsätze').
% Relativphrase nach dem finiten Satz
ts(76,"Der Affe, schläft der, kennt das Kind.",@decl,0,[],[],'Kapitel 10: Relativsätze').
% komplexe Relativphrase mit Relativwort in der postnominalen PP.
ts(77,"die Speisekammer, der Affe in der schläft",@root,0,[],[],'Kapitel 10: Relativsätze').
ts(78,"Ein Affe, dessen Kind schläft, lacht.",@decl,1,[1],[8],'Kapitel 10: Relativsätze').
% Wenn REL nicht nach oben gereicht wird, kann "der Affe" einfach als Relativphrase verwendet werden.
ts(79,"Der Affe, der Affe schläft, lacht",@root,0,[],[],'Kapitel 10: Relativsätze').
% Relativsatz mit Verbspur statt mit overtem Verb
ts(80,"Der Affe, der den Stock, lacht",@root,0,[],[],'Kapitel 10: Relativsätze').
ts(81,"Der Affe, dessen Stock und dessen Roman ich kenne, schläft.",@decl,1,[1],[8],'Kapitel 10: Relativsätze').
ts(82,"Der Affe, von dessen Kind er ein Bild malt, lacht.",@decl,1,[1],[16],'Kapitel 10: Relativsätze').

ts(83,"Der Affe, ein Bild von dessen Kind er malt, lacht.",@root,0,[],[],'Kapitel 10: Relativsätze').
ts(84,"Der Affe, ein Bild dessen Kindes er malt, lacht.",@root,0,[],[],'Kapitel 10: Relativsätze').
ts(85,"Der Affe, dessen Kind er ein Bild von malt, lacht.",@root,0,[],[],'Kapitel 10: Relativsätze').
ts(86,"Der Affe, dessen Kindes er ein Bild malt, lacht.",@root,0,[],[],'Kapitel 10: Relativsätze').


ts(87,"Ich schlafe.",@decl,1,[1],[7],'Kapitel 12: Kongruenz').
ts(88,"Du schläfst.",@decl,1,[1],[4],'Kapitel 12: Kongruenz').
% Ist schon oben bei 24 dabei.
%ts(89,"Er schläft.",@decl,1,[1],_Generated,'Kapitel 12: Kongruenz').
ts(90,"Er schläfst.",@decl,0,[],[],'Kapitel 12: Kongruenz').
ts(91,"die Männern",@root,0,[],[],'Kapitel 12: Kongruenz').

ts(92,"der kluge  Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(93,"des klugen Mannes",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(94,"dem klugen Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(95,"den klugen Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').

ts(96,"die klugen Männer", @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(97,"der klugen Männer", @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(98,"den klugen Männern",@root,1,[],[3],'Kapitel 12: Kongruenz').

ts(99,"das kluge  Kind",  @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(100,"des klugen Kindes",@root,1,[],[3],'Kapitel 12: Kongruenz').
ts(101,"dem klugen Kind",  @root,1,[],[3],'Kapitel 12: Kongruenz').

ts(102,"die klugen Kinder", @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(103,"der klugen Kinder", @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(104,"den klugen Kindern",@root,1,[],[3],'Kapitel 12: Kongruenz').

ts(105,"die kluge  Frau",@root,1,[],[2],'Kapitel 12: Kongruenz').
ts(106,"der klugen Frau",@root,1,[],[2],'Kapitel 12: Kongruenz').

ts(107,"die klugen Frauen",@root,1,[],[3],'Kapitel 12: Kongruenz').
ts(108,"der klugen Frauen",@root,1,[],[3],'Kapitel 12: Kongruenz').
ts(109,"den klugen Frauen",@root,1,[],[3],'Kapitel 12: Kongruenz').

ts(110,"ein   kluger Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(111,"eines klugen Mannes",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(112,"einem klugen Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(113,"einen klugen Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').

ts(114,"ein   kluges Kind",  @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(115,"eines klugen Kindes",@root,1,[],[3],'Kapitel 12: Kongruenz').
ts(116,"einem klugen Kind",  @root,1,[],[3],'Kapitel 12: Kongruenz').

ts(117,"eine  kluge  Frau",@root,1,[],[2],'Kapitel 12: Kongruenz').
ts(118,"einer klugen Frau",@root,1,[],[2],'Kapitel 12: Kongruenz').

ts(119,"seine  kluge  Frau",@root,1,[],[2],'Kapitel 12: Kongruenz').
ts(120,"seiner klugen Frau",@root,1,[],[2],'Kapitel 12: Kongruenz').

ts(121,"sein   kluger Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(122,"seines klugen Mannes",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(123,"seinem klugen Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(124,"seinen klugen Mann",  @root,1,[],[4],'Kapitel 12: Kongruenz').

ts(125,"sein   kluges Kind",  @root,1,[],[3],'Kapitel 12: Kongruenz').
ts(126,"seines klugen Kindes",@root,1,[],[3],'Kapitel 12: Kongruenz').
ts(127,"seinem klugen Kind",  @root,1,[],[3],'Kapitel 12: Kongruenz').

ts(128,"ein   kluger Beamter",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(129,"eines klugen Beamten",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(130,"einem klugen Beamten",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(131,"einen klugen Beamten",@root,1,[],[4],'Kapitel 12: Kongruenz').

ts(132,"eine  kluge  Beamte", @root,1,[],[2],'Kapitel 12: Kongruenz').
ts(133,"einer klugen Beamten",@root,1,[],[2],'Kapitel 12: Kongruenz').

ts(134,"der kluge  Beamte", @root,1,[],[4],'Kapitel 12: Kongruenz').
ts(135,"des klugen Beamten",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(136,"dem klugen Beamten",@root,1,[],[4],'Kapitel 12: Kongruenz').
ts(137,"den klugen Beamten",@root,2,[],[3,4],'Kapitel 12: Kongruenz').

ts(138,"die kluge  Beamte", @root,1,[],[2],'Kapitel 12: Kongruenz').
ts(139,"der klugen Beamten",@root,2,[],[3,2],'Kapitel 12: Kongruenz').

ts(140,"Die kleinen Kinder schlafen.",@decl,1,[1],[7],'Kapitel 12: Kongruenz').
ts(141,"Kleine Kinder schlafen.",@decl,1,[1],[7],'Kapitel 12: Kongruenz').
ts(142,"Die kleine Kinder schlafen.",@decl,0,[],[],'Kapitel 12: Kongruenz').
ts(143,"Kleinen Kinder schlafen.",@decl,0,[],[],'Kapitel 12: Kongruenz').

% Kongruenz bei nominalem Argument von fetzen.
ts(144,"Ich fetze.",@decl,1,[1],[1],'Kapitel 12: Kongruenz').
ts(145,"Du  fetzt.",@decl,1,[1],[1],'Kapitel 12: Kongruenz').

%t(125,"Er arbeitet der ganze Tag.", @decl,0,'Kapitel 13: Kasus').
%t(126,"weil der ganze Tag gearbeitet wurde."@decl,0,'Kapitel 13: Kasus').

%ts(146,"Dass Aicke lacht, freut mich.",@decl,1,[],'Kapitel 13: Kasus').
%ts(147,"Dass Aicke lacht, freut er.",  @root,0,[],'Kapitel 13: Kasus').



% Verbalkomplexe
% Wenn man die Modalverben als einstellige Kontrollverben statt als Anhebungsverben
% analysiert, bekommt man weniger Passivvarianten bei der Generiereung.
% Es gibt allerdings auch die Anhebungsvarainten: "Das will bewiesen werden." "Es kann regnen."
% Vielleicht so wie bei den Lesarten der modalen Infinitive über Kollokationsimplikationen regeln.
% 07.11.2026
ts(148,"dass er lachen wird",@root,1,[],[2],'Kapitel 14: Verbalkomplex').
ts(149,"dass lachen er wird",@root,0,[],[],'Kapitel 14: Verbalkomplex').
ts(150,"dass er den Aufsatz lesen wird",@root,1,[],[4],'Kapitel 14: Verbalkomplex').
ts(151,"dass lesen er den Aufsatz wird",@root,0,[],[],'Kapitel 14: Verbalkomplex').
ts(152,"dass er lesen den Aufsatz wird",@root,0,[],[],'Kapitel 14: Verbalkomplex').
ts(153,"Er wird den Aufsatz lesen dürfen.",@decl,1,[1],[22],'Kapitel 14: Verbalkomplex').
ts(154,"Er wird lachen können wollen.",@decl,1,[1],[4],'Kapitel 14: Verbalkomplex').

% Partial Verb Phrase Fronting
ts(155,"Lachen muss er.",@decl,1,[1],[17],'Kapitel 14: Verbalkomplex + PVP').

ts(156,"Dem Kind erzählen muss er das Märchen.",  @decl,1,[1],[66],'Kapitel 14: Verbalkomplex + PVP').
ts(157,"Ein Märchen erzählen muss er dem Kind.",  @decl,1,[1],[66],'Kapitel 14: Verbalkomplex + PVP').

% 30 Minuten 21.10.2026 Chart: 10491 edges (2963 active, 7528 inactive).
% mit modalen Infinitiven.
ts(158,"Ein Märchen erzählen wird er ihm müssen.",@decl,1,[1],[86],'Kapitel 14: Verbalkomplex + PVP').
ts(159,"Müssen wird er ihm ein Märchen erzählen.",@decl,0,[], [],'Kapitel 14: Verbalkomplex + PVP').

% Oberfeldumstellung z.T. mit Ersatzinfinitiv
ts(160,"dass Aicke den Roman wird lesen dürfen",@root,1,[],[8],'Kapitel 14: Verbalkomplex + PVP').
ts(161,"dass Aicke den Roman lesen dürfen wird",@root,1,[],[8],'Kapitel 14: Verbalkomplex + PVP').

ts(162,"dass Aicke den Roman hat lesen dürfen",@root,1,[],[4],'Kapitel 14: Verbalkomplex + PVP').
ts(163,"dass Aicke den Roman lesen dürfen hat",@root,0,[],[],'Kapitel 14: Verbalkomplex + PVP').
ts(164,"dass Aicke den Roman hat lesen gedurft",@root,0,[],[],'Kapitel 14: Verbalkomplex + PVP').

ts(165,"dass Aicke den Roman wird haben lesen dürfen",@root,1,[],[4],'Kapitel 14: Verbalkomplex + PVP').

% Einbettung von geschlafen werden unter wollen.
ts(166,"Aicke wird haben schlafen wollen.",@decl,1,[1],[3],'Kapitel 14: Verbalkomplex + Oberfeldumstellung').

ts(167,"Schlafen wollen wird Aicke haben.",@decl,1,[1],[3],'Kapitel 14: Verbalkomplex + Oberfeldumstellung').

% Das hat zwei Lesarten, wenn man eine FLIP+-Spur erlaubt. Dann kann wird vor der Extraktionsspur stehen.
ts(168,"Einen Aufsatz lesen müssen, glaubt er, dass Aicke wird.",@decl,1,[4],_Generated,'Kapitel 14: Verbalkomplex + Oberfeldumstellung').

% scheinbar mehrfache Vorfeldbesetzung uncomment loding :- ['mehrfache-vorfeldbesetzung']. in theory.pl
% t(143,"Der Frau das Buch gibt er nicht.",@decl,1,'Kapitel 14: Merhfache Vorfeldbesetzung').
% t(144,"Der Frau den Aufsatz will er geben.",@decl,1,'Kapitel 14: Merhfache Vorfeldbesetzung').
% t(145,"Der Frau der Aufsatz gibt er.",@root,0,'Kapitel 14: Merhfache Vorfeldbesetzung').
% t(146,"Der Frau der Aufsatz will er geben.",@root,0,'Kapitel 14: Merhfache Vorfeldbesetzung').

ts(169,"dass er ihn zu lesen scheint",@root,1,[],[4],'Kapitel 15: Anhebung und Kontrolle').
ts(170,"dass ihm zu grauen scheint",@root,1,[],[1],'Kapitel 15: Anhebung und Kontrolle').

% Phasenverben brauchen kein Subjekt.
ts(171,"dass ihm zu grauen beginnt",@root,1,[],[1],'Kapitel 15: Anhebung und Kontrolle').
ts(172,"dass es zu regnen beginnt",@root,1,[],[1],'Kapitel 15: Anhebung und Kontrolle').


% inkohärente Konstruktion
% Leider sind hier auch Passiveinbettungen möglich, weil Phasenverben kein Subjekt brauchen.
% weil es zu regnen beginnt / weil ihm vor der Prüfung zu grauen beginnt
% Damit kommt dann Folgendes raus:
%
% dass der aufsatz von dem mann gelesen zu werden beginnt
%
ts(173,"dass den Aufsatz zu lesen der Mann beginnt",@root,1,[],[6],'Kapitel 15: Anhebung und Kontrolle').
ts(174,"dass den Aufsatz zu lesen der Mann versuchte",@root,1,[],[7],'Kapitel 15: Anhebung und Kontrolle').
ts(175,"dass den Aufsatz zu lesen der Mann dem Affen versprach",@root,1,[],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(176,"dass den Aufsatz zu lesen der Mann den Affen zwingt",@root,1,[],_Generated,'Kapitel 15: Anhebung und Kontrolle').




% nur eine Lesart
ts(177,"dass der Mann den Aufsatz zu lesen beginnt",@root,1,[],[6],'Kapitel 15: Anhebung und Kontrolle').
ts(178,"dass der Mann den Aufsatz zu lesen morgen beginnt",@root,1,[],[10],'Kapitel 15: Anhebung und Kontrolle').

% Leider auch mit Passiv: Er sieht von dem Affen geschalfen werden. Wenn man sehen ohne Subjekt zulässt:
% Er sieht ihm schlecht werden.
% Dann kann man unpersönliches Passiv unter sehen nicht ausschließen.
% Er sieht das Buch gelesen werden.
ts(179,"Er sieht den Affen schlafen.",@decl,1,[1],[12],'Kapitel 15: Anhebung und Kontrolle').
ts(180,"Er versucht, den Aufsatz zu lesen.",@decl,1,[1],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(181,"Er verspricht ihm, den Aufsatz zu lesen.",@decl,1,[1],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(182,"Er zwingt ihn, den Aufsatz zu lesen.",@decl,1,[1],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(183,"dass ihn der Mann zu lesen versucht",@root,1,[],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(184,"dass ihn zu lesen der Mann versucht",@root,1,[],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(185,"dass er ihn den Aufsatz lesen sah",@root,1,[],_Generated,'Kapitel 15: Anhebung und Kontrolle').

ts(186,"Zu lachen beginnt er.",@decl,1,[1],_Generated,'Kapitel 15: Anhebung und Kontrolle').
ts(187,"Den Aufsatz zu lesen beginnt er.",@decl,1,[1],_Generated,'Kapitel 15: Anhebung und Kontrolle').



% Langer Satz
% der mann, der den affen, der lacht, kennt, gibt der tochter eines mitarbeiters ein Buch, das jeder mitarbeiter einer frau, die den roman lesen wird, geben wird.

ts(188,"Der Affe wurde gemalt.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(189,"Der Affe wurde von dem Kind gemalt.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(190,"Der Affe ist von dem Kind gemalt worden.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(191,"Der Affe hat von dem Kind gemalt worden.",@root,0,[],[],'Kapitel 16: Passiv').
ts(192,"Mir wird geholfen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(193,"Mir wird von der Frau geholfen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(194,"Der Aufsatz wird mir geschenkt.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(195,"Der Aufsatz wird mir von ihm geschenkt.",@decl,1,[1],_Generated,'Kapitel 16: Passiv').
ts(196,"Er wird geschlafen.",@root,0,[],[],'Kapitel 16: Passiv').
ts(197,"Mich wird geholfen.",@root,0,[],[],'Kapitel 16: Passiv').
ts(198,"Dir wirst geholfen.",@root,0,[],[],'Kapitel 16: Passiv').
ts(199,"Heute wurde geregnet.",@root,0,[],[],'Kapitel 16: Passiv').
ts(200,"Wird gearbeitet?",@interrog,1,[1],_Generated,'Kapitel 16: Passiv').
ts(201,"Wird geregnet?",@interrog,0,[],[],'Kapitel 16: Passiv').
ts(202,"Er wurde schlafen.",@decl,0,[],[],'Kapitel 16: Passiv').
ts(203,"Wird gestorben gewesen?",@interrog,0,[],[],'Kapitel 16: Passiv').
ts(204,"dass der Aufsatz zu lesen gezwungen worden wird.",@decl,0,[],[],'Kapitel 16: Passiv').
ts(205,"Mir wird geschlagen.",@decl,0,[],[],'Kapitel 16: Passiv + Kasus').
ts(206,"Mir werde geschlagen.",@decl,0,[],[],'Kapitel 16: Passiv + Kasus').
ts(207,"Der Frau wird gegraut.",@decl,0,[],[],'Kapitel 16: Passiv + subjektloses Prädikat').
ts(208,"Heute wird gegraut.",@decl,0,[],[],'Kapitel 16: Passiv + subjektloses Prädikat').
ts(209,"Gelacht wurde.",@decl,1,[1],[5],'Kapitel 16: Passiv + subjektloses Prädikat').
ts(210,"Gearbeitet wird von dem Affen.",@decl,1,[1],[4],'Kapitel 16: Passiv + subjektloses Prädikat').


ts(211,"der geliebte Mann",@root,1,[],_Generated,'Partizip + Passiv + attributiv').
ts(212,"die von ihrem Mann geliebte Frau",@root,1,[],_Generated,'Partizip + Passiv + attributiv').
ts(213,"der geschlafene Mann",@root,0,[],[],'Partizip + Passiv + attributiv').

ts(214,"der geholfene Mann",@root,0,[],[],'Partizip + Passiv + attributiv').
ts(215,"der gegraute Mann",@root,0,[],[],'Partizip + Passiv + attributiv + subjektloses Prädikat').
ts(216,"der gestorbene Mann",@root,1,[],_Generated,'Partizip + Passiv + attributiv + unakkusativ').
ts(217,"der geregnete Mann",@root,0,[],[],'Partizip + Passiv + attributiv + Wetterverb').
ts(218,"der ihm gelungene Aufsatz",@root,1,[],_Generated,'Partizip + Passiv + attributiv + unakkusativ').
ts(219,"der von ihm gestorbene Mann",@root,0,[],[],'Partizip + Passiv + attributiv + unakkusativ').
ts(220,"der von ihm ihm gelungene Aufsatz",@root,0,[],[],'Partizip + Passiv + attributiv + unakkusativ').

ts(221,"Der arbeitende Mann lacht.",@decl,1,[1],_Gen,'Partizip + Passiv + attributiv').
ts(222,"der von dem Mann arbeitende Mann",@root,0,[],[],'Partizip + Passiv + attributiv').

ts(223,"der das Buch gelesen gehabte Mann",@root,0,[],[],'Partizip + Passiv + attributiv').

% Nur dialektal
ts(224,"Der Mann hat das Buch gelesen gehabt.",@root,0,[],[],'Partizip + Perfekt').

ts(225,"das das Buch zu lesen gehabte Kind",@root,0,[],[],'Partizip + Perfekt').

ts(226,"Der Affe ist gestorben gewesen.",@root,0,[],[],'Partizip + Perfekt').
ts(227,"der gestorben gewesene Affe",@root,0,[],[],'Partizip + Perfekt').

ts(228,"Der Affe hat geschlafen gehabt",@root,0,[],[],'Partizip + Perfekt').

ts(229,"der das Buch gelesen gehabte Affe",@root,0,[],[],'Partizip + Perfekt').

ts(230,"Das den Roman zu lesen den Mann zu zwingen versprechende Kind lacht.",@decl,1,[1],_Gen,'Partizip + Perfekt').

% Hierfür muss die Lexikonregel für die Partizipbildung so gemacht werden, dass auch NP[str], die
% nicht vorn stehen, als Subjekt fungieren können, denn der Dativ von versprechen steht vor dem Akkusativ von "lesen".

%ts(231,"Der von mir dem Mann zu lesen versprochene Aufsatz fetzt.",@decl,1,[1],_Gen,'Partizip + Perfekt').

ts(232,"Er bekommt den Aufsatz zu lesen versprochen.",@decl,1,[1],_Gen,'Partizip + Perfekt').

% optional kohärent Ausschluss unechter Mehrdeutigkeiten
ts(233,"Von ihm wurde zu lachen versucht.",@decl,1,[1],[6],'Passiv + optionale Kohärenz').



ts(234,"dass er dem Mann haben wird",@root,0,[],[],'Partizip + Passiv + attributiv + unakkusativ').
ts(235,"Der Affe lässt den Mann den Kran reparieren.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + lassen-Passiv').
ts(236,"Der Affe lässt den Kran reparieren.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + lassen-Passiv').
ts(237,"Der Affe lässt den Kran von einem Mann reparieren.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + lassen-Passiv').
ts(238,"Der Affe lässt dem Mann helfen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + lassen-Passiv').
ts(239,"Der Affe lässt arbeiten.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + lassen-Passiv').
ts(240,"Er lässt von ihm dem Mann gelingen.",@decl,0,[],[],'Kapitel 16: Passiv + lassen-Passiv').
ts(241,"Er lässt sterben.",@decl,0,[],[],'Kapitel 16: Passiv + lassen-Passiv').
ts(242,"Er lässt von ihm sterben.",@decl,0,[],[],'Kapitel 16: Passiv + lassen-Passiv').
ts(243,"Der Affe bekommt den Aufsatz geschenkt.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + bekommen-Passiv').
ts(244,"Der Affe bekommt von mir den Aufsatz geschenkt.",@decl,1,[1],[54],'Kapitel 16: Passiv + bekommen-Passiv').
ts(245,"Der Affe hat den Aufsatz geschenkt bekommen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + bekommen-Passiv').
ts(246,"Der Affe wird den Aufsatz geschenkt bekommen haben.",@decl,1,[1],[57],'Kapitel 16: Passiv + bekommen-Passiv').
ts(247,"Das Buch ist ihm geschenkt bekommen worden.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(248,"Das Buch ist er geschenkt bekommen worden.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(249,"Das Buch wird geschenkt bekommen.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(250,"Er ist das Buch geschenkt bekommen.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(251,"Du bekommst gelungen.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(252,"Du bekommst von ihm gelungen.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(253,"Er bekommt ein Buch geschenkt bekommen.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').
ts(254,"dass widersprochen bekam.",@decl,0,[],[],'Kapitel 16: Passiv + bekommen-Passiv').

ts(255,"Er ist geschlagen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Zustandspassiv').
ts(256,"Ist genug gearbeitet?",@interrog,1,[1],_Generated,'Kapitel 16: Passiv + Zustandspassiv').
ts(257,"Dem Mann ist geholfen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Zustandspassiv').
ts(258,"Der Kran wird repariert sein.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Zustandspassiv').
ts(259,"Der Kran ist repariert gewesen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Zustandspassiv').
ts(260,"Ist heute geregnet?",@interrog,0,[],[],'Kapitel 16: Passiv + Zustandspassiv').
ts(261,"Ich bin geholfen.",@decl,0,[],[],'Kapitel 16: Passiv + Zustandspassiv').
ts(262,"Der Kran hat repariert zu sein.",@decl,1,[1],[15],'Kapitel 16: Passiv + Zustandspassiv + modaler Infinitiv').
ts(263,"dass der Kran zu reparieren versucht wurde",@root,1,[],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(264,"Zu reparieren versucht wurde der Kran.",@decl,1,[1],[22],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(265,"Den Kran zu reparieren wurde versucht.",@decl,1,[1],[22],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(266,"dass den Kran zu reparieren versucht wurde",@root,1,[],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(267,"Der Kran wurde zu reparieren versucht.",@decl,1,[1],[22],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(268,"Den Kran wurde zu reparieren versucht.",@decl,1,[1],[22],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(269,"Ist der Kran zu reparieren versucht worden?",@interrog,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(270,"Ein Aufsatz wurde ihm zu lesen erlaubt.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus').
ts(271,"Zu reparieren versucht wurde der Kran.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus + PVP').
ts(272,"Zu reparieren versucht wurde den Kran.",@decl,0,[],[],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus + PVP').
ts(273,"Der Aufsatz gelesen wurde.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus + PVP').
ts(274,"Den Aufsatz gelesen hat er.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus + PVP').
ts(275,"Den Aufsatz gelesen wurde.",@decl,0,[],[],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus + PVP').
ts(276,"Der Aufsatz gelesen hat er.",@decl,0,[],[],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kasus + PVP').
ts(277,"Die Aufsätze gelesen wurden.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kongruenz + PVP').
ts(278,"Die Aufsätze gelesen wurde.",@decl,0,[],[],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kongruenz + PVP').
ts(279,"Den Aufsatz lesen sieht er ihn müssen.",@decl,1,[1],_Generated,'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kongruenz + PVP').
ts(280,"Der Aufsatz lesen sieht er ihn müssen.",@decl,0,[],[],'Kapitel 16: Passiv + Fernpassiv + Kohärenz + Kongruenz + PVP').
ts(281,"Das Buch ist zu lesen.",@decl,1,[1],_Generated,'Kapitel 17: modaler Infinitiv + sein').
ts(282,"Dem Mann ist zu helfen.",@decl,1,[1],_Generated,'Kapitel 17: modaler Infinitiv + sein').
ts(283,"Dem Mann scheint nicht zu helfen zu sein.",@decl,3,[4,4,4],[8,8,8],'Kapitel 17: modaler Infinitiv + sein').
ts(284,"Die Frau ist ihm zu helfen.",@decl,0,[],[],'Kapitel 17: modaler Infinitiv + sein').
ts(285,"Die Frau ist das Buch zu lesen.",@decl,0,[],[],'Kapitel 17: modaler Infinitiv + sein').

% Wenn die Bedeutung für modales Sein vom Verb abhängt, dann muss das auch für das Partizip so sein.
% Aicke kennt den Aufsatz, der zu lesen ist.
ts(286,"Aicke kennt den zu lesenden Aufsatz.",@decl,1,[1],[40],'Kapitel 17: modaler Infinitiv + attributiv').
ts(287,"Aicke kennt den von ihm zu lesenden Aufsatz.",@decl,1,[1],[20],'Kapitel 17: modaler Infinitiv + attributiv').
ts(288,"der das Buch zu lesende Mann",@root,0,[],[],'Kapitel 17: modaler Infinitiv + attributiv').
ts(289,"der zu lesen zu habende Roman",@root,0,[],[],'Kapitel 17: modaler Infinitiv + attributiv').
ts(290,"der erzählt zu bekommende Roman",@root,0,[],[],'Kapitel 17: modaler Infinitiv + attributiv').
ts(291,"Der den Aufsatz lesende Affe lacht.",@decl,1,[1],_Generated,'Kapitel 17: modaler Infinitiv + attributiv').
ts(292,"Er hat den Aufsatz zu lesen.",@decl,1,[1],[24],'Kapitel 17: modaler Infinitiv + haben').
ts(293,"Der Mann hat ihm zu helfen.",@decl,1,[1],[46],'Kapitel 17: modaler Infinitiv + haben').
ts(294,"Der Frau hat zu helfen.",@decl,0,[],[],'Kapitel 17: modaler Infinitiv + haben').
ts(295,"Dem Mann hat zu grauen.",@decl,1,[1],[3],'Kapitel 17: modaler Infinitiv + haben + subjektloses Prädikat').
ts(296,"Der Aufsatz hat gelesen zu werden.",@decl,1,[1],[31],'Kapitel 17: modaler Infinitiv + haben + Passiv').
ts(297,"Das Buch wird zu lesen gehabt.",@decl,0,[],[],'Kapitel 17: modaler Infinitiv + haben + Passiv').
ts(298,"Ihm hat geholfen zu werden.",@decl,1,[1],[13],'Kapitel 17: modaler Infinitiv + haben + Passiv + subjektloses Prädikat').
ts(299,"dass ihm nicht geholfen zu werden ist",@root,0,[],[],'Kapitel 17: modaler Infinitiv + haben + Passiv + subjektloses Prädikat').
ts(300,"Dem Mann gelungen wurde nicht.",@decl,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

% Realisierung der Passiv-von-Phrase im Aktiv. 
ts(301,"Sie versucht, von ihr zu schlafen.",@decl,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

ts(302,"Aicke scheint von ihm zu schlafen.",@decl,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

% der zu lesende Aufsatz
ts(303,"der zu lesen seiende Aufsatz",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').


%       1A99/MAR.22425 	wir nicht um einen globalen Konsens über die in dieser Ordnung verbindlich zu 	gelten habenden Grundwerte und Prioritäten herum, dem sich alle Staaten verpflichtet fühlen
%	3 	WPD/ZZZ.01930 	einverstanden, nichts 	auszusetzen habend.
%	4 	M06/JAN.00578 	und geschirrspülenden Robotern ausgestattet, aber wenn all die nichts mehr zu 	tun habenden Bewohner an den Strand vor ihrer Haustür streben ... Christel Heybrock 
ts(304,"die den Aufsatz zu lesen habende Frau",@root,1,[],[8],'Kapitel 16: Passiv + Voranstellung + PVP').

% scheint es nicht im COSMAS zu geben.
% ? der zu diesem Zeitpunkt bereits gestorben gewesene Mann
% * Der Mann ist gestorben gewesen.
% ts(305,"der gestorben gewesene Mann",@root,1,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

% NON09/APR.17659 	Aus dem Tank eines in der Anton-Scheiblin-Gasse 	abgestellt gewesenen Lkw sind 50 Liter Dieseltreibstoff gestohlen worden.
% SOZ09/APR.04976 	Auch wenn der im Spätherbst 	angekündigt gewesene Lance Armstrong (USA) und der Tour-de-France-Sieger Carlos Sastre (Sp)
ts(306,"die gelesen gewesene Zeitschrift",@root,1,[],[8],'Kapitel 16: Passiv + Voranstellung + PVP').


% gibt es in COSMAS nur einen false positive
ts(307,"der gestorben seiende Mann",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

% keine Belege in COSMAS
ts(308,"der geschlagen seiende Mann",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

%	NON09/JUL.04732 	denn das Finale mit den in ekstatischer Copula gefressen werdenden Regenwürmern namens Heinz und Anna durfte einfach nicht der Sc
ts(309,"die gelesen werdende Zeitschrift",@root,1,[],[10],'Kapitel 16: Passiv + Voranstellung + PVP').

ts(310,"das die Zeitschrift lesen werdende Kind",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

ts(311,"das gelesen wordene Buch",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').



% belegt in COSMAS
% 1 	A00/JUL.47575 	Das verstand der 1914-1918 	gesiegt habende Westen auch 1938 noch nicht.
% 4 	WPD/OOO.03573 	Von ihm gibt es ein Aufsehen 	erregt habendes Werk: "Das Finanzkapital". 
ts(312,"die den Aufsatz gelesen habende Frau",@root,1,[],[6],'Kapitel 16: Passiv + Voranstellung + PVP').




% Passiv-von-Phrase verlangt, dass DA ein Pronomen ist, aber "er" ist kompatibel.
% Finite Verben haben leeres DA. -> Modifikation durch von-PP ist ausgeschlossen.
ts(313,"dass er von dem Mann schläft",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').



% Perfekt mit haben
ts(314,"Das Kind ist gelacht",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

% gelacht ist. Angezapft ist, aber da ist das Objekt implizit
ts(315,"Gelacht ist.",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').



% von-PP modifiziert Adjektiv
ts(316,"von dem Affen kleinen",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').
ts(317,"kleinen von dem Affen",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

ts(318,"Er hat gestorben.",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').
ts(319,"Er ist das Buch gelesen.",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

ts(320,"Des Romans wird gekannt und von dem Kind geliebt",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').

% Extraktion von Adjunkten aus Adjunkten in der NP left-branch condition
ts(321,"Oft schläft der lachende Affe.",@decl,1,[1],_Gen,'Kapitel 16: Passiv + Voranstellung + PVP').

ts(322,"Der das Buch zu lesen gezwungene Mann lacht.",@decl,1,[1],[1],'Kapitel 16: Passiv + Voranstellung + PVP').
ts(323,"der das Buch zu lesen versprochene Mann",@root,0,[],[],'Kapitel 16: Passiv + Voranstellung + PVP').
ts(324,"Das zu lesen versprochene Buch hilft mir.",@decl,1,[1],[1],'Kapitel 16: Passiv + Voranstellung + PVP').


% Linearisierungsbedingungen mit Spirits
ts(325,"Glaubt, dass Aicke lacht, er?",@root,0,[],[],'Kapitel 16: Linearisierungsbedingungen mit Spirits').
ts(326,"Glaubt er, dass Aicke lacht?", @interrog,1,[2],[28],'Kapitel 16: Linearisierungsbedingungen mit Spirits').

ts(327,"dass gefetzt wurde", @root,0,[],[],'Kapitel 16: Linearisierungsbedingungen mit Spirits').
ts(328,"Von Aicke gefetzt wurde", @root,0,[],[],'Kapitel 16: Linearisierungsbedingungen mit Spirits').

ts(329,"dass gefetzt und gearbeitet wurde", @root,0,[],[],'Kapitel 16: Koordination und Passiv').

ts(330,"Wurde gearbeitet und gelacht?", @interrog,1,[1],[8],'Kapitel 16: Koordination und Passiv').



% es-expl < XP
ts(331,"dass zu regnen es beginnt",@root,0,[],[],'Kapitel 15: Anhebung und Kontrolle').


ts(332,"Er schlägt die Frau vor.",@decl,1,[1],[12],'Kapitel 18: Partikelverben').
ts(333,"Er lacht los.",@decl,1,[1],[5],'Kapitel 18: Partikelverben').
ts(334,"Er lacht ihn los.",@decl,0,[],[],'Kapitel 18: Partikelverben').
ts(335,"Er lacht ihn an.",@decl,1,[1],[12],'Kapitel 18: Partikelverben').
ts(336,"Er lacht an.",@decl,0,[],[],'Kapitel 18: Partikelverben').
ts(337,"Er wird an gelacht.",@decl,0,[],[],'Kapitel 18: Partikelverben').
ts(338,"Er wird angelacht.",@decl,1,[1],[15],'Kapitel 18: Partikelverben').
ts(339,"Er versucht, ihn an zu lachen.",@decl,0,[],[],'Kapitel 18: Partikelverben').
ts(340,"Er versucht, ihn anzulachen.",@decl,1,[1],[17],'Kapitel 18: Partikelverben').
ts(341,"Er anlacht die Frau.",@decl,0,[],[],'Kapitel 18: Partikelverben').
ts(342,"Er loslacht oft.",@decl,0,[],[],'Kapitel 18: Partikelverben').

ts(343,"Das loslachende Kind fetzt.",@decl,1,[1],[3],'Kapitel 18: Partikelverben').
ts(344,"Das angelachte  Kind fetzt.",@decl,1,[1],[5],'Kapitel 18: Partikelverben').
ts(345,"Der das Kind anlachende Affe fetzt.",@decl,1,[1],[3],'Kapitel 18: Partikelverben').
ts(346,"Der anzulachende Affe fetzt.",@decl,1,[1],[5],'Kapitel 18: Partikelverben').



tg(1,"Der Affe schläft.",@decl,1,'Aus Kapitel-09: Grundfall').

tg(2,"Lacht der Affe?",@interrog,2,'Aus Kapitel-12: Generierung').
tg(3,"Kennt jede Frau und jeder Mann ein Buch?",@interrog,16,'Aus Kapitel-11: Generierung').
tg(4,"Schläft der Affe und das Kind?",@root,3,'Aus Kapitel-08: Nominale Koordination mit delayed constraints').
tg(5,"Kennt und liebt das Kind den Roman?",@interrog,2,'Aus Kapitel-08: Verbale Koordination').

tg(6,"Jede Frau und jeder Mann kennt ein Buch.",@decl,8,'Aus Kapitel-11: Generierung').
tg(7,"Den Roman kennt er.",@decl,2,'Aus Kapitel-09: RELS/HCONS-Pfade').

tg(8,"Der Affe, von dessen Kind er ein Bild kennt, lacht.",@decl,2,'Relativsatz').

tg(9,"Kennen jede Frau und jeder Mann ein Buch?",@interrog,16,'Aus Kapitel-12: Generierung').
tg(10,"Jede Frau und jeder Mann kennen ein Buch.",@decl,8,'Aus Kapitel-12: Generierung').

tg(11,"Dass Aicke lacht, freut mich.",@decl,2,'Aus Kapitel-13: Nominalisierter Satz').

tg(12,"Er denkt an das Kind.",@decl,2,'PP-Komplement').
tg(13,"Er muss lachen.",@decl,2,'Verbalkomplex').
tg(14,"Er muss an das Kind denken.",@decl,6,'Verbalkomplex mit PP').
tg(15,"Er wird lachen wollen.",@decl,2,'Mehrere Verben').
tg(16,"Lachen muss er.",@decl,2,'PVP: Pronomen ohne eigene Relation').
tg(17,"Lesen muss er das Buch.",@decl,5,'PVP mit Objekt').

% Aktiv-Passiv-Paraphrase mit zusaetzlichem von aus der Ausnahmeliste.
tg(18,"Der Mann liest den Roman.",@decl,5,'Aktiv und Passiv mit semantisch leerem von').
