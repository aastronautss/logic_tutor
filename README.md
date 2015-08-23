# logic_tutor
Logic Tutor is a web app designed to assist with the learning of first-order logic and beyond. It is designed to adapt to numerous different curricula and approaches: that is, the teaching modules are more or less compartmentalized and can be taken almost independently. As nearly every course uses a different set of symbols and terminology, it is important for the structure of the program to be as modular as possible, in order to account for that. Outside of the core curricula, the app includes a logic calculator and a wealth of practice problems available for each unit.

## Current Status
I am implementing a way to modularize logical formulae in so that the same architecture may be used regardless of language, be it propositional, predicate, modal, or beyond. To do this, I have created a LogicFormula object type that organizes its operators and sentential components into a tree structure, with the main operator being the root. The formula can thus use recursive methods to determine whether it is a WFF, find its overall truth value on an interpretation, and display it how the user wants. I am aiming for a "mix and match" way of implementing operators, making use of Ruby's procs to let the user deside how they are evaluated.

### Why modularity?
Modular structures allow me to avoid the use of literals in the core of the code, allowing the structures to adapt to whatever styles the user or developer is accustomed to. For instance, if a user is used to the "horseshoe" operator for material conditionals, they can freely use it without worry. This capability also alleviates potential conflicts in symbol use, e.g. the "pipe" character "|" being used for the sheffer stroke (NAND operator) rather than the disjunction. Users can also choose between sets of symbols: if a system uses NAND or NOR operators, then they can be plugged in to the calculator.

Furthermore, a modular system is an extendable system. I would ideally like to add modules for modal logic, predicate logic, and beyond, so this is a great way to adapt for future changes.

## To Do
Ideally, I want the LogicFormula class to be able to be passed a string, break it apart, and load the tree recursively. This is easy when parentheses are used liberally and the formula is composed mostly of binary connectives. However, the issue I am having come from conventions involving unary connectives. For instance, my current algorithm recognizes the statement

`NOT A OR (B AND C)`

as a negation, rather than a disjunction.

## File Structure
While this will eventually become a Rails app, the current layout has the main files in the home directory, and experimental stuff in the "scratch" directory. I am currently trying out the RubyMine IDE just for kicks, so there are some extra files in there for that.
