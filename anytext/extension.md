# AnyText Extension

The extension is contained as a VSIX file that can be added to Visual
Studio Code directly. It can be useful either so experience the amount
of editor support gained by AnyText, or if you want to try out the code
generator to quickstart own AnyText projects.

[!Installing the extension in Visual Studio Code](images/installVsix.png)

The installation of the extension is depicted above, taken from [StackOverflow](https://stackoverflow.com/questions/42017617/how-to-install-vs-code-extension-manually).

The extension is configured to activate on files with extensions
`anymeta` or `anytext` and supports both languages.

The sources of this extension are also available on GitHub, if you
want to inspect the grammars or the manual code for the editor services:
[Extension](https://github.com/NMFCode/NMF/tree/main/AnyText/Tests/AnyTextExtension),
[Server](https://github.com/NMFCode/NMF/tree/main/AnyText/Tests/AnyTextGrammarServer),
[*AnyText* grammar](https://github.com/NMFCode/NMF/blob/main/AnyText/AnyText/AnyText.anytext) and
[*AnyMeta* grammar](https://github.com/NMFCode/NMF/blob/main/AnyText/AnyMeta/AnyMeta.anytext).
