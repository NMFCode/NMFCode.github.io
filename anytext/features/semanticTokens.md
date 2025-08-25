# Semantic Tokens

[Semantic Tokens](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens) are used by the client to override the syntax highlighting potentially done by the client. Because AnyText uses a scannerless packrat parser, syntax highlighting cannot be done by a lexer in general as the same word can have multiple meanings in different contexts and tokens are not always separated by white spaces or delemiter characters.

## Default Implementation in AnyText

By default, AnyText iterates the tokens created by the parser to respond to a semantic tokens request. In order to classify the tokens, the following heuristic is implemented by default:

- Literal rules that contain alphabetic literals produce *keyword*s
- Literal rules that do not contain alphabetic characters produce *operator*s
- Terminal rules that are typed as strings produce *string*s

## Customization

Semantic tokens can be customized by overriding the property *TokenType* and *TokenModifier* on the class [Rule](../api/NMF.AnyText.Rules.Rule.yml). The property is typed as string, but please be aware that clients typically only have a limited set of token types and modifiers that they interpret. The token types and modifiers supported by Visual Studio Code are listed in the [spec](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens). 

AnyText automatically takes care of compressing tokens in the format that is expected by LSP.

Please note that currently, AnyText does not support incremental updates of semantic tokens.
