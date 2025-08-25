# Debugging

NMF Expressions supports debugging of dynamic dependency graphs through a dedicated NuGet package `NMF-Expressions-Debug`.

This NuGet package adds an extension method `Visualize` to any [INotifiable](api/NMF.Expressions.INotifiable.yml). What this method does is to export the DDG rooted by this node in [DGML](https://learn.microsoft.com/en-us/visualstudio/modeling/directed-graph-markup-language-dgml-reference?view=vs-2022), save it to a temporary file and using the default application of the operating system to open it. We recommend that you install a DGML extension into your IDE such that this DGML file is opened directly in the IDE, showing you the contents of your DDG.

Alternatively, there is a class [DgmlExporter](api/NMF.Expressions.Debug.DgmlExporter.yml) that allows you to manually export the DDG.
