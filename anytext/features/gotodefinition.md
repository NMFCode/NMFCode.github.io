## Go To Definition

The client can issue a [Go To Definition request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_definition) to ask the server for a location in the code where the element is defined.

### Default Implementation in AnyText

The parser automatically collects all occurences of model element rules and registers them with the parse context in order to answer go to definition requests. Because the rule application representing the definition of the semantic element is typically too broad, AnyText uses the rule application that defined the identifier of the semantic element to reference it.

At the moment, go to definition requests only work in the same file.

### Customizations

Customizations are currently not possible. Pleas open an issue if you have a use case that requires it and describe the intended scenario.
