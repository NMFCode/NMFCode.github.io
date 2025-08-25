# Code Lenses

[Code Lenses](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeLens) are text hints that an editor would display above a given text line to denote useful information related to the element described in the text.

## Default Implementation in AnyText

If a rule has a document symbol, AnyText implements a default code lens to return the number of references to this element. Further, when clicking on this element, the client shall execute the command *custom/showReferences*. Clients such as Visual Studio Code extensions are recommended to implement this command and show the default builtin references view.

## Customizations

Custom code lenses can easily be provided by overriding the property *CodeLenses* of any [ModelElementRule](../api/NMF.AnyText.Model.ModelElementRule-1.yml), similar to [Code Actions](./codeActions.md). However, the title of a code lens is usually dynamic, which is why the title of a code lens can be a function to return the actual title.
