# Rules

The heart and soul of a grammar is the collection of rules. AnyText supports the following kinds of rules:

- Model Rules: The basic rules define a non-terminal that ends up as a model element
- Inheritance Rules: A simplified form of model rules indicate inheritance
- Data Rules (or terminal rules): A rule that defines simple data types like strings or numbers
- Fragment Rules: Fragment rules define non-terminals that do not end up as separate model elements but denote reusable model element populations
- Paranthesis Rules: Rules used for parantheses purposes
- Enum Rules: Rules used for enumerations

Rules generally have names to reference them from other rules. Model rules and inheritance rules (class rules) return model elements. By default, the name of the class is the name of the rule, but this behavior can be overridden by an explicit declaration of the model class returned by this rule. This is done with the keyword `returns`, followed by the name of the class, optionally with a prefix. The same syntax is used for data rules to define the (primitive) type of the return and by enum rules to indicate the name of the returned enumeration.

All rule types are structured with a header including their name and a body. Header and body are separated by `:`. All rules are terminated with `;`.

The different rule kinds are explained in more detail in the following.

## Model Rules

Model rules are the default and are not started with a keyword. Whenever the parse tree of a document contains an instance of a model rule, an instance of the associated model class is created and added to the semantic model.

The body of a model rule is a [parse expression](parseExpressions.md).

## Inheritance Rules

An inheritance rule is a special kind of a model rule where the body parse expressions is a choice of references to other class rules (i.e., model rules or other inheritance rules) or parantheses rules. For an inheritance rule, no separate model element is constructed but the semantic model element for an instance of an inheritance rule is the semantic model element of the inner rule that actually matched.

The name of inheritance rule comes from their effect when generating a metamodel from it: The classes generated for the references rules in an inheritance rule automatically inherit from the class generated for the inheritance rule, unless they are the same. If an existing metamodel is used, the classes referenced by the inner class rules must be the same as the class referenced by the inheritance rule or subtypes thereof. If this is not the case, AnyText will throw an Exception when generating the parser code.

## Data Rules

Data rules are indicated by the keyword `terminal` because they denote terminals in the PEG. In AnyText, terminal symbols are expressed through regular expressions with an optional surrounding character and escape rules.

For the regular expression, AnyText uses the standard .NET regular expression syntax. Similar to JavaScript, regular expressions are encapsulated in `/`.

In addition, data rules can define surrounding characters. Those are characters in which a string may be wrapped. For instance, a single-quoted string would use the surrounding character `'` while a double-quoted string would use the surrounding character `"`. AnyText automatically removes surrounding characters when it extracts the semantic element.

In addition, a data rule can define escape rules. Escape rules mean that some characters inside the terminal appear escaped in the text in order to avoid conflicts with the surrounding character. Thus, if surrounding characters are used, it is useful to declare escape rules for the surrounding character as the pretty-printer from AnyText will otherwise generate text that unintentionally terminates the string. In addition, it might be useful to further escape characters used to indicates escape rules.

For example, a string surrounded by `'` (single-quoted string) may want to escape `'` with `\'`, but in order to use `\'` as text fragment, it is also necessary to escape `\` such that `\\'` will be unescaped to `\'`.

**Note: The definition of escape rules does not have an effect on the regular expression. The regular expression has to cope with escape rules.** However, AnyText automatically prefixes and suffixes the regular expression with the surround character, if any.

Because AnyText operates scannerless, the order in which data rules are specified does not matter, because there is no lexer that will try to tokenize the input text. Rather, the AnyText packrat parser will always know the kind of terminal that is to be matched next. As a consequence, data rules can absolutely overlap. It is not a problem at all to have separate data rules for integers and floating point numbers, even though the text matched for an integer number might also match the text for a floating point.

Data rules can also override the type of elements created from them using the `returns` keyword. By default, AnyText uses the standard string deserialization of this data type to convert the text into the target type, but this can be overridden (in code). AnyText also supports surround characters and escape rules in conjunction with a non-standard data type. This can be used for example to escape `-1` with `*`. If no custom data type is present, the data type of a data rule is always string.

## Fragment Rules

Often, parts of a model rule are reused in multiple model rules. In order to make parts (fragments) of model rules reusable, AnyText supports fragment rules. Hence, the semantic model element of a fragment rule is simply the semantic model element of its container, usually a model rule. However, fragments can be nested.

Fragment rules are indicated by the keyword `fragment` before the name of the rule. Fragment rules must define the class on which they operate using the `processes` keyword immediately after the name of the fragment. Apart from this, fragment rules are like model rules.

## Parantheses Rules

Especially in expression grammars, one can typically nest expressions arbitrarily inside parantheses without changing the semantics. In the semantic model, one typically do not even want to see parantheses. To support these scenarios, AnyText supports parantheses rule.

Parantheses rules are indicated by the keyword `parantheses`. Their body consists of exactly three elements: An opening parantheses (in single-quotes, can be multiple characters), the inner class rule (i.e., model rule or inheritance rule) and the closing paranthesis, again in single-quotes.

Note that parantheses rules will always agree to synthesize an element. Thus, they should come last in the alternatives of an inheritance rule, otherwise synthesis is not going to work.

## Enum Rules

Enum rules or enumeration rules are rules to support enumerations. They define how enumerations should appear in text. Their body consists of literal specifications. Literal specifications consist of the Literal, followed by the operator `=>` and the parse expression for that enumeration member. The parse expression can be more complex than a keyword, but it is recommended to just use a keyword. AnyText will ignore the semantic element of the parse tree and the semantic value of the enumeration will be the enumeration value associated with the matching child rule application.

Enum rules can also specify custom types using the `returns` keyword. Multiple enum rules can target the same enumeration and an enumeration does not have to specify a literal specification for each member of the enumeration.

Currently, flagged enumerations are not supported.
