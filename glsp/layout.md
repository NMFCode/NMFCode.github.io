# Layout

## Layout Calculation

In GLSP, the GLSP server is also responsible for creating an
initial layout. For this, NMF GLSP integrates the [Microsoft Automatic Graph Layout library (MSAGL)](https://github.com/microsoft/automatic-graph-layout). A
[GraphicalLanguage](api/NMF.Glsp.Language.GraphicalLanguage.yml) may override the default layouting algorithm. Otherwise, the layout defaults to a rotated Sugiyama layered layout algorithm with rectilinear edge routing.

To change the layout to straight lines, the layout engine can be changed as follows:

```csharp
public override ILayoutEngine DefaultLayoutEngine => new LayeredLayoutService(new () {
    EdgeRoutingSettings = { EdgeRoutingMode = EdgeRoutingMode.StraightLine }
});
```

Next to *[LayeredLayoutService](api/NMF.Glsp.Processing.Layouting.LayeredLayoutService.yml)*, the framework also offers the more general class *[AglLayoutService](api/NMF.Glsp.Processing.Layouting.AglLayoutService.yml)* that makes it easy to integrate arbitrary layout algorithms from MSAGL.

## Layout Storage

NMF GLSP stores layout information in a format that is taken from and therefore compatible with Eclipse Sirius. For this, NMF GLSP automatically stores layout information next to the opened file.
