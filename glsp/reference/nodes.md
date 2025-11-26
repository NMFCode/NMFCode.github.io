# Specifying nodes in NMF GLSP

The class generally responsible to specify a node in NMF GLSP is the [NodeDescriptor](../api/NMF.Glsp.Language.NodeDescriptor-1.yml). A node descriptor describes how a model element of the semantic model manifests in a node in the diagram. All of the styling options for [elements](elements.md) also apply to nodes.

## General Layout

In general, the visuals of a node like its shape or colors are handled by the GLSP client. The task from the GLSP server is rather to describe how the node for the semantic model element is structured, like what labels and other elements it consists of. In a class diagram, for instance, a class is represented by the following elements:

- A box representing the hull of the class
- A label with the name of the class
- Optionally further labels for stereotypes (for instance to specify that it is in fact an interface or abstract)
- Dividers to separate the different compartments
- Labels for the attributes and operations

It is important to understand that these elements are not just a plain list but themselves have a structure. In particular, the label for the classes name and for stereotypes must be inside the first compartment, while labels for attributes go into separate compartments, each.

In order to specify this, the [NodeDescriptor](../api/NMF.Glsp.Language.NodeDescriptor-1.yml) offers a range of methods:

- **Nodes** specifies that the element created for the semantic model element should have a collection of child elements where the child nodes are described by the specified node descriptor.
- **[Edges](edges.md)** specifies that the element created for the semantic model element should have a collection of inner edges where the edges are described
     1. either by a pair of node descriptors (in this case, the selector function should return a collection of pairs of model elements) or
     2. a single edge descriptor (in this case, the selector function should return a collection of model elements representing the edges)
- **[Labels](labels.md)** specifies that the element created for the semantic model element should have a collection of labels where each label is described by the specified label descriptor.

## Compartments

Often, it is necessary for the diagram to group child elements visually. For instance, a UML class diagram separates the labels generated for the name of a class from the labels created for attributes and those are again separated from the labels created for methods. In order to support this, NMF GLSP uses the notion of compartments.

Compartments are specified using the method [Compartment](../api/NMF.Glsp.Language.NodeDescriptor-1.yml#NMF_Glsp_Language_NodeDescriptor_1_Compartment_System_String_NMF_Glsp_Language_Layouting_LayoutStrategy_System_Linq_Expressions_Expression_System_Func__0_System_Boolean___). This method returns an *IDisposable* object that is meant to be used to control a `using` block. That is, if other elements (as above: child nodes, edges or labels) should appear inside a compartment, the method calls should be done inside a using block.

```csharp
using (Compartment("comp:attributes"))
{
    Labels(D<AttributeDescriptor>(), e => e.Attributes);
}
```

The listing above demonstrates this to create a compartment for attributes and the labels of a class inside this compartment. If you omit the type of the compartment, the compartment type `comp` is used by default.

Compartments can be nested, but currently there is no option to guard their presence.

## Child element layout

The method **Layout** specifies a given layout strategy. By default, inner nodes are laid out in absolute coordinates, typically manually. For some nodes, an automatic layout is desirable. Here, NMF GLSP has some predefined layout strategies:

- **[VBox](../api/NMF.Glsp.Language.Layouting.LayoutStrategy.yml#NMF_Glsp_Language_Layouting_LayoutStrategy_Vbox)** specifies that the elements are laid out automatically by placing them vertically.
- **[Hbox](../api/NMF.Glsp.Language.Layouting.LayoutStrategy.yml#NMF_Glsp_Language_Layouting_LayoutStrategy_Hbox)** specifies that the elements are laid out automatically by placing them horizontally.
- **[FreeForm](../api/NMF.Glsp.Language.Layouting.LayoutStrategy.yml#NMF_Glsp_Language_Layouting_LayoutStrategy_FreeForm)** specifies that the elements are laid out manually (this is the default)

Layout strategies can also be specified as an optional argument to a compartment. Otherwise, the method **Layout** is also effective for the current skeleton and thus can be nested in compartment sections.

## Embeddings

There is a dedicated method **[Embed](../api/NMF.Glsp.Language.NodeDescriptor-1.yml##NMF_Glsp_Language_NodeDescriptor_1_Embed_NMF_Glsp_Language_NodeDescriptor__0__System_Linq_Expressions_Expression_System_Func__0_System_Boolean___)** to embed another descriptor inside the current node. This is particularly useful if you need to reuse the description of the root element in other places as well in order to replicate the structure of the drawing canvas inside some inner element.
