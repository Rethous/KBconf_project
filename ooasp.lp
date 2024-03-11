% Domain
#const maxnumobjects=50.
dom(1..maxnumobjects).

% ------------
% | Generate |
% ------------
% isa -------------
% ooasp_type defines classes that have an association
ooasp_type(T) :- ooasp_class(_,T), 1{ooasp_assoc(_,_,T,_,_,_,_,_); ooasp_assoc(_,_,_,_,_,T,_,_)}.

% relations between subclasses
ooasp_isrelated(Z,X) :- ooasp_subclass(_,Y,X), ooasp_subclass(_,Z,Y).
ooasp_isrelated(X,Y) :- ooasp_subclass(_,X,Y).

% L is a leavclass with parent P that has an association
ooasp_isleave(L,P):- ooasp_isrelated(L,P), not ooasp_subclass(_,_,L), ooasp_type(P).
ooasp_isleave(P,P):- ooasp_isrelated(P,_), not ooasp_subclass(_,_,P), ooasp_type(P).

0 {ooasp_isa(I,L,ID): ooasp_isleave(L,_) }1 :- dom(ID), ooasp_instantiation(M,I).

% associated ----------------------
{ooasp_associated(I,ASSOC,ID1,ID2): ooasp_isa(I,LC1,ID1), ooasp_isleave(LC1,C1)}:-
ooasp_assoc(M,ASSOC,C1,_,_,C2,_,_),
ooasp_isa(I,LC2,ID2),
ooasp_isleave(LC2,C2),
ooasp_instantiation(M,I).

{ooasp_associated(I,ASSOC,ID1,ID2): ooasp_isa(I,LC2,ID2), ooasp_isleave(LC2,C2)}:-
ooasp_assoc(M,ASSOC,C1,_,_,C2,_,_),
ooasp_isa(I,LC1,ID1),
ooasp_isleave(LC1,C1),
ooasp_instantiation(M,I).

% attribute ---------------
1{ ooasp_attribute_value(I,AT,ID,VAL) : VAL=MIN..MAX }1 :- 
  ooasp_attribute(M,C,AT,"integer"),
  ooasp_attribute_minInclusive(M,C,AT,MIN),
  ooasp_attribute_maxInclusive(M,C,AT,MAX),
  ooasp_isa(I,CL,ID),
  ooasp_isleave(CL,C), 
  ooasp_instantiation(M,I).

1{ ooasp_attribute_value(I,AT,ID,VAL) : ooasp_attribute_enum(M,C,AT,VAL) }1 :-
  ooasp_attribute(M,C,AT,"string"),
  %ooasp_attribute_enum(M,C,AT,VAL),
  ooasp_isa(I,CL,ID),
  ooasp_isleave(CL,C),
  ooasp_instantiation(M,I).

1{ooasp_attribute_value(I,AT,ID,true);ooasp_attribute_value(I,AT,ID,false)}1:-
  ooasp_attribute(M,C,AT,"boolean"),
  ooasp_isa(I,CL,ID),
  ooasp_isleave(CL,C), 
  ooasp_instantiation(M,I).

% --------
% | Test |
% --------

% Max cardinality is violated
:- C2MAX+1 {ooasp_associated(I,A,O1,O2): ooasp_isa(I,CL2,O2), ooasp_isleave(CL2,C2)},
  ooasp_assoc(M,A,C1,C1MIN,C1MAX,C2,C2MIN,C2MAX),
  ooasp_instantiation(M,I),
  ooasp_isa(I,CL1,O1),
  ooasp_isleave(CL1,C1).
:- C1MAX+1 {ooasp_associated(I,A,O1,O2): ooasp_isa(I,CL1,O1), ooasp_isleave(CL1,C1)},
  ooasp_assoc(M,A,C1,C1MIN,C1MAX,C2,C2MIN,C2MAX),
  ooasp_instantiation(M,I),
  ooasp_isa(I,CL2,O2),
  ooasp_isleave(CL2,C2).

% Min cardinality is violated
:- {ooasp_associated(I,A,O1,O2): ooasp_isa(I,CL2,O2), ooasp_isleave(CL2,C2)} C2MIN-1, C2MIN>0,
  ooasp_assoc(M,A,C1,C1MIN,C1MAX,C2,C2MIN,C2MAX),
  ooasp_instantiation(M,I),
  ooasp_isa(I,CL1,O1),
  ooasp_isleave(CL1,C1).
:- {ooasp_associated(I,A,O1,O2): ooasp_isa(I,CL1,O1), ooasp_isleave(CL1,C1)} C1MIN-1, C1MIN>0,
  ooasp_assoc(M,A,C1,C1MIN,C1MAX,C2,C2MIN,C2MAX),
  ooasp_instantiation(M,I),
  ooasp_isa(I,CL2,O2),
  ooasp_isleave(CL2,C2).

% One Id per class
:- ooasp_isa(_,C1,ID1), ooasp_isa(_,C2,ID2), C1!=C2, ID1=ID2.

% Symmetrie breaking
%:- ooasp_isa(I,_,ID1), not ooasp_isa(I,_,ID2), ID1>ID2, dom(ID2).

%Every Object has an association
%:- ooasp_isa(_,C,ID), not 1{ ooasp_associated(_,_,ID,_);ooasp_associated(_,_,_,ID) }.

%No empty stable model
%:- ooasp_assoc(_,_,C1,_,_,_,_,_), not ooasp_isa(_,CL1,_), ooasp_isleave(CL1,C1).
%:- ooasp_assoc(_,_,_,_,_,C2,_,_), not ooasp_isa(_,CL2,_), ooasp_isleave(CL2,C2).


%TODO attribute

% Minimize
#minimize {ID : ooasp_isa(I,C,ID)}.
%-----------
% | Display |
% -----------

%#show ooasp_attribute_value/4.
#show ooasp_isa/3.
%#show ooasp_associated/4.
%#show ooasp_assoc/8.
%#show ooasp_instantiation/2.
%#show ooasp_type/1.
%#show ooasp_isleave/2.
%#show ooasp_isrelated/2.
