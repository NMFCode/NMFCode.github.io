# Opposite collections

NMF often faces scenarios in which adding an element to a collection should raise side effects such as adding the parent element to another collection or setting a back reference. To support such use cases, NMF has a range of opposite collections, [OppositeList](api/NMF.Collections.ObjectModel.OppositeList-2.yml), [OppositeSet](api/NMF.Collections.ObjectModel.OppositeSet-2.yml) and [OppositeOrderedSet](api/NMF.Collections.ObjectModel.OppositeOrderedSet-2.yml). These implementations are very similar but implement different kinds of collections:

* [OppositeList](api/NMF.Collections.ObjectModel.OppositeList-2.yml) implements an array list, i.e., a collection with insertion order, duplicates and fast enumeration. The operations _Contains_ and _Remove_ are linear time, but _Add_ is deterministically O(1) amortized.
* [OppositeSet](api/NMF.Collections.ObjectModel.OppositeSet-2.yml) has the characteristics of a hash set, meaning it is a unique collection without a defined order. Here, _Contains_, _Remove_ and _Add_ are all O(1) but only under the assumption of a perfect hash function.
* [OppositeOrderedSet](api/NMF.Collections.ObjectModel.OppositeOrderedSet-2.yml) is an [ordered set](orderedSet.md) that combines a unique collection with insertion order and fast enumeration.

All opposite collections have a constructor that takes a parent element as a parameter and an abstract method **SetOpposite** that is used to execute the hook for the referenced element. This method accepts two parameters: the item and the new parent. The new parent could either be null or the parent element. The task of _SetOpposite_ is to set the opposite reference.

Note that the opposite collection classes do not ensure a specific order of operations. That means, it should not matter in which order a user performs a given operation. Hence, ideally operations performed within _SetOpposite_ should be idempotent.
