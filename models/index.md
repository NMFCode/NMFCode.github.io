# NMF Models

Model-driven engineering (MDE) is getting applied increasingly often both in
industry and academia. Dedicated support to use models for analysis or transformation purposes reduces manual development efforts as repetitive infrastructure
code can be reused. Most of the existing tools that support MDE are currently
based on the Java platform. As a consequence, legacy software built on other
platforms can hardly be reused.

Furthermore, MDE is increasingly applied on mobile platforms where
traditional tools such as Eclipse are difficult to operate and alternatives are
necessary. Ideally, such alternative modeling environments should support as
many platforms as possible to reduce the code duplication in the support for
multiple platforms.

Therefore, NMF Models represents a way to

* [Establish a new meta-metamodel NMeta](./NMeta.md)
* [Represent models and their metamodels in memory](./Repositories.md)
* [Generate model code from a metamodel](./Ecore2Code.md)
* [React on changes in models (and metamodels)](./Changes.md)
* [Record, serialize, deserialize or even invert changes](./RecordingChanges.md)
* [Load and manipulate models without model code](./Dynamic.md)

You can start with your [first NMF project](./FirstNmfProject.md).
