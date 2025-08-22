## Folding

The [Folding Range Request](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_foldingRange) is used by the client to ask where in a document the editor can offer to fold a range of text.

### Default Implementation in AnyText

By default, AnyText folds document symbols. That means, if a rule is [marked as a document symbol](symbols.md), AnyText creates a folding range of that document symbol, if the document symbol spans multiple lines.

### Customization

Folding ranges are customized by overriding methods of the class [Rule](../api/NMF.AnyText.Rules.Rule.yml). In particular, the method *IsFoldingRange* determines wether an application of this rule is a folding range and because LSP has a dedicated support for imports, there is another dedicated method *IsImports* to determine whether the rule application counts as an import statement.

The type of the folding can be specified by overriding the method *HasFoldingKind*.
