# Chunks

There is a separate package that supports chunking of an incremental collection with support for incremental change propagation.

Note that chunking a static collection is well-defined but the incrementalization of it is not. If an element in the middle of a collection is removed, it is unclear whether all of the elements afterwards should be moved.

The implementation therefore foresees an additional parameter to the _Chunk_ extension method to provide a strategy implementation how the chunks are balanced. There are two chunking strategies implemented:

* **[NoBalancingStrategy](api/NMF.Expressions.Linq.NoBalancingStrategy.yml)** does not balance chunks. If items are removed, the resulting chunks are smaller than the maximum size of a chunk.
* **[LazyBalancingStrategy](api/NMF.Expressions.Linq.LazyBalancingStrategy.yml)** removes chunks lazily. That is, if enough items are removed that a chunk can be saved, chunks are merged. Before that, existing chunks are left as is.

Both implemented strategies will fill any existing chunk before creating a new one.

A custom balancing strategy can be implemented using the interfaces _[IChunkBalancingStrategy](api/NMF.Expressions.Linq.IChunkBalancingStrategy-2.yml)_ and _[IChunkBalancingStrategyProvider](api/NMF.Expressions.Linq.IChunkBalancingStrategyProvider.yml)_.
