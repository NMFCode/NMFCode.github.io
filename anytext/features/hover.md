# Hover

[Hover](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_hover) allows to provide tooltips for given parts of the text. This can be used for instance to provide help information.

## Default Implementation in AnyText

By default, no hover text is provided, but the service is implemented traversing up in the parse tree and asking every rule along to provide a hover text.

## Customizations

Hover texts can be customized by overriding the method *GetHoverText* of the class [Rule](../api/NMF.AnyText.Rules.Rule.yml). Because the default implementation refers to the parent in the parse tree, overriding this method affects all tokens within the range of the given rule, unless there is a more specific implementation of it.
