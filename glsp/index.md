# NMF GLSP

NMF GLSP is a framework to develop graphical DSLs through the Graphical Language Server Protocol (GLSP). In particular, NMF GLSP is a framework to develop GLSP servers that connect to NMF models. The rationale is that the language engineer only has to develop the synchronization of the semantic model with the graphical model that is exposed via GLSP and subsequently rendered through existing GLSP client libraries such as [Eclipse GLSP](https://eclipse.dev/glsp/).

For a start, we recommend to read the [paper on NMF GLSP](https://dx.doi.org/10.5381/JOT.2025.24.2.A11). Some parts of the documentation are taken from this paper.

## Language Structure

NMF GLSP provides the basis for the implementation of a concrete graphical language server. Such an
implementation comprises the specification of the graphical
language via NMF-GLSP and the invocation of this specification via dependency injection. The remaining server-side
tasks (GLSP protocol implementation, model manipulation, undo/redo) have not to be specified via the DSL. They are either
independent of the specific graphical model language or can be inferred by our framework from the DSL-based specification of
the graphical language.

The basic idea of our DSL is very similar to the construction of
[NMF Synchronizations](../synchronizations/index.md), which in turn is based on the construction of the [NMF Transformation Language](../transformations/index.md): A graphical language is represented by a class that inherits from [GraphicalLanguage](api/NMF.Glsp.Language.GraphicalLanguage.yml) and consists of rules as nested
classes that inherit from a few abstract base classes provided by the DSL. In order to create the rules for the synchronization, the
GraphicalLanguage class instantiates each nested type and generally identifies rules with their type. Then, synchronization
blocks are specified as calls inside a method _DefineLayout_.

As the API knows the target model statically, the available methods
represent synchronization blocks tied to specific [lenses](../expressions/lenses.md) at the
graphical model.

The DSL defines three base classes, all of which take the
semantic element type as a generic type parameter:

- **[NodeDescriptor\<T>](api/NMF.Glsp.Language.NodeDescriptor-1.yml)** for isomorphisms describing how to render a semantic model element as a node
- **[EdgeDescriptor\<T>](api/NMF.Glsp.Language.EdgeDescriptor-1.yml)** for isomorphisms describing how to render a semantic model element as an edge
- **[LabelDescriptor\<T>](api/NMF.Glsp.Language.LabelDescriptor-1.yml)** for isomorphisms describing how to render a semantic model element as a label.

[EdgeDescriptor\<T>](api/NMF.Glsp.Language.EdgeDescriptor-1.yml) defines methods for the creation of synchronization blocks for the source and target of the
respective edge or labels along the edge. NodeDescriptor defines methods to create synchronization blocks to denote
child nodes, edges, compartments and child labels.

The [LabelDescriptor\<T>](api/NMF.Glsp.Language.LabelDescriptor-1.yml) class only defines methods to adjust
the label text. All of these classes inherit methods to adjust the
type attribute of the graph elements (which the client uses to
decide how the element is rendered), configure the CSS classes
and forward information as static content.

In all cases, the classes representing the isomorphisms are
also responsible for the creation of new elements. NMF provides
reflection-based instance creation for generic type parameters
(even if the generic type parameter is the interface for a meta-
model class), but typically one wants to create pre-initialized
objects. Therefore, all these classes have a common generic
base class [ElementDescriptor\<T>](api/NMF.Glsp.Language.ElementDescriptor-1.yml) that allows to override the
creation of new elements.

The major advantage of this construction is that, like NTL
and NMF Synchronizations, our DSL can inherit modularization
concepts from the host language, i.e., it is rather easy to create
reusable DSL modules and inherit the tool support from the host
language.

## Generating Children

As an example of this usage, the listing below sketches how to
create a synchronization block defining that the semantic elements of a property States should be rendered using the
rule `StateDescriptor`:

```csharp
protected override void DefineLayout()
{
    Nodes(D<StateDescriptor>(), m => m.States)
}
```

This listing uses a method _D_ that selects the rule instance of a given rule type. The lens `.States`
is denoted through its GET operation. NMF [infers](../expressions/lenses.md) the PUT operation as well as the types and
the lense of the left model from the context. The left lense
`ChildNodes[type="State"]` is automatically derived from the
generic GLSP graphical model structure.

## Labels

Next to creating child nodes, another frequent requirement
is to generate a label element for each semantic element and
synchronize the text shown in this label with an attribute in the
semantic model such as e.g., the name.

Creating a label with a text synchronized with a specific
attribute is a frequent use case. This has dedicated support in
the DSL. In particular, a minimal implementation is depicted
below:

```csharp
Label(e => e.Name);
```

There are further parameters available to specify
guards, fix the position of the label, to provide a custom PUT
method or to specify explicitly whether users are allowed to edit
the label text.

## Compartments

Frequently, especially in UML, nodes can have compartments. Therefore, compartments have a dedicated support in
our DSL: The rules derived from [NodeDescriptor](api/NMF.Glsp.Language.NodeDescriptor-1.yml) are responsible for a node and a hierarchy of compartments instead of only
a single element. To visually indicate these compartments, we use the using-syntax in C#:

```csharp
using (Compartment("comp:header"))
{
    Label(e => e.Name);
}
```

In order to support inheritance in the semantic model, we
also introduce the concept of refinements in the isomorphisms.
This means, an isomorphism class can refine another if it describes a more concrete semantic element type. In this case,
the synchronization blocks of both the refined and the refining isomorphism are used.

## Invocation

NMF GLSP integrates with  ASP.NET Core: n order to expose
a given graphical language to a GLSP server, the language
needs to be added to the ASP.NET Core dependency injection
container and another call is necessary to expose the GLSP
server on a given path. We created an API that integrates with
the minimal API provided by ASP.NET Core.

For example, a given language `StateMachineLanguage` can be exposed as follows:

```csharp
var builder = WebApplicationBuilder . Create () ;
builder.Services.AddWebSockets(opts => { }) ;
builder.Services.AddGlspServer() ;
builder.Services.AddLanguage<StateMachineLanguage>() ;
// add more services ...
var app = builder.Build();
app.UseWebSockets();
app.MapGlspWebSocketServer("/glsp");
app.Run();
```

NMF GLSP uses the [StreamJsonRpc](https://github.com/microsoft/vs-streamjsonrpc) library to implement the GLSP protocol and thus, there are also other transports supported than web sockets.

## Complete Example

The [paper on NMF GLSP](https://dx.doi.org/10.5381/JOT.2025.24.2.A11) explains how to use NMF GLSP for a class diagram editor.
