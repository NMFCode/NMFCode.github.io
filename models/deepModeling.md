# Deep Modeling

This page is taken from the paper [Modeling a Warehouse system using refinements and decomposition: A contribution to the MULTI Warehouse challenge](https://doi.org/10.1145/3652620.3688209).

Many domains include concepts that have a non-transitive *is-a*
relationship. A mobile phone device is a mobile phone and mobile
phone is a product type but the actual phone is not a product type.
In traditional two-level modeling, this fact is ignored and hence
often mitigated by highly complex constraints and unnecessary
generic models, leading to a high accidental complexity.

To overcome this limitation, [NMF supports deep modeling through refinements and decomposition](https://dx.doi.org/10.1007/s10270-018-0701-6).
The core idea is to use the ability of the
class *Class* that its instances can be instantiated in a broader sense,
i.e. whenever an element is a clabject. If needed, we refine and
decompose the features of *Class* in order to describe these features
in domain-specific terms rather than general language terminology.
The main advantage of this concept is that deep modeling can be
implement as a slight, largely compatible extension to an EMOF-like
meta-metamodel.

Instantiation relationships can be modeled using structural decompositions and refinements. For us, transitivity is the key difference
between the two *is-a* relationships specialization (which is transitive) and instantiation (which is not). This difference is
tremendously important for NMF.

Because *Class* is an element that describes the modeling language,
the instantiation relationship of *Class* is often called a linguistic
instantiation meanwhile instantiation relationships between
domain elements are referred to as ontological instantiation. The
core idea of the approach is to reuse this characteristic of *Class* in
a broader scope and therefore tear down the difference between
linguistic and ontological instantiation by making the latter a refinement of the former.

Whenever we conceptually face a clabject, an element that is
simultaneously a class and an object, the type of this element
when considered an object must inherit from *Class*. This way,
we inherit the ability that its instances (i.e., the clabjects) can be
instantiated again. This instantiation is a non-transitive relationship
and therefore satisfies the requirements we have for deep modeling.

Remarkably, inheriting from *Class* in order to turn a specific
model element to a clabject is only required if the modeling levels
to be crossed really are instantiation levels. In case there are just
specialization levels such as in the case of the [vehicles example](./structuralDecomposition.md),
inheriting from *Class* is a rather bad idea as it disrespects the
transitive nature of specialization.

Instantiation typically means that the properties that one model element has depend on another model element.
This is for instance common in e-commerce applications, which is why deep modeling is applied in such domains.
Other examples include component-based software architectures where the references to other components are determined by
the type of component. In these cases, it can be beneficial to model the type element as a class that inherits from *Class*.

Inheriting from *Class* means that instances automatically inherit the features from *Class* such as attributes and references. This can be useful
in some scenarios. Iin the model of a warehouse system, one just wants to be able to define attributes for a given product type. In other scenarios,
the domain might require some restrictions. For instance, the references of a software component are determined by the provided and required interfaces.
In these cases, the reference *References* needs to be decomposed.

If instantiation levels are used, often we have that a class characterizes another (in terms of Carvalho et al.), for example product specifications characterize products
or component types characterize components. This is useful because the code generator is able to generate a more specific API: If it knows that the required
interface of a component refine the *References* and a model element can have model elements assigned to a reference, the code generator generates an API
to obtain the model element referenced by a given specific required interface. Furthermore, NMF also generates the necessary [proxy implementations](../expressions/proxies.md) to
allow for incremental change propagation.

For examples, see how deep modeling in NMF is applied to model [a warehouse](https://dx.doi.org/10.1007/s10270-018-0701-6) or [software architectures](https://doi.org/10.1007/s10270-018-0701-6).
