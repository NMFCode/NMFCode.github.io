# Document Symbols

[Document Symbols](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentSymbol) are used to provide an outline of a document. 

## Default Implementation in AnyText

By default, no document symbols are provided.

## Customizations

To define that a rule denotes a document symbol, one can override the property *SymbolKind* of the class [Rule](../api/NMF.AnyText.Rules.Rule.yml). Because LSP restricts the possible valuies of a document symbol kind, this is implemented as an enumeration.

Making a rule representing a document symbol also registers that symbol kind for [completions](./completions.md) and activates a [folding range](./folding.md) by default.

Symbols can be tagged, overriding the method *SymbolTag*.
