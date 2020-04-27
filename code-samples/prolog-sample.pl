% https://raw.githubusercontent.com/So-Cool/BlackJack/master/deck.pl

/** <module> Predicates for handling a deck of card

This module contains configuration and predicates responsible for handling
deck(s) of cards through the game.

@author Kacper Sokol
@license GPL
*/

:- module( deck,
  [decks/1,
   shuffleMode/1,
   deck/1,
   shuffle/3,
   initDeal/3,
   score/2,
   getPiles/3,
   addCard/5]
  ).

:- use_module(blackJack). % players

%% decks(-N) is det.
%
% Defines the number of decks used in the game.
%
% @param N  Number of decks used in the game.
%
decks(1).

%% shuffleMode(-Type) is det.
%
% Defines the type of deck shuffling used in the game; can be either:
%  * deterministic, or
%  * random.
%
% The deterministic shuffling splits the pile in half randomly selects the half
% and merge halves interchangeably. The random shuffling also splits the deck
% but then tosses a coin on each card merge which card should go first.
%
% @param Type  Type of shuffling used in the game.
%
shuffleMode(random).

%% suits(-Type) is det.
%
% Defines suits of cards:
%  * clubs(♣),
%  * diamonds(♦),
%  * hearts(♥) and
%  * spades(♠).
%
% @param Type  Type of card's suit.
%
suits(♦).
suits(♥).
suits(♠).
suits(♣).

%% ranks(-Rank) is det.
%
% Defines the possible ranks of card: ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, jack,
% queen, king.
%
% @param Rank  Rank of card.
%
ranks(  ace).
ranks(    2).
ranks(    3).
ranks(    4).
ranks(    5).
ranks(    6).
ranks(    7).
ranks(    8).
ranks(    9).
ranks(   10).
ranks( jack).
ranks(queen).
ranks( king).

%% card(+Suit, +Rank) is det.
%% card(-Suit, -Rank) is nondet.
%
% Represents a card.
%
% @param Suit  Suit of card.
% @param Rank  Rank of card.
%
card( Suit, Rank ) :-
	suits( Suit ), ranks( Rank ).

%% value(-Value, :Card) is det.
%
% Converts card predicate to its value. The `Card` variable is given by
% `card(+S, +R)` predicate with: `S` - Suit of card; `R` - Rank of card.
%
% @param Value  Value of given card.
% @param Card   The card.
%
value( Value, card( S, R ) ) :-
	( S = ♣; S = ♦; S = ♥; S = ♠ ), !,
	( R = ace   -> ( Value is 11 ; Value is 1 )
	; R = jack  -> Value is 10
	; R = queen -> Value is 10
	; R = king  -> Value is 10
	; otherwise -> Value is R
	).

%% score(-Score, +Hand) is det.
%
% Calculates value of player's hand.
%
% @param Score  Value of given hand.
% @param Hand   A list of `card` predicates.
%
score( Score, Hand ) :- % Hand
	score( Score, Hand, 0 ).
score( Score, [Card|Hand], V ) :-
	value(Q, Card),
	Vn is V + Q,
	score(Score, Hand, Vn).
score( Score, [], V ) :-
	Score is V.

%% deck(-Deck) is det.
%
% Generates deck(s) based on their predefined number (`decks` parameter in
%	`deck` module).
%
% @param Deck  Deck(s) generated based on system parameters.
%
deck(Deck) :-
	decks(No),
	deck(Deck, [], No).
deck(Deck, Holder, 0) :-
	append(Holder, [], Deck),
	!.
deck(Deck, Holder, No) :-
	Np is No - 1,
	findall(card(S,R), card(S, R), New),
	append(Holder, New, NewHolder),
	deck(Deck, NewHolder, Np).

%% woN(-Out, +E, +In) is det.
%
% Returns the `In` list without element `E`.
%
% @param Out  The list with specified element removed.
% @param E    An element ot be removed from the input list.
% @param In   List with the element to be removed.
%
woN(Out, E, In) :-
	select(E, In, Out), !.

%% initDeal(-Table, -NewDeck, +Deck) is det.
%
% Deals the cards from the `Deck` to all players defined by `players` predicate
% defined in `blackJack` module. The initial deal consists of two cards given
% to each player & two cards for the house. This predicate returns the new deck
% without just dealt cards and the table i.e. list of lists containing cards of
% each player.
%
% @param Table    List of cards held by all player (list of lists).
% @param NewDeck  Deck(s) of card with removed cards that were used for initial
%                 deal.
% @param Deck     Deck(s) of cards used for initial deal.
%
initDeal(Table, NewDeck, Deck) :-
	players(P),
	userPlayer(Q),
	AtTable is P + 1 + Q,
	%% CardDeals is AtTable * 2, % deal 2 cards for each player
	initDeal(Table, NewDeck, [], Deck ,Deck, AtTable, 1).
%
initDeal(Table, Deck, Table, Deck, _, AtTable, Current) :-
	AtTable is Current - 1, !.
initDeal(Table, NewDeck, TemporaryTable, DissortingD, Deck, AtTable, Current) :-
	nth1(Current, Deck, C1), % draw element N
	Current1 is Current + AtTable, % get new index
	nth1(Current1, Deck, C2), % draw next card
	woN(Deck1, C1, DissortingD), % delete first card
	woN(Deck2, C2, Deck1), % delete first card
	Next is Current + 1, % new current player
	append([C1], [C2], Person), % create one hand
	append(TemporaryTable, [Person], Table2),% generate i-th player
	initDeal(Table, NewDeck, Table2, Deck2, Deck, AtTable, Next).

%% shuffle(-Shuffled, +Deck, +N) is det.
%
% Manages shuffling: decides which shuffling algorithm to use based on type
% defined by `shuffleMode` predicate defined in `deck` package.
%
% @param Shuffled  The shuffled deck (list of `card` predicate).
% @param Deck      The deck to be shuffled (list of `card` predicate).
% @param N         Number of shuffles.
%
shuffle(Shf, Shf, 0) :-
	!.
shuffle(Shuffled, Deck, N) :-
	shuffleMode(Mode),
	proper_length(Deck, Len),
	Half is Len / 2,
	getPiles(A, _, Half),
	A1 is A + 1,
	split(P1, P2, Deck, A1), % get two piles
	% random or deterministic
	( Mode = random        -> rifleRan(Forward, P1, P2)
	; Mode = deterministic -> rifleDet(Forward, P1, P2)
	),
	N1 is N - 1,
	shuffle( Shuffled, Forward, N1 ).

%% rifleDet(-Out, +A, +B) is det.
%
% Rifle-shuffle two piles of cards deterministically: split the deck into two
% parts and merge them one by one. The only random bit here is whether the
% shuffle starts with pile A or pile B.
%
% @param Out  Merged deck (list of predicates `card`).
% @param A    1st part of deck to be merged (list of predicates `card`).
% @param B    2nd part of deck to be merged (list of predicates `card`).
%
rifleDet(Out, A, B) :-
	random(0, 2, Rand), % decide whether left pile goes on top or bottom,
	( Rand = 0 -> rifleDet(Out, [], A, B)
	; Rand = 1 -> rifleDet(Out, [], B, A)
	).
rifleDet(Out, Em, [A1|A2], [B1|B2]) :-
	append(Em, [A1], O1),
	append(O1, [B1], O2),
	rifleDet(Out, O2, A2, B2).
rifleDet(Out, Em, [], [B1|B2]) :-
	append(Em, [B1], O),
	rifleDet(Out, O, [], B2).
rifleDet(Out, Em, [A1|A2], []) :-
	append(Em, [A1], O),
	rifleDet(Out, O, A2, []).
rifleDet(Out, Out, [], []) :-
	!.

%% rifleRan(-Out, +A, +B) is det.
%
% Rifle-shuffle two piles of cards with *random* card selection i.e. split the
% deck into two parts and merge them by tossing a coin for each card to decide
% whether it goes on the top or bottom of the merged pile.
%
% @param Out  Merged deck (list of predicates `card`).
% @param A    1st part of deck to be merged (list of predicates `card`).
% @param B    2nd part of deck to be merged (list of predicates `card`).
%
rifleRan(Out, A, B) :-
	random(0, 2, Rand), % decide whether left pile goes on top or bottom
	rifleRan(Out, [], A, B, Rand).
rifleRan(Out, Em, [A1|A2], [B1|B2], 0) :-
	append(Em, [A1], O1),
	append(O1, [B1], O2),
	random(0, 2, Rand),
	rifleRan(Out, O2, A2, B2, Rand).
rifleRan(Out, Em, [A1|A2], [B1|B2], 1) :-
	append(Em, [B1], O1),
	append(O1, [A1], O2),
	random(0, 2, Rand),
	rifleRan(Out, O2, A2, B2, Rand).
rifleRan(Out, Em, [], [B1|B2], Rand) :-
	append(Em, [B1], O),
	rifleRan(Out, O, [], B2, Rand).
rifleRan(Out, Em, [A1|A2], [], Rand) :-
	append(Em, [A1], O),
	rifleRan(Out, O, A2, [], Rand).
rifleRan(Out, Out, [], [], _) :-
	!.

%% getPiles(-A, -B, +Half) is det.
%
% Generates two piles counters: if the number of cards in the deck is **odd**
% then it is impossible to split it equally. This predicate takes a float
% number and outputs two numbers one a half bigger and one a half smaller to
% create two integers. In general 2*`Half`=`A`+`B`.
%
% @param A     Number rounded to an integer based on above rule.
% @param B     Number rounded to an integer based on above rule.
% @param Half  A number to be rounded based on above rule.
%
getPiles(A, B, Half) :-
	float(Half),
	random(0,2,Rand), % decide whether round up left or right pile
	( Rand = 0 -> A is Half - 0.5, B is Half + 0.5
	; Rand = 1 -> A is Half + 0.5, B is Half - 0.5
	),
	!.
getPiles(Half, Half, Half) :-
	integer(Half).

%% addCard(-NewDeal, -NewDeck, +OldDeck, +OldDeal, +PlayerNo) is det.
%
% Deals additional card to player with sequential number `PlayerNo`. After the
% deal it returns new deck and new hand of given player.
%
% @param NewDeal   List of cards held by all player (list of lists) **after**
%                  adding a new card.
% @param NewDeck   **New** list of cards remaining in the deck after current
%                  round.
% @param OldDeck   Current list of cards in the deck after.
% @param OldDeal   List of cards held by all player (list of lists) **before**
%                  adding a new card.
% @param PlayerNo  An id of the player counting from 1 which is to be dealt a
%                  new card.
%
addCard(NewDeal, NewDeck, [Card|NewDeck], OldDeal, PlayerNo) :-
	split(A, [X|C], OldDeal, PlayerNo), % get sublist
	append(X, [Card], Y), % extend sublist
	append(A, [Y], Alpha), % put at the same place new list
	append(Alpha, C, NewDeal). % put at the same place new list
