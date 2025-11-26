# Labels

Labels are simply text boxes that appear somewhere in the drawing canvas. Because labels are very common, they have dedicated support in GLSP through the interface [ILabelSyntax](../api/NMF.Glsp.Language.ILabelSyntax-2.yml). This interface allows a consistent API across several uses of labels. Derived interfaces allow extra configurations depending on the use case.

## Label Types

By default, NMF GLSP assigns the type `label` to all labels. However, if labels need to be differentiated in the client for styling purposes, it is possible to override the type for labels using the method [WithType](../api/NMF.Glsp.Language.ILabelSyntax-2.yml#NMF_Glsp_Language_ILabelSyntax_2_WithType_System_String_).

## Guards

Guards can control the visibility of a label specified by the method [If](../api/NMF.Glsp.Language.ILabelSyntax-2.yml#NMF_Glsp_Language_ILabelSyntax_2_If_System_Linq_Expressions_Expression_System_Func__0_System_Boolean___). They are expressed as lambda expressions returning bool values. NMF GLSP will evaluate these lambda expressions incrementally.

## Validations

Labels can define validation rules that are executed when the user edits the text of a label before that text is applied. This is to give the user an early feedback whether the entered text is valid. Validations can be done either by means of regular expressions or by custom validation functions using the method (and extension method overload) **Validate**.

## Custom Setters

By default, NMF GLSP uses NMF Expressions to invert the selection to obtain an algorithm to set the label. This algorithm is executed once the user changed the label and the new label is fed into the semantic model.

To override or to hide this behavior, one can use the method **[WithSetter](../api/NMF.Glsp.Language.ILabelSyntax-2.yml#NMF_Glsp_Language_ILabelSyntax_2_WithSetter_System_Action__0_System_String__)**. In this method, you can pass a function that takes both the semantic element and the updated text in order to perform whatever operation is necessary. If this method is `null`, NMF GLSP will prohibit the user from changing the label.

## Custom Positions

When a label is added to a node, it is possible to specify its location through the method **At**. This position is the absolute position inside the parent container.

When a label is added to an edge, the method **At** has different parameters and specifies where the label can be placed along the edge.
