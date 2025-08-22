## Diagnostics

[Diagnostics](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_publishDiagnostics) are sent in LSP through a separate message sent by the server to the client in order to update any problems related to a given text.

### Default Implementation in AnyText

By default, AnyText uses diagnostics to inform a user about parse problems and failed reference resolutions.

### Customization

Diagnostics can be customized e.g. through custom validation messages. AnyText currently supports two kinds of validation: batch validation and incremental validation.

- Batch validation is executed every time. That is, whenever the text has changed, batch validation rules are applied on the entire model to see whether there are updated error messages.
- Incremental validation uses the incrementalization capabilities of [NMF Expressions](../../expressions/index.md) to watch the semantic model for changes and react by sending the client updated diagnostic information whenever needed.

In order to implement custom validations, one needs to override the method *PostInitialize* and call the methods *Validate* or *ValidateIncrementall* defined in [ModelElementRule](../api/NMF.AnyText.Model.ModelElementRule-1.yml).
