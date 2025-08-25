# Program Inversion and Lenses

Sometimes, it is not only interesting when the result of a function changed, it is also useful to obtrude a value, i.e., to invert the function. This is also supported by NMF by a mechanism first introduced by Foster et al. called lenses.

The idea of a lens is simple: Given a function $f: A \rightarrow B$ acting as a get, the corresponding put function is a function $g: A \times B \rightarrow A$ that takes an original value and the obtruded value and returns the "new original".

Lenses are abstractions of properties and should fulfill two core well-behavedness properties: Put-Get and Get-Put.

* Put-Get means that when we put what is already there, the original does not change. That is, for every $a \in A$, we have that $g(a, f(a)) = a$.
* Get-Put means that when a value is stored using _put_, _get_ returns it afterwards. That is, for every $a \in A, b \in B$ we have that $f(g(a,b)) = b$.

In the scope of NMF, lenses have been extended to the notion of _in-model-lenses_ that further take a global state space into account and require that the getter function _f_ is side-effect free.

Lenses can be composed to a certain degree. That is, if $(f_1,g_1)$ and $(f_2,g_2)$ are lenses, under some conditions $(f_2 \circ f_1, (a,c) \mapsto g_1(a, g_2(f_1(a), c)))$ is also a lens. NMF implements this composition of lenses such that for some given functions, a lens put can be obtained automatically.

NMF can execute program inversion based on lenses with the static method _CreateSetter_ of the class _[SetExpressionRewriter](api/NMF.Expressions.SetExpressionRewriter.yml)_. The result is a code expression of the inverted function that can then for instance get compiled.

```csharp
var setter = SetExpressionRewriter.CreateSetter( i => i.Item + 42 ).Compile();
setter.Invoke(i, 45); // Sets the property Item to 3 (result of 45 - 42)
```

NMF allows to specify a put function to turn a given function into a lens explicitly through the [LensPutAttribute](api/NMF.Expressions.LensPutAttribute.yml). Because .NET does not allow to reference a method directly, this attribute references the type and name of the put function. These attributes are honored during program inversion.

NMF distinguishes a special case, namely that the returned new original is always the same as the original value, e.g., because the obtruded value can be saved in a property. This is indicated by the signature of the put function to return `void` instead of `A`. Such a lens is called a _persistent lens_.
