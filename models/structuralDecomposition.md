# Refinements and Structural Decomposition

This page is taken from the paper [Modeling a Warehouse system using refinements and decomposition: A contribution to the MULTI Warehouse challenge](https://doi.org/10.1145/3652620.3688209).

In a metamodel, structural properties of a metaclass are often de-
scribed by attributes and references, in Ecore for example referred
to as structural features. The goal of our structural decomposition and
refinements approach is to be able to decompose this structure as
we specialize the metaclasses.

## Structural Decomposition

A list of features $f_1, \ldots, f_n$ is a *structural decomposition* of $f$, if we have that for each $a \in A$ that

$$f(a) = f_1(a);\ldots;f_n(a). $$

Here, the semicolon indicates the concatenation. We say that the $f_1,\ldots,f_n$ are the components of $f$ and call $f$ the composition of $f_1,\ldots,f_n$.

For example, a class *Car* may want to decompose a wheels reference inherited from a class *Vehicle* into four references, namely
the front left wheel, the front right wheel, the rear left wheel and the rear right wheel.

Since there is an embedding from single-valued features into multi-valued features, we will
also allow the features used for decomposition to be single-valued where we use `null` to depict empty collections.
Similarly, we allow compositions to be single-valued. In this case, the value of the composition has to match the
only component value that is not `null`.

## Refinement

A refinement of a feature is a feature with a more concrete type. In the example above, the individual wheel references are not just generic wheels, but might be specific ones.

An important special case is the refinement by constant features. Usually, constant
features are not explicitly modeled as they do not contain any
information specific to an instance, but in combination with a
refinement, they may carry information that is known for some
subtypes, but not in the general case.

Refinements by constants can be used to cut off
features. For example, one could model that vehicles optionally
have engines. A bike as a vehicle could refine this engine reference
with a constant reference returning nothing in order to model that
bikes have no engines.

Refinements and structural decomposition can be
combined. For example, we could model that the wheels of a car
are decomposed into a front left wheel, a front right wheel, a rear
left wheel and a rear right wheel and that all of these wheels are
car wheels.

## Implementation in NMeta

In NMeta, attributes and references have a reference to a refined attribute or reference, respectively.
The semantics is that if there are (potentially multiple) references that refine a base-class reference, then that base-class reference is structurally decomposed and the refining references refine the components of it. This implies the following validation rules, if a reference *r* refines a reference *b*:

- *b* must be defined in a base class of the class declaring *r*
- *r* must have the same type or a derived type of the type referenced by *b*
- The cardinality of *r* must be smaller or equal to the cardinality of *b*. In particular, if *b* is single-valued, *r* must be single-valued as well.

In addition to references refining references, classes can define reference constraints in order to model refinements by constants. A reference constraints also contributes to
the decomposition of a base-class reference, but the contents are not specific to the individual model element and can be empty.

As explained in **[Refinements and Structural Decompositions in Generated Code](https://www.scitepress.org/PublishedPapers/2018/65494/65494.pdf)**, the presence of refinements and structural
decomposition mean that the class generated for a given metamodel class cannot reuse the class generated for the base class but instead, parts of the code are duplicated.
