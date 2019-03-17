%%%-------------------------------------------------------------------
%%% @author mb
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Mar 2019 1:11 PM
%%%-------------------------------------------------------------------
-module(rpn).
-author("mb").

%% API
-export([rpn/2]).


rpn(Expression, integer) ->
  process(string:tokens(Expression, " "), [], integer);
rpn(Expression, float) ->
  process(string:tokens(Expression, " "), [], float).

process([], ResStack, _) -> resultCheck(ResStack);
process([ExprElem|T], ResStack, integer) ->
  case detect(ExprElem) of
    two -> process(T, handle(two, ExprElem, ResStack), integer);
    one -> process(T, handle(one, ExprElem, ResStack), integer);
    _   -> process(T, [list_to_integer(ExprElem)] ++ ResStack, integer)
  end;
process([ExprElem|T], ResStack, float) ->
  case detect(ExprElem) of
    two -> process(T, handle(two, ExprElem, ResStack), float);
    one -> process(T, handle(one, ExprElem, ResStack), float);
    _   -> process(T, [list_to_float(ExprElem)] ++ ResStack, float)
  end.

resultCheck([]) ->
  "expression processing error - 0 elements left on result stack";
resultCheck([R|T]) ->
  case T of
    [] -> R;
    _ -> "expression processing error - >1 elements left on result stack"
  end.

detect(V) ->
  case V of
    "+" -> two;
    "-" -> two;
    "*" -> two;
    "/" -> two;
    "sqrt" -> one;
    "pow" -> two;
    "sin" -> one;
    "cos" -> one;
    "tan" -> one;
     _ -> val
  end.

handle(two, V, [H2|[H1|T]]) ->
  case V of
    "+" -> [H1 + H2] ++ T;
    "-" -> [H1 - H2] ++ T;
    "*" -> [H1 * H2] ++ T;
    "/" -> [H1 / H2] ++ T;
    "pow" -> [math:pow(H1, H2)] ++ T
  end;
handle(one, V, [H|T]) ->
  case V of
    "sqrt" -> [math:sqrt(H)] ++ T;
    "sin" -> [math:sin(H)] ++ T;
    "cos" -> [math:cos(H)] ++ T;
    "tan" -> [math:tan(H)] ++ T
  end.

