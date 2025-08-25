# Execution Strategies

## Introduction

If a single artifact is used from multiple places, it can happen that changes are propagated inconsistently. For instance, consider the function $f: a \mapsto (a+1) \cdot (a+2)$. If $a$ changes, both the calculations $a+1$ and $a+2$ will notify that their value was changed. However, it is important that the value of a calculation $f(a)$ is only forwarded once both $(a+1)$ and $(a+2)$ notified their value change as otherwise, $f(a)$ could produce phantom values, i.e., values that are no possible outcomes of the function. In the example, it is clear that _f_ always returns an even number, but if the value of $f(a)$ is updated before both $(a+1)$ and $(a+2)$ are propagated, this might not be the case.

NMF Expressions therefore controls execution of change propagations through execution metadata. This metadata mainly consists of two numbers: the first one indicating how many dependencies might be affected by a given change, the other how many dependencies have been processed. In the above example, when _a_ changes and the expression $(a+1)$ has been processed to alter its value, the change of $f(a)$ is not processed because there is another dependency that might be affected by the change, namely $(a+2)$. For this, NMF Expressions uses a two-pass algorithm to first check the possible consequences of a change before propagating it.

In order to propagate multiple changes at once, NMF Expressions implements a transaction system. That is, if multiple changes have to be propagated in a consistent way, one can use the static methods _BeginTransaction_, _CommitTransaction_ and _RollbackTransaction_ of the class **[ExecutionEngine](api/NMF.Expressions.ExecutionEngine.yml)** to start, commit or rollback a change propagation transaction.

## Execution Engines

NMF Expression implements multiple strategies how incremental changes are to be propagated:

* **[SequentialExecutionEngine](api/NMF.Expressions.SequentialExecutionEngine.yml)** propagates changes in a single thread. Whenever a change does not need to be propagated, change propagation stops immediately, unless a transaction was started.
* **[ParallelExecutionEngine](api/NMF.Expressions.ParallelExecutionEngine.yml)** propagates changes in parallel.
