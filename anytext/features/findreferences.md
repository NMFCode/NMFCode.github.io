# Find References

The [Find References request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_references) can be issued by a client to ask an LSP server to return locations in the same file or other files that reference the same element.

## Default Implementation in AnyText

AnyText uses the semantic model represented by a given rule application to answer find references queries. Hence, any occurences of [reference resolution rules](../api/NMF.AnyText.Model.ResolveRule-2.yml) will be returned plus the definition of the element.

## Customizations

Customizations are currently not possible. Pleas open an issue if you have a use case that requires it and describe the intended scenario.
