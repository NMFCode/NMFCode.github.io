# AnyText Grammar

## Grammar declaration

A grammar declaration in AnyText starts with the keyword `grammar`, followed by the name of the grammar. If you generate a metamodel from the grammar, the name of the grammar will be the name of the resulting namespace.

You can add a language ID in parantheses. In an LSP server, this language name is used as the language ID. It shoulbe be globally unique as clients such as Visual Studio Code might otherwise confuse your language with others. If you generate a metamodel from your grammar, the language id is also used as the prefix.

The grammar declaration is concluded with the name of the root rule.

## Imports

Grammars can specify imports. These can be imports to files containing either grammars or metamodels or it can be URIs of those.

An import is specified using the keyword `imports`, followed by the import specification as a relative or absolute file path or URI.

## Comments

Immediately after the imports, you can define comments for your language. The declaration of a comment starts with the keyword `comment`, followed by a character sequence that indicates the start of the comment in single quotes. Optionally, a comment declaration can also specify a stop indicator. If a comment declaration does not define a stop indicator, it is handled as a single-line comment, i.e., the comment includes all characters until the end of the line. If a comment specifies a stop indicator (by using the keyword `to` followed by the indicator in single-quotes), the comment is a multi-line comment.

For example, the C-like single-line comment can be specified as

```bash
comment '//'
```

The C-like multi-line comment can be specified as

```bash
comment '/*' to '*/'
```

Escape rules inside comments are not supported.

## Rules

The heart and soul of a grammar is the collection of [rules](rules.md).
