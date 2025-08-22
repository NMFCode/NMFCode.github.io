## Inlays

[Inlay hints](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_inlayHint) can be used to give users explicitly information that can be inferred and thus do not need to be part of the text. This is often used to show the result of type inference or trace information.

### Default Implementation in AnyText

By default, no code inlays are provided.

### Customizations

Inlays are controlled via the method *GetInlayHintText* that can be overridden on any [Rule](../api/NMF.AnyText.Rules.Rule.yml). The method returns an instance of [InlayEntry](../api/NMF.AnyText.InlayEntry.yml) that allows to decide whether the inlay text should be rendered before or after the given rule application.
