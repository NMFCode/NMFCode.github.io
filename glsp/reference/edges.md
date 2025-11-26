# Specifying edges in NMF GLSP

The class generally responsible to specify an edge in NMF GLSP is the [EdgeDescriptor](../api/NMF.Glsp.Language.EdgeDescriptor-1.yml). An edge descriptor describes how a model element of the semantic model manifests in an edge in the diagram. All of the styling options for [elements](elements.md) also apply to edges. Alternatively, there is also a base class with two generic type arguments that is used to describe edges between two node descriptors.

## Source and Target nodes

When an edge is drawn in the drawing surface, it typically has a semantic meaning where it starts and where it ends. Due to a limitation in the underlying Sprotty framework, edges start and stop at nodes. It is not possible to have edges starting or ending at other edges.

To have a more consistent API, the configuration how to set the source and target of the edge is also done in the **DefineLayout** method by calling the methods **[SourceNode](../api/NMF.Glsp.Language.EdgeDescriptor-1.yml#NMF_Glsp_Language_EdgeDescriptor_1_SourceNode__1_NMF_Glsp_Language_NodeDescriptor___0__System_Linq_Expressions_Expression_System_Func__0___0___System_Boolean_)** and **[TargetNode](../api/NMF.Glsp.Language.EdgeDescriptor-1.yml#NMF_Glsp_Language_EdgeDescriptor_1_TargetNode__1_NMF_Glsp_Language_NodeDescriptor___0__System_Linq_Expressions_Expression_System_Func__0___0___System_Boolean_)**.

Both methods should be called exactly once as they are overriding previous behavior. In both methods require to specify a node descriptor and a selector where in the semantic model the information about the source or target is stored. NMF GLSP uses this information to reconnect an edge to a different target object and the information to a target descriptor to decide whether routing an edge to a given element should be allowed. It is only possible to define a single descriptor as possible target, but refinements of this descriptor are also valid targets.

## Routing Options

The method used to route edges is specified through the property **RouterKind**. This property is virtual and allows clients to override this behavior.

## Labels along the edge

Edges can define labels that occur along the edge. The [general configuration options for labels](labels.md) apply and the label can be placed along the edge.
