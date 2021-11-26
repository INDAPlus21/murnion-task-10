% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).

is_color(Row, Column, Color, Filename) :-
    read_file(Filename, Board),
    nth1_2d(Row, Column, Board, Piece),
    Piece = Color.

are_same_color(Row1, Column1, Row2, Column2, Filename) :-
    read_file(Filename, Board),
    nth1_2d(Row1, Column1, Board, Piece1),
    nth1_2d(Row2, Column2, Board, Piece2),
    Piece1 = Piece2.

read_file(BoardFileName, Board):-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen.                   % Closes the io-stream

% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.

neighbour(Row1, Column1, Row2, Column2) :-
    (Column1 = Column2,
    (Row2 is Row1 + 1; Row2 is Row1 - 1);
    Row1 = Row2,
    (Column2 is Column1 + 1; Column2 is Column1 - 1)).

check_alive(Row1, Column1, Blacklist, Filename) :-
    \+ member((Row1, Column1), Blacklist),
    neighbour(Row1, Column1, Row2, Column2),
    is_color(Row2, Column2, 'e', Filename); %liberty acquired!
    (\+ member((Row1, Column1), Blacklist), !,
    neighbour(Row1, Column1, Row2, Column2),
    are_same_color(Row1, Column1, Row2, Column2, Filename),
    alive(Row2, Column2, [(Row1, Column1)|Blacklist], Filename)). %try again with neighbours
    