# logic_tutor
A web app to help students with introductory logic and beyond.

## Current Status
I am implementing a way to modularize logical formulae in so that the same architecture may be used regardless of language, be it propositional, predicate, modal, or beyond. To do this, I have created a LogicFormula object type that organizes its operators and sentential components into a tree structure, with the main operator being the root. The formula can thus use recursive methods to determine whether it is a WFF, find its overall truth value on an interpretation, and display it how the user wants. I am aiming for a "mix and match" way of implementing operators, making use of Ruby's procs to let the user deside how they are evaluated.

## To Do
Ideally, I want the LogicFormula class to be able to be passed a string, break it apart, and load the tree recursively. This is easy when parentheses are used liberally and the formula is composed mostly of binary connectives. However, the issue I am having come from conventions involving unary connectives. For instance, my current algorithm recognizes the statement

`NOT A OR (B AND C)`

as a negation, rather than a disjunction.

## File Structure
While this will eventually become a Rails app, the current layout has the main files in the home directory, and experimental stuff in the "scratch" directory. I am currently trying out the RubyMine IDE just for kicks, so there are some extra files in there for that.
