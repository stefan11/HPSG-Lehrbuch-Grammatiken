appendx([],T,T).
appendx([H|T],L,[H|L2]) :-
        appendx(T,L,L2).