# Ordered Sets

The base class library does not have an implementation of a collection that ensures that items are unique but defines an order (insertion order), so NMF adds one: The _[OrderedSet](api/NMF.Collections.Generic.OrderedSet-1.yml)_ implements an order set by combining both a hashtable-based set and an array list. The former is used to quickly answer contains queries and the latter is used to obtain a stable order.

This implementation has the following asymptotic complexities:

* **Add** should be O(1) in the average case because both adding an item to a hash table and to an array list has O(1) effort, assuming a perfect hash function and based on amortized analysis.
* **Remove** is O(n) because removing an item from an array list takes linear time
* **Contains** is O(1) thanks to the lookup in the hash table

Add will check uniqueness by adding the item to the underlying set and if that succeeds, the item is added to the array list as well.

The implementation is not thread-safe.
