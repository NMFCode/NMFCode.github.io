## Selection Range

With the [SelectionRange](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_selectionRange) query, a client can ask the server to semantically expand the current selection.

### Default Implementation in AnyText

By default, AnyText always selects the entire token. Because AnyText supports white spaces in tokens, this can mean that the selection spans a combination of multiple words.
