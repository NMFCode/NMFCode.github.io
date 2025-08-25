# NMF Synchronizations

Based on [NTL](../transformations/index.md) and [NMF Expressions](../expressions/index.md), NMF also contains a language to synchronize models of heterogeneous metamodels, named **NMF Synchronizations**. Like NTL, it is also implemented as an internal DSL so that developers can
familiarize quickly. This synchronization language is able to support 18 different operation modes out of a single specification: One may choose between three different [change propagation modes](ChangePropagationMode.md) (none, one-way and two-way) and six different
[directions](SynchronizationDirection.md) (left-to-right and right-to-left in three different variants each).

Similar to NTL, a synchronization rule in NMF Synchronizations is represented by a class, inferring the synchronization rules by the public nested classes.
The synchronization rules each define an isomorphism between the classes they
are to synchronize, referred to as left-hand-side (LHS) and right-hand-side (RHS)
class. These classes are passed as generic type parameters.

## Publications

You can find more information on NMF Synchronizations in [the Software & Systems Modeling paper about it](https://dx.doi.org/10.1007/s10270-017-0617-6).

Further, there are a range of TTC papers describing solutions to specific transformation problems:

- [Two NMF Solutions to the TTC2023 Incremental Class to Relational Case](https://ceur-ws.org/Vol-3620/ttc23_paper11.pdf)
- [An NMF Solution to the TTC2023 Containers to MiniYAML Case](https://ceur-ws.org/Vol-3620/ttc23_paper08.pdf)
- [An NMF solution to the TTC2021 incremental recompilation of laboratory workflows case](http://ceur-ws.org/Vol-3089/ttc21_paper9_labflow_Hinkel_solution.pdf)
- [An NMF solution to the TTC 2020 roundtrip engineering case](http://ceur-ws.org/Vol-3089/ttc20_paper4_Hinkel.pdf)
- [Benchmarking bidirectional transformations: theory, implementation, application, and assessment](https://doi.org/10.1007/s10270-019-00752-x)
- [An NMF solution to the Smart Grid Case at the TTC 2017](https://ceur-ws.org/Vol-2026/paper5.pdf)
- [An NMF solution to the Families to Persons case at the TTC 2017](https://ceur-ws.org/Vol-2026/paper6.pdf)
- [An NMF Solution to the Java Refactoring Case](http://ceur-ws.org/Vol-1524/paper9.pdf)
