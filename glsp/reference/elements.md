# General element descriptions

This page describes specifications shared between descriptions of nodes, edges and labels.

## Element Types

By default, all elements described by an element descriptor end up as elements in the graphical model and as such, they have a type. By default, the type of these elements is the name of the class of the elements where the prefix `I` is trimmed in case of interfaces. To disambiguate or to refine this, one can override this behavior by overriding the [ElementId](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_ElementTypeId) property.

## Element Creation and Profiles

The class [ElementDescriptor](../api/NMF.Glsp.Language.ElementDescriptor-1.yml) is also used to create semantic model elements if the corresponding graphical elements are added to the canvas. For this purpose, NMF GLSP iterates all element descriptors to populate the palette of the editor. If elements from the palette are inserted in the canvas, NMF GLSP uses the method **[CreateElement](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_CreateElement_System_String_System_Object_)** to create the semantic model element.

However, it is often also desirable to multiple entries in the palette representing to add the same elements in the drawing canvas but with different options. To support this, NMF GLSP uses profiles. Profiles are named configurations for elements. They are defined simply by declaring them inside the **DefineLayout** method. If the user uses a profile button in order to insert elements into the canvas, the name of the profile ends up as an argument to the **CreateElement** method. If the user uses the default option for this element, the `profile` argument will be `null`.

The name of the tool in the palette to add elements to the drawing canvas is controlled by the method **[ToolLabel](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_ToolLabel_System_String_)**. This method is virtual and thus allows customizations.

## Refinements

NMF GLSP supports a kind of rule instantiation similar to [NMF Transformations](../../transformations/index.md). However, the method has been renamed to **[Refine](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_Refine__1_NMF_Glsp_Language_ElementDescriptor___0__) as we believe this is more intuitive.

The effect of this specification is that NMF GLSP will use this rule instead of the refined rule whenever the true element type matches the element type of the refining rule. Note that whereas NMF Transformations and NMF Synchronizations also support rule instantiation by custom guards, NMF GLSP currently only supports refinements by type.

## CSS Classes

Because SVG can be styled using CSS classes, NMF GLSP has multiple options to specify the CSS class of an object through overloads of the **CssClass* method:

- One can [select a CSS class generically](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_CssClass_System_Linq_Expressions_Expression_System_Func__0_System_String___) with a lambda expression returning the name of the CSS class or
- One can [select a CSS class statically and define a guard](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_CssClass_System_String_System_Linq_Expressions_Expression_System_Func__0_System_Boolean___) where the guard is again typically specified as a lambda expression. The guard can be `null` in which case the CSS class is assigned statically.

Note that assigning a CSS class statically does nothing more than increasing the payload of the GLSP communication and the CSS class can also be predefined at the client.

## Forwards

NMF GLSP also allows to forward properties of the semantic model element to the graphical element, in case the frontend uses custom renderers that require those. There is a pair of methods **Forward** that attach data either unconditionally (which again effectively just increases the payload) or dynamically.

To forward data to the graphical element, use the method **[Forward](../api/NMF.Glsp.Language.ElementDescriptor-1.yml#NMF_Glsp_Language_ElementDescriptor_1_Forward_System_String_System_Linq_Expressions_Expression_System_Func__0_System_Object___)**. You can forward any kind of data as long it can be converted to JSON. NMF GLSP will use the default JSON converter to convert the object to a JSON message.

## Operations

Element descriptors also generically allow to specify custom operations. Custom operations are used to populate the context menu of a graphical element. Operations have a name (that is used to populate the menu entry) and a callback that is executed when the operation is to be performed.

Note that operations in GLSP are executed within the transaction controller of NMF such that any changes made to the semantic model as a consequence of the operation will become part of the undo/redo stack.

## Selections

If a GLSP client uses the selection actions to notify the server that some elements have been selected, the GLSP server session forwards this information to the attached model server to define the selected elements. This may result in other services such as the property service to send updates to their clients.

However, selection in GLSP is based on the graphical elements. When setting the selection at the model server, NMF GLSP resolves the graphical elements to the semantic model elements that these are created from in order to determine the selection. However, in some cases such as bidirectional references in a class diagram, a single graphical element can represent multiple model elements in the semantic model. In order to support such scenarios, all element descriptors can specify selection includes.

Note that selection includes are not evaluated incrementally but statically everytime the selection changes through GLSP.
