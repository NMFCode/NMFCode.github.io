# AnyMeta

AnyMeta is a DSL built with AnyText to provide a textual representation of [NMeta](../../models/NMeta.md) metamodels. AnyMeta is a rather simple declaration in a C-like syntax.

## Namespaces

Namespaces in AnyMeta start with the keyword `namespace`, followed by the name of the namespace. After that, in parentheses, AnyMeta expects the prefix. Optionally, one can specify the namespace URI prefixed with the keyword `=`. Then, the body of the namespace declaration is enclosed in braces (`{}`) and consists of child namespaces and types.

## Classes

As in many programming languages, classes in AnyMeta start with the keyword `class`. Unlike many programming languages, classes in NMeta do not have a visibility, so the only available keyword before `class` is `abstract` to declare the class as an abstract class. Similar to C++ and C#, base types are denoted after a `:`, divided by commas. Classes in NMeta can specify that they are an [instance of](../../models/deepModeling.md) another class, indicated by the optional keyword `instance of`. The contents of the class, consisting of attributes, references and operations, appear enclosed in braces.

## Attributes

Attributes in AnyMeta are denoted similat to OCL as `name : type [bounds]`. Here, type references in AnyMeta are always qualified with the namespace prefix unless the type is declared in the same namespace. Bounds define both lower and upper bound. If both bounds coincide, a single number is sufficient, otherwise the bounds are separated by `..`. Attributes can be prefixed with the keywords `unique` and `ordered` in order to specify whether the collection types should enforce uniqueness or define an order of elements.

Attributes can [refine](../../models/structuralDecomposition.md) other attributes by using the `refines` keyword followed by the name of the refined attribute.

## References

References are much like attributes except that they have the keyword `reference` in front of the name. For references, also the keyword `composite` is available to indicate that it is a containment reference. Next to refinements, references also can specify opposite references through the `opposite` keyword.

## Operations

Operations are specified also like attributes except that there is a list of parameters (in parentheses) immediately after the name. Parameters also have the syntax `name : type [bounds]`.

## Extensions

Extensions start with the keyword `extension` followed by the name of the extension, the keyword `for` and the reference to the adorned class. Enclosed in braces, the extension contains attributes, references and operations.

## Enumerations

Enumerations start with the `enum` keyword followed by the name and a list of literals enclosed in curly braces.

Literals are indicated by their name, optionally followed by the assigned value prefixed with `=`.

## Primitive Types

Primitive types start with the keyword `primitive` followed by the name, the keyword `as` and the system type.

## Documentation

All elements in AnyMeta can be prefixed with `#` in order to define the documentation (except parameters).

## Limitations

Currently, AnyMeta does not support identifiers and identifier scopes. There is also no syntax yet to support multi-line documentation or remarks.
