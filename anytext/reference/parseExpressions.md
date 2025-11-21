# Parse Expressions

AnyText uses [Parse Expression Grammars (PEGs) introduced by Bryan Ford](https://doi.org/10.1145/583852).

## Parse Expression Grammars

The basic idea is that a [rule](rules.md) denotes a parse expression and if `A` and `B` are parsing expressions, then:

- `A | B` denotes the ordered choice. This means that the parser will not try to match `B` unless matching `A` fails. This is in stark contrast to context-free grammars where the order of productions does not matter. In the literature, one therefore often finds `/` as notation to make the difference clearer, but AnyText decided to use the operator `|` for better compatibility with Xtext and Langium.
- `A B` is the ordered sequence in which a parser would match `A` and then `B`, if matching `A` succeeded.
- `'a'` is a parse expression for any character sequence `a`. AnyText will treat these literals as keywords or operators (by default, an alphabetic literal is a keyword, everything else is an operator)
- `A*` is a parse expression that matches `A` arbitrarily many times or not at all.
- `A+` is a parse expression that matches `A` arbitrarily many times, but at least once.
- `A?` is a parse expression that matches `A` optionally, i.e., once or not at all.
- `(A)` is a parse expression.
- `&A` is a positive lookahead. This means, the parser will see whether the non-terminal `A` can expand at the current position, but the parser will not change the current position.
- `!A` is a negative lookahead. This is similar to a positive lookahead except that the parser will accept the position if matching `A` fails and will fail if matching `A` succeeds.

Thanks to the unlimited lookaheads, PEGs can parse some grammars that are not context-free. In DSLs, they are useful to exclude certain scenarios.

## Assignments

In order define how semantic models are created from parse trees, AnyText supports the following assignment expressions, where again `A` is a parse expression:

- `feature=A` assigns the semantic value of `A` to the property `feature` of the current semantic element.
- `feature+=A` adds the semantic value of `A` to the collection `feature` of the current semantic element.
- `feature?=A` assigns the value `true` to the property `feature` of the current semantic element.

All of these assignments are executed for every rule application that gets activated, i.e., gets part of the parse tree.

If `R` is a class rule, then the following assignments are also supported:

- `feature=[R]` assigns a reference to the rule `R` to the property `feature` of the current semantic element. AnyText looks up the identifier of `R` to determine the parse expression used to parse the reference.
- `feature=[R:A]` assigns a reference to the rule `R` to the property `feature` of the current semantic element. The parse expression `A` is used to indicate the text for the reference.
- `feature+=[R]` adds a reference to the rule `R` to the property `feature` of the current semantic element. AnyText looks up the identifier of `R` to determine the parse expression used to parse the reference.
- `feature+=[R:A]` adds a reference to the rule `R` to the property `feature` of the current semantic element. The parse expression `A` is used to indicate the text for the reference.

Reference resolution is done in the semantic model. By default, AnyText will look up in the containment hierarchy to find a model element with the given identifier. However, this can (and in many cases: has to) be overridden in the generated code. Also, it is possible to customize how AnyText will synthesize text for a given element reference.

## Identifiers

By default, AnyText will treat feature assignments of features called `name` or `id` as an identifier. However, this can be customized with a dedicated command-line argument `-i` or `--identifierNames` of the code generator. You can specify multiple feature names separated by a space. Note that if you specify this command-line parameter, the default values no longer apply.
