# Custom Collections

NMF is often able to deduct an incremental change propagation to complex query expressions. However, automatically obtaining edit operations is often not defined. This is sometimes called the view-update problem. It cannot be solved generically as often there is no unique solution.

To aid this situation, NMF provides the class _[CustomCollection](api/NMF.Collections.ObjectModel.CustomCollection-1.yml)_. It implements a collection based on an incremental collection, but leaves the edit operations open to derived classes using abstract methods.
