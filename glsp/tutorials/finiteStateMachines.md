# Finite State Machines Tutorial

This tutorial is designed to guide you through the steps to create your first DSL using NMF GLSP.

## Prerequisites

You will need to install the following software, if it is not already installed:

- Node.js
- NPM
- [.NET SDK](https://learn.microsoft.com/en-us/dotnet/core/install/) (the AnyText generator is compiled for .NET 8 but will roll forward such that newer SDKs should work).

## Installing the Generator

We have a [Yeoman](https://yeoman.io) generator to help you get started by scaffolding a new project. You can install the generator using NPM as follows (we recommend global installation):

```bash
npm install generator-nmfglsp --global --save-dev
```

## Using the Generator

The code generator scaffolds a new NMF GLSP project. You can start it via the command line as follows:

```bash
yo nmfglsp
```

By default, the code generator is interactive and will ask for a range of details such as the name of your language and the features it should generate. Based on this information, the code generator will generate a new directory with the following artifacts already set up for you:

- An NMF GLSP diagram language for state machines
- A C\# project that creates an GLSP server of your language
- A node project that implements the GLSP client
- A web application that packages your GLSP client into a web page
- A standalone web application that shows how to integrate the diagram into existing websites
- A Visual Studio Code extension that integrates the GLSP server (using the web page from above)
- Visual Studio Code launch configurations such that you can easily debug your VS Code extension

These artifacts are set up such that they integrate with each other. For example, the build directory of the LSP server is exactly where the VS Code extension is expecting it. However, the code generator currently does not compile everything, so you need to compile the different projects before running them.

## The generated project structure

The generated folder contains two subdirectories:

- *packages:* This directory contains the frontend projects:
  - the GLSP client
  - the web view displaying the GLSP client
  - the standalone web application
  - the VS Code extension
- *backend:* This is where the magic happens. You will find the definition of your language in `backend/<%= LanguageName %>GLSPServer/<%= LanguageName %>GLSPServer/FsmLanguage.cs`

Besides the GLSP client, the frontend projects are optional and you can choose not to have them generated.

The generated language is a simple state machine language, showing simple finite state machines in the way common in theoretical computer science. In particular, it does not implement all the features of a UML state diagram, but only the very basic features: states, finite states, start states and transitions between states. Transitions can define a trigger, but that is already it.

## Backend

### The Language definition

A graphical language in NMF GLSP is a class inheriting from the class `GraphicalLanguage`. In the case of the generated language definition, the name of the class is `FsmLanguage`, but that name can be changed, of course. The first thing a language needs to define is the language id, called `DiagramType`. The way to specify this is to override the property `DiagramType` and return the language id.

The way that NMF GLSP works is that a language definition consists of rules how different elements of the semantic model manifest in the graphical model. These rules are specified as public nested classes. NMF GLSP automatically creates an instance for each rule type. Whenever you need to reference a descriptor from the language definition itself, use the method `Descriptor` and because it is a frequent scenario, within the rules you can abbreviate this to a simple `D`.

### The root rule

The first step is thus to create a rule how state machines are rendered in the graphical model. In the generated code, this is done with the nested class `StateMachineDescriptor`. It inherits from [NodeDescriptor](../reference/nodes.md). All descriptor rules must override the method `DefineLayout`. This method is called during initialization and is the place where rules should define how elements are described. For a state machine, the drawing canvas consists of nodes for the states and edges for the transitions between states. In the language definition, this is expressed by the code below:

```csharp
protected override void DefineLayout()
{
    Nodes(D<StateDescriptor>(), m => m.States);
    Edges(D<TransitionDescriptor>(), m => m.States.SelectMany(s => s.Outgoing).IgnoreUpdates());
}
```

The definition for states should read quite self-explanatory. The collection of states is specified by a lambda expression and has to result in a collection. For the edges, the definition is slightly more complex. This is, because in the metamodel, transitions are modelled as child elements of their source states whereas in the graphical model, they need to be child elements of the state machine. NMF GLSP can support such scenarios because the collections specified in the selectors do not have to be features of the model but can also be queries. In this case, we select the outgoing transitions of the states. However, NMF GLSP requires selectors to be collections but the query operator `SelectMany` does not return a collection (i.e., you cannot add an element to the result of `SelectMany`). However, here we make use of the fact that the metamodel specified the outgoing transitions of a state as the opposite of the source state of a transition. Therefore, a transition will be automatically added to the outgoing transitions once we set the source of the transition. Therefore, it suffices to just ignore additions and deletions and this is exactly what `IgnoreUpdates` does.

Note also that whereas the metamodel specifies start states and finite states as separate classes inheriting from `State`, we only have a single definition that specifies that *all* states of the state machine should be rendered as nodes.

What is missing is that we need to declare that the root of the language will be a state machine that is rendered in the way specified above. This is done again by overriding the appropriate property, in this case the property `StartRule`. In the template, this is done directly below the diagram type.

```csharp
public override DescriptorBase StartRule => Descriptor<StateMachineDescriptor>();
```

### States

Next thing to do is to declare how states are rendered as graphical elements. For this, the generated code has the descriptor class `StateDescriptor` which we already referenced above. Here, we define that in the diagram, a state consists of two elements: a rectangle with rounded corners (a node) and a label with the name of the state. For the backend, the fact that the state will be rendered as a rectangle with rounded corners is unimportant (this is a frontend decision), but it is important that it is a node, hence `StateDescriptor` is a node descriptor. While in SVG, rectangles and labels are separate, GLSP thinks the label as part of the node.

```csharp
Label(s => s.Name, "label:heading");
```

In order to add the label, [node descriptors have the Label method](../reference/nodes.md) as used above. This method again takes a lamda expression to specify the label. By default, NMF GLSP uses NMF Expressions to invert the function, so again, you are not restricted to access features, more complex behavior can be supported via [lenses](../../expressions/lenses.md). In this case, we added a second parameter to override the type of the label. A separate type for the main label can be useful because it makes it easier for the client to determine that label that should be changed when the user does a double-click on the node.

Unlike the states that have a free layout within the drawing surface, we want the label to be centered in the state. By default, the elements inside a node use a free layout, we need to specify something else if we need something else. The simplest way is a [VBox](../api/NMF.Glsp.Language.Layouting.LayoutStrategy.yml#NMF_Glsp_Language_Layouting_LayoutStrategy_Vbox) layout, specified using a dedicated method *Layout*.

By default, when NMF GLSP creates an element, it uses the default parameterless constructor of the semantic element type. If this is an interface, NMF GLSP (like all other NMF internal DSLs as well) uses the implementation type given through the *DefaultImplementationType* attribute that is present on all the generated code. This will create an instance of `State` even though the node descriptor has the semantic element type `IState`, but that state will be uninitialized. We might want to have a state with a predefined name.

```csharp
public override IState CreateElement(string profile, object parent)
{
    return new State
    {
        Name = "New State"
    };
}
```

To accomplish this, the generated language definition overrides another method, namely `CreateElement`. This method is used by NMF GLSP when the user adds an element to the drawing surface.

### Start States and Final States

Start states and final states are special kinds of states in theoretical computer science that have entirely different visuals. In our metamodel, they are subclasses of states, even though some properties like their name are not rendered by default. Because the visuals are entirely different, it is useful to give these elements with a different type id to the client and thus use a dedicated node descriptor. In order to tell NMF GLSP to use this node descriptor in the case that state really is a final state or start state, we need to mark this descriptor as refining the state descriptor we already had.

```csharp
Refine(D<StateDescriptor>());
```

Further, we need to adjust the size. By default, NMF GLSP assigns a size of (60,30) to new nodes. However, if final states and start states are to rendered as circles in the client, a dimension with equal width and height is much more appropriate. This is because even though the client will render a circle, the width will be used to determine the ports for edges, so with the default dimension, they will start in the middle of nowhere. The generated frontend also removes the functionality to resize final states and start states, so it is even more important to assign correct dimensions.

```csharp
Size(30, 30);
```

Fortunately, assigning a size is quite simple by just calling the method `Size`. It is important that this assignment is only the default size. If the frontend is configured to activate resize, the user can still change it. There is currently no way to forbid resize in the backend or make the size dependent on the model element.

### Transitions

Transitions will be rendered as edges in the diagram. Therefore, we use the class [EdgeDescriptor](../api/NMF.Glsp.Language.EdgeDescriptor-1.yml) to describe how transitions are rendered. This class similarly has a method `DefineLayout` that we need to override but the available options are different. First and foremost, we need to specify how the source and the target of the edge links to properties in the semantic model. Further, we need to specify which descriptors are used for the source and the target. These specifications are done through the methods `SourceNode` and `TargetNode`. Note that not calling one of these methods means that the edge elements will not have a source or target assigned (which means they are not going to be rendered) and calling these methods twice will override the first specification. Hence, these methods should be called exactly once within `DefineLayout`.

Further, we also want to have a label with the trigger of the transition. For that, we use the same `Label` function but because the label is slightly more complex, some features are specified using the fluent syntax instead of passing everything into the constructor. NMF GLSP to avoid excessive optional parameter usage. The fluent syntax is also available for labels in nodes, but the options slightly deviate depending on the context. For instance, for a label along an edge, we can specify where on the edge the label should be placed, whether it should be rotated and to what degree the user can move the label.

```csharp
SourceNode(D<StateDescriptor>(), t => t.Source);
TargetNode(D<StateDescriptor>(), t => t.Target);
Label(t => t.Trigger)
    .WithType("label:egde")
    .Validate((t, newTrigger) => !string.IsNullOrEmpty(newTrigger), "trigger must not be empty")
    .At(0.5, EdgeSide.Top, offset: 10);
```

In the generated code, we specify that the label is placed in the middle of the edge, 10 pixels above it. Further, we specify a validation that the user must not enter empty triggers and override a type such that we can differentiate labels of edges from other labels in the frontend.

### The Program.cs

To start the application, NMF GLSP integrates into the DI container of ASP.NET Core. This means, you integrate a GLSP server into an ASP.NET Core application just like any other service:

- You add GLSP services and required services (for instance: web sockets) to the DI container
- You add the language specifications your server shall support to the DI container
- You add required middleware (again: web sockets)
- You map a web socket endpoint to GLSP

However, there are two things to note:

- the model server uses synchronous IO to load models, but this is not allowed by default in Kestrel. Hence, you have to activate it.
- the frontend (in particular the VS Code extension) expects a certain log message to know that the server is fully initialized. The frontend also uses this log to find out which port to connect to.

The complete `Program.cs` of the example is shown below.

```csharp
using StateMachines;
using Microsoft.AspNetCore.WebSockets;
using Microsoft.AspNetCore.Hosting.Server.Features;
using Microsoft.AspNetCore.Hosting.Server;

var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrel(kestrel => kestrel.AllowSynchronousIO = true);

// Add services to the container.
builder.Services.AddWebSockets(opts => { });
builder.Services.AddGlspServer();
builder.Services.AddLanguage<FsmLanguage>();

var app = builder.Build();

app.UseWebSockets();
app.MapGlspWebSocketServer("/glsp");

var server = app.Services.GetRequiredService<IServer>();
var addressFeature = server.Features.Get<IServerAddressesFeature>();

await app.StartAsync();

Console.WriteLine($"[GLSP-Server]:Startup completed on {addressFeature!.Addresses.First()}");

await app.WaitForShutdownAsync();
```

NMF GLSP supports also other transport protocols, but web sockets allow to implement multiple separate protocols on the same server. This can be used in particular for property views, though this is not part of this tutorial.

## Frontend

The frontend is separated in four different projects in order to increase flexibility of deployment options:

- the GLSP client
- the web view displaying the GLSP client
- the standalone web application
- the VS Code extension

### The GLSP Client

The GLSP client is where you implement the actual rendering of the graphical elements. By default, GLSP uses Sprotty for this purpose.

The main client configuration of your language is in `diagram-module.ts`. There, you need to tell Sprotty for every type used in the graphical model which type this element should be mapped to and which rendering class should be used in order to translate the graphical model to SVG which is ultimately rendered in the browser.

The class used to represent the model elements can be very generic. It determines the features offered to the user. In the example, the class `DefaultNode` is used for states, but this class can also be used in a more general setting. The file `model.ts` also defines two classes for labels depending on whether they can be moved by the user or not. For example, the list of features for the `DefaultNode` is as follows:

```js
static override readonly DEFAULT_FEATURES = [
    connectableFeature,
    deletableFeature,
    selectFeature,
    boundsFeature,
    moveFeature,
    layoutContainerFeature,
    fadeFeature,
    hoverFeedbackFeature,
    popupFeature,
    nameFeature,
    withEditLabelFeature
];
```

The file `views.tsx` contains examples of custom renderers. For some reason, the default rectangular node view does not support rounded corners, so this functionality is implemented in a custom renderer.

```js
@injectable()
export class StateView extends ShapeView {
    override render(node: DefaultNode, context: RenderingContext, args?: IViewArgs): VNode | undefined {
        if (!this.isVisible(node, context)) {
            return undefined;
        }
        return <g>
            <rect class-sprotty-node
                  class-mouseover={node.hoverFeedback} class-selected={node.selected}
                  x={0} y={0} rx={10} ry={10} width={Math.max(node.size.width, 0)} height={Math.max(node.size.height, 0)}></rect>
            {context.renderChildren(node)}
        </g>;
    }
}
```

Also, the renderer for final states looks as follows:

```js
@injectable()
export class FinalStateView extends CircularNodeView {
    override render(node: DefaultNode, context: RenderingContext, args?: IViewArgs): VNode | undefined {
        if (!this.isVisible(node, context)) {
            return undefined;
        }

        const radius = this.getRadius(node);
        return <g class-sprotty-node>
            <circle r={radius} cx={radius} cy={radius} />
            <circle fill='#4E81B4' r={radius / 1.5} cx={radius} cy={radius} />
        </g>;
    }
}
```

Because this render method does not include the bounding rectangle, the user cannot resize finite states.

Furthermore, we also use a custom renderer for the entire graph in order to render markers that are used for the edge targets.

```js
const MARKER_TENT_ID = 'marker-tent';

@injectable()
export class StateMachineGraph extends GLSPProjectionView {
    
    @inject(TYPES.ViewerOptions) protected viewerOptions: ViewerOptions;

    createDefId(id: string): string {
        return `${this.viewerOptions.baseDiv}__svg__${id}`;
    }

    protected override renderSvg(model: Readonly<GViewportRootElement>, context: RenderingContext, _args?: IViewArgs): VNode {
        const edgeRouting = this.edgeRouterRegistry.routeAllChildren(model);
        const transform = `scale(${model.zoom}) translate(${-model.scroll.x},${-model.scroll.y})`;
        const ns = 'http://www.w3.org/2000/svg';
        return h(
            'svg',
            { ns, style: this.renderStyle(context) },
            h('g', { ns, attrs: { transform }, class: { 'svg-defs': true } }, [
                ...this.renderAdditionals(context),
                ...context.renderChildren(model, { edgeRouting })
            ])
        );
    }

    protected renderAdditionals(_context: RenderingContext): VNode[] {
        const directedEdgeAdds: any = [
            <defs>
                <marker
                    id={this.createDefId(MARKER_TENT_ID)}
                    viewBox='0 0 10 10'
                    refX='10'
                    refY='5'
                    markerUnits='userSpaceOnUse'
                    markerWidth='20'
                    markerHeight='20'
                    orient='auto-start-reverse'
                >
                    <path d='M 0 0 L 10 5 L 0 10' stroke='black' fill='none' />
                </marker>
            </defs>
        ];

        return directedEdgeAdds;
    }

    protected renderStyle(_context: RenderingContext): VNodeStyle {
        return {
            height: '100%',
            '--svg-def-marker-tent': `url(#${this.createDefId(MARKER_TENT_ID)})`
        };
    }
}
```

Speaking of edge targets, SVG has the advantage to be stylable via CSS, so you find a `diagram.css` in the `css` folder. For the state machine example, we adjusted the CSS class for edges to always have a tent to mark the end of a transition, but you can of course also separate this in a dedicated CSS class.

```css
.sprotty-edge {
    stroke: black;
    marker-end: var(--svg-def-marker-tent);
}
```

For the state machines, we define that all edges have a tent to mark the end of the transition.

## The web view

The sole purpose of the web view project is to have *Vite* compile a script that starts a GLSP page into a single JavaScript file for deployment purposes. There is no need to make language-specific changes.

## The standalone project

The purpose of the standalone project is to demonstrate how the GLSP client can be integrated into a web application. Again, there is no need to make language-specific changes. The project is meant to be a starter when integrating a GLSP diagram into an existing web application, connecting to an existing server.

## The VS Code project

The Visual Studio Code project is a simple extension project to package your new language as a Visual Studio Code extension. It contains the necessary glue code. Most of the actual integration resides in Eclipse GLSP libraries. However, you will need to make configuration changes (like author, license, etc.) if you want to go ahead and publish the Visual Studio Code extension.
