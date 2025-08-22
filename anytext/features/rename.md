## Rename

The [Rename](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_rename) command is used by the client to ask the server to consistently rename an element.

### Default Implementation in AnyText

By default, AnyText resolves the [definition](./gotodefinition.md) and [references](./findreferences.md) of an element and returns changes of these to the desired new name.

### Customizations

Customizations are currently not possible. Pleas open an issue if you have a use case that requires it and describe the intended scenario.
