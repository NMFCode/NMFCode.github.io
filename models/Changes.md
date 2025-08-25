# Reacting to model changes

There are multiple ways in NMF how to react to changes in a model:

* The most flexible option is the `BubbledChange` event. This is propagated by NMF along the composition tree. This means, when subscribing to this event at a given model element, you will not only receive changes of this element but also changes from all model elements underneath. The event data [BubbledChangeEventArgs](api/NMF.Models.BubbledChangeEventArgs.yml) reports on the affected element, the feature and the original event data which you can use to obtain changed elements.
* For every single-valued attribute and reference, there are explicit events that occur when a change is in progress (`-Changing`) and when the change occured (`-Changed`). However, you can configure [Ecore2Code](./Ecore2Code.md) to supress these events.
* There is generic events `PropertyChanging` and `PropertyChanged` that support the framework interfaces `INotifyPropertyChanging` and `INotifyPropertyChanged`.

NMF itself implements a [generic change recorder](./RecordingChanges.md) that records events sent from a model.
