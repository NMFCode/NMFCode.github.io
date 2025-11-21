# Formatting

The client can send a [Formatting request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_formatting) to the server to request the server to format a given document.

## Default Implementation in AnyText

By default, AnyText answers this request by formatting the current parse tree.

## Customizations

To customize the formatting behavior, insert [formatting instructions](../reference/formattingInstructions.md) in your grammar.
