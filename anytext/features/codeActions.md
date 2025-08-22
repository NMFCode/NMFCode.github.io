## Code Actions

[Code Actions](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_codeAction) allow the client to execute an action based on a given part of the text.

### Default Implementation in AnyText

By default, no code actions are provided.

### Customizations

Code actions in AnyText are again resolved by the rules of rule applications. Thus, when the user selects some text, AnyText goes up in the parse tree and collects code actions along the way. To denote that a rule offers a code action, the property *CodeActions* can be overridden.

The following demonstrates a code action to insert a comment header.

```csharp
protected override IEnumerable<CodeActionInfo<Metamodel.Grammar>> CodeActions => new List<CodeActionInfo<Metamodel.Grammar>>
{
    new()
    {
        Title = "Generate comment header",
        Kind = "refactor.extract",
        CommandTitle = "Insert Comment Header",
        CommandIdentifier = "editor.action.addCommentHeader",
        Action = (g, obj) =>
        {
            var documentUri = obj.DocumentUri;
            if (documentUri != null)
            {
                InsertCommentHeader(documentUri);
            }
        }
    }
};
```

Note that in the above example, *g* denotes the semantic element (which is in this example not considered). Instead of an action, one can also set the *WorkspaceEdit* property to a function in which case the client is asked to perform that edit operation.
