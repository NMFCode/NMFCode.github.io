# Dynamic Models

Through a dedicated NuGet package `NMF-Models-Dynamic`, NMF supports loading models for which no model code is present.

This can be achieved using the class **[DynamicModelSerializer](api/NMF.Models.Dynamic.Serialization.DynamicModelSerializer.yml)**. This class is seeded with a package from which model elements are read and then uses the class **[DynamicModelElement](api/NMF.Models.Dynamic.DynamicModelElement.yml)** to represent these models in memory. This class supports the reflection-like model API and respects the behavior of the metamodel.
