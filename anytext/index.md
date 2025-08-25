# NMF AnyText

NMF AnyText is an open-source textual language workbench. That is, it is a framework to derive parsers and editor services from a grammar.
AnyText does not contribute any UI. Rather, the editor services are implemented using the Language Server Protocol (LSP) from Microsoft, allowing to
integrate the editor services in a variety of Integrated Development Environments (IDEs) such as Visual Studio Code.

Please take a look at the [paper on AnyText](https://dx.doi.org/10.1145/3732771.3742716).

## Features

AnyText provides the following features:

- **Parser:** AnyText creates a packrat parser to parse a given language based on an extended EBNF grammar
- **Model construction:** Based on a successful parse tree, AnyText automatically creates an NMF model
- **Reference resolution:** During model construction, references to other model elements are resolved automatically
- **Metamodel construction:** AnyText is able to derive the abstract syntax of your language from the concrete syntax and subsequentially generate code for it
- **Incremental change propagation:** AnyText is able to process changes of your text and incrementally update the semantic model instead of recreating it from scratch.
- **Synthesis:** AnyText is able to generate a textual representation for your semantic model automatically based on a few formatting instructions.
- **Editor services:** AnyText can provide editor services through LSP.

The following editor services are supported through LSP:

- **[Semantic Tokens](features/semanticTokens.md)**: AnyText implements semantic tokens to allow to color the text in the editor.
- **[Completions](features/completions.md)**: AnyText can provide customizable code completions.
- **[Document Symbols](features/symbols.md)**: the client can obtain an outline of the document
- **[Folding](features/folding.md)**: code areas can be folded. This is enabled by default for document symbols but can be customized easily.
- **[Diagnostics](features/diagnostics.md)**: AnyText allows you to implement custom diagnostics
- **[Code Lenses](features/codeLenses.md)**: AnyText allows you to implement your own code lenses based on the semantic element.
- **[Code Actions](features/codeActions.md)**: AnyText allows you to implement code actions based on semantic elements.
- **[Selection Ranges](features/selectionRange.md)**: the client can select entire tokens independent of white spaces
- **[Find References](features/findreferences.md)**: the client can find references to a given element
- **[Go to Definition](features/gotodefinition.md)**: the client can find the definition of an element
- **[Rename](features/rename.md)**: the client can consistently rename an element
- **[Formatting](features/formatting.md)**: the client can reformat the text
- **[Hover](features/hover.md)**: the client gets possibly helpful information as a tooltip
- **[Inlay](features/inlay.md)**: the client can be asked to show text inlays that are visible but not actually part of the document

If you need more features, please open an issue and describe the use case.
