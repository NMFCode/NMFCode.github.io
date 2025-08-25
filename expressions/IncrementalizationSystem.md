# Incrementalization Systems

The process of turning a lambda expression into an notifiable expression is called incrementalization and is abstracted in NMF behind the interface **[INotifySystem](api/NMF.Expressions.INotifySystem.yml)**. The default implementation of such an incrementalization system is the [Instruction-level Incrementalization](api/NMF.Expressions.InstructionLevelNotifySystem.yml) that turns every node in the abstract syntax tree into a node in the dynamic dependency graph.

However, this is not the only implementation provided by NMF. However, the other implementations rely on objects being models such that NMF can understand the hierarchy.

## Promotion Notify System

An alternative incrementalization system is the [Promotion Notify System](api/NMF.Expressions.PromotionNotifySystem.yml). The idea here is that the incrementalization system attempts to obtain all necessary events that required elements have changed from the parameters. If this cannot be done, required expressions are promoted to arguments.

For example, consider the following hypothetical example of a function that returns the full name of a person:

```csharp
string GetFullName(IPerson p) => $"{p.Name} {p.Family.Name}";
```

Here, the name of a person is an attribute and hence, changes to this attribute could be listened to by registering to the _PropertyChanged_ event of the _INotifyPropertyChanged_ interface.

However, this unfortunately does not work for the expression `p.Family.Name` because _INotifyPropertyChanged_ allows to register a hook when the _Family_ changes, but not when the _Name_ of the current family changes.

The solution of the promotion notify system is to promote the expression `p.Family.Name` to a parameter. That is, a helper function `GetFullNameHelper(IPerson p, IFamily f)` is constructed such that `GetFullName(p) => GetFullNameHelper(p, p.Family)`. For this helper function, we now have that we can recalculate the entire function whenever the _Name_ of the parameter _p_ changes or the _Family_ of parameter _f_ changes. The deconstruction `GetFullName(p) => GetFullNameHelper(p, p.Family)` is incrementalized using instruction-level incrementalization.

NMF Expression is aware that changes are propagated along compositions through the _BubbledChange_ event. That is, if the _Family_ reference was a composition, the helper function would not be necessary because any changes to the name of the family could also be fetched by listening to the _BubbledChange_ event of _p_. However, modeling the family of a person as a composition would be a flaw because the container is unique and families could therefore only consist of a single person.

Parameter Promotion is designed to support analyses that consist of many stateless operators such as arithmetics or string concatenations.

## Tree Extension Notify System

The [Tree Extension Notify System](api/NMF.Expressions.TreeExtensionNotifySystem.yml) works similar to the Parameter Promotion Notify System. However, instead of introducing a new parameter, the Tree Notify System goes up in the model hierarchy until it finds that all possible changes that could lead to the result of a method to change are captured by the _BubbledChange_ event.

## Configured Notify System

The [Configured Notify System](api/NMF.Expressions.ConfiguredNotifySystem.yml) uses a configuration file to decide which incrementalization strategy to use for a given method.

## Recording Notify System

The [Recording Notify System](api/NMF.Expressions.RecordingNotifySystem.yml) acts as a proxy that executes a default strategy underneath but records the methods for which an incrementalization was requested in order to decide the incrementalization through configuration in the future.

## Choosing a Notify System

One can choose the incrementalization system by setting the property _DefaultSystem_ of the class [NotifySystem](api/NMF.Expressions.NotifySystem.yml) appropriately.
