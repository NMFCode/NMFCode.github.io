# Proxies

NMF Assumes that the result of a method call only changes if the identity of either the target object (if any) or any of the arguments changes. Of course, this is often not the case because the contents of an object may change rather than their contents. Because NMF does not decompose IL code, it needs to have a proxy method that can be called instead and that could inform the change propagation infrastructure that the result of the method has changed.

For this, NMF uses an attribute called **[ObservableProxyAttribute](api/NMF.Expressions.ObservableProxyAttribute.yml)**. With this attribute, a developer can specify the name of another method that NMF will call instead. The following signatures for proxy methods are supported:

* In the simplest form of a proxy method, the parameters are the same as in the original method, but the result of the method is an _[INotifyValue](api/NMF.Expressions.INotifyValue-1.yml)_ or _[INotifyExpression](api/NMF.Expressions.INotifyExpression-1.yml)_ of the original method's result type. Such proxy methods are called whenever the arguments of a method call change. This form is recommended if the entire structure is voided upon a change of arguments.
* Alternatively, the proxy method may also take parameters wrapped in _[INotifyExpression](api/NMF.Expressions.INotifyExpression-1.yml)_ and the result type as well. In this case, the proxy method is called during construction of the dynamic dependency graph and then never again. Here, the proxy method can freely manage DDG nodes upon a change.

The proxy of a static method must be a static method. The proxy of an instance method can be a static method but this has to take the target object as an additional first argument. The proxy of a generic method must be generic. Here, generic type parameters of the method and all surrounding types are counted together.

The [ObservableProxyAttribute](api/NMF.Expressions.ObservableProxyAttribute.yml) additionally takes a parameter whether it is recursive. Use this flag only if recursion is intended. It means that the proxy is evaluated lazily in order to supress endless loops, but this requires additional memory.
