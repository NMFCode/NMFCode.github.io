# Model-based Incrementalization

## Overview

NMF provides elementary change notifications, offered
through the industry standard interfaces _INotifyPropertyChanged_ and _INotifyCollectionChanged_. These interfaces are required by many modern user interface
libraries, hence the model representation code can directly be used for these
techniques.

However, NMF is also able to combine these elementary change notifications
to determine when the result of analyses based on a model has changed. Furthermore, an incremental algorithm is inferred to recalculate the analysis upon
a model change more efficiently by the implicit introduction and management
of buffers to save intermediate results. This incrementalization works online, i.e.
the model needs to be kept in memory and changes must be made on the model
elements in memory

The incrementalization has a sound theoretical foundation based on category
theory and is implemented in NMF Expressions. NMF Expressions operates
on lambda expressions, supported by many .NET languages such as C# and
VB.NET in their regular syntax. To realize the incrementalization, the abstract
syntax tree is converted into a dynamic dependency graph on a high abstraction
level. Changes of the model under analysis are then propagated through the
dependency graph, ultimately updating the analysis result.

```csharp
var faultyPositions = from route in routes
        where route.Entry != null && route.Entry.Signal == Signal.GO
        from swP in route.Follows
        where swP.Switch.CurrentPosition != swP.Position
        select swP;
```

As an example, consider the code in `the listing above, taken from the NMF solution
of the TTC Train Benchmark. NMF allows the user to specify queries like
this in regular C# code with all of the tool support provided for this language
and is able to implicitly deduct an incremental evaluation.

The high abstraction level in the dynamic dependency graph is achieved by a
manual incrementalization of analysis operators yielding valid results as a consequence of the underlying formalization as a categorial functor. NMF Expressions
includes a library of such manually incrementalized operators, including most of
the Standard Query Operators (SQO). As a consequence, developers can specify query analyses conveniently through the query syntax such as used in the listing above.

In the following, the strategies are presented how NMF incrementalizes the SQO operators:

## Select

For a _Select_ operator, a dictionary is used to associate every element of the source collection with a dynamic dependency graph representing the result. To save space, duplicates have a special treatment that for the same element in the source collection, the dynamic dependency graph is only created once. Another special treatment is done for `null` values.

There is a static property _KeepOrder_ to decide whether _Select_ operators keep the order of the underlying collection. If this flag is set, enumerating an incremental select enumerates the base collection and returns the current value of the associated dynamic dependency graph. If it is not set, the enumeration will only go through the dynamic dependency graphs and yield their current values.

## Where

The _Where_ operator works similar to a _Select_ and associates every element of the source collection with a dynamic dependency graph, taking extra care for duplicates and `null`s. Similar to _Select_ the _KeepOrder_ flag decides whether enumerations will also enumerate the underlying collection.

## Others

If you are interested how other operators work, please raise an issue.
