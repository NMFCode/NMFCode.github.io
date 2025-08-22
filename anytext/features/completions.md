## Completions

[Completions](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_completion) allow a client to ask an LSP server to complete a given fragment of text.

### Default Implementation in AnyText

By default, AnyText creates completions for literal rules (to complete the literal) and for [reference resolve rules](../api/NMF.AnyText.Model.ResolveRule-2.yml) (to suggest possible references).

### Customizations

The completion are handled by the method *SuggestCompletions* of the class [Rule](../api/NMF.AnyText.Rules.Rule.yml). In case of a [reference resolve rule](../api/NMF.AnyText.Model.ResolveRule-2.yml), the calculation of suggestions can be customized by overriding the methods *GetReferenceString* (to adjust how the referenced elements appear in text), *CreateCompletionEntry* (to adjust how the completion entry is constructed altogether) or *GetCandidates* (to modify the calculation of candidates for references). By default, the calculation of candidates is delegated to the parse context where it also can be customized.
