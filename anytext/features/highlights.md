## Highlights

The [Highlights](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentHighlight) feature of LSP is used to highlight other parts of the text that carry similar information. If this feature is not implemented by an LSP server, clienty such as Visual Studio Code typically hightlight the same tokens, regardless of their semantics or where they appear in the text.

### Default Implementation in AnyText

By default, AnyText uses the following rules:

- For literal rules, occurrences of the same literal rule are highlighted. Note that this does not include regex rule matches that happen to represent the same text.
- For identifiers and reference resolutions, all references of this element in the same document are highlighted

### Customizations

Customizations are currently not possible. Pleas open an issue if you have a use case that requires it and describe the intended scenario.
