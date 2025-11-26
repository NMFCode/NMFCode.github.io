# Hello World

This tutorial is designed to guide you through the steps to create your first DSL using AnyText.

## Prerequisites

You will need to install the following software, if it is not already installed:

- Node.js
- NPM
- [.NET SDK](https://learn.microsoft.com/en-us/dotnet/core/install/) (the AnyText generator is compiled for .NET 8 but will roll forward such that newer SDKs should work).

## Installing the Generator

We have a [Yeoman](https://yeoman.io) generator to help you get started by scaffolding a new project. You can install the generator using NPM as follows (we recommend global installation):

```bash
npm install generator-anytext --global --save-dev
```

## Using the Generator

The code generator scaffolds a new AnyText project. You can start it via the command line as follows:

```bash
yo anytext
```

By default, the code generator is interactive and will ask for a range of details such as the name of your language and a repository link. Based on this information, the code generator will generate a new directory with the following artifacts already set up for you:

- An AnyText grammar document with an example grammar
- A file to manually fine-tune editor services for the generated parser
- A C\# project that creates an LSP server of your grammar
- A Visual Studio Code extension that integrates the LSP server
- Visual Studio Code launch configurations such that you can easily debug your VS Code extension

These artifacts are set up such that they integrate with each other. For example, the build directory of the LSP server is exactly where the VS Code extension is expecting it. Because the code generator also compiles the sources, you can start the extension straight away. Also, you can immediately use `vsce` to pack your extension into a deployable VSIX file.

The extension project also contains scripts that allow you to easily regenerate the grammar and metamodel code once you did some changes:

- If you only changed the concrete syntax of your language, you can run `npm run generate-parser` to regenerate the internal parser DSL code of your language.
- If you changed the abstract syntax of your language, you can run `npm run generate-metamodel` to regenerate the code for your changed metamodel.

## The generated project

The generated folder contains two subdirectories:

- *vscode:* This directory contains code necessary to build a Visual Studio Code extension for your new DSL. The VS Code extension is really generic.
- *backend:* This is where the magic happens. You will find the grammar of your language in `backend/<%= language-id %>.anytext`

The generated grammar is a simple hello world grammar. It allows to specify a list of people using the `person` keyword and greet them using the `hello` keyword. Because the generator also generates the metamodel from the grammar, you find two code files next to the grammar: the generated parser and a code file including the entire abstract syntax code.

```plain
grammar HelloWorld ( hello-world )
root GreetingModel

comment '//'

GreetingModel:
    ( people+=Person | greetings+=Greeting )*;

Person:
    'person' !'person' name=String <nl>;
Greeting:
    'hello' greeted=[Person] <nl>;

terminal String:
    /\w.*/;
```

The full example grammar is depicted above. The declaration of the grammar tells AnyText that the text in its entirity shall be treated as a `GreetingModel`. The definition of `GreetingModel` below that tells that a greeting model consists of arbitrary many (that is what the `*` is for) people or greetings. The definition of a person starts with the keyword `person` followed by the name of the person.

### People

The name of the person is declared as string, denoted with the regular expression `\w.*`. This means, the name starts with an alphanumeric character followed by arbitrary many arbitrary characters. Because terminal symbols are single-line by default, this will match the rest of the line. This means, the name of a person can include the string `person`, even though `person` is also used as a keyword. This is because AnyText works scannerless and therefore, the parser knows exactly when it should look for the keyword `person` and when a string is asked for.

This also means that the following file contents would not raise an error:

```plain
person
person A
```

This is because the text only contains a single person with the name `person A`. However, most likely this is not what the user intended. Thus, we integrate a negative lookahead `!'person'` that a keyword person should not be followed by itself.

On the converse, if AnyText should generate text for a given model, we need a line break after the name of the person, otherwise the definition of the next person might be treated as part of the name of the previous person. To tell AnyText that it should insert a line break after a person, we add a [formatting instruction](../reference/formattingInstructions.md) `<nl>` at the end of the rule.

### Greetings

The definition of greetings looks mostly similar, except that the *greeted*-property is not assigned a string, but a reference to a person. In this case, AnyText automatically infers that the property *name* is the identifier of person, attempts to parse the same parse expression, namely a string, and uses the result to resolve the person greeted.

Because AnyText knows this notion of reference, the resulting VS Code extension will also support editor features such as renaming a person and we get a code lens over person telling us the references of that person.

### Custom Code Lenses

The generated project also contains some manual code that is not overridden when you change the contents of the grammar. Its purpose is to demonstrate how you can fine-tune your language using manual code. Whereas the generated code for the parser contains a nested class for every [model rule](../reference/rules.md) and [assignment](../reference/parseExpressions.md), this file only contains partial definitions of two classes: the parser class for the person rule and the parser class for the greeting rule.

The only thing that the partial definition of the person rule does is to override the symbol kind. [Symbol kinds](../features/symbols.md) are used for a range of editor features, if they are set. Because LSP is designed for programming languages, we are restricted to symbol kinds usually present in programming languages. Here, we chose `Object` which tells clients through the LSP that a person should be displayed like an object. More important, it tells clients that person is an important concept, with the consequence that people start appearing in the outline view.

For greetings, we have a custom code lens that allows users to interact with the semantic model directly through the editor. That is, we define a lens to greet the person referenced. We could do anything here, but in that case, we only show a notification to mock that the person was greeted.

## Getting Started

To get started with your VS Code Extension, we suggest the following steps:

1. **Create the grammar definition.** To support this task, download the [Anytext extension](../extension.md), if you haven't already done so.
2. **Adjust the grammar.** The template already contains a manual extension of the generated code. Use this file to override the default behavior of the LSP server and adjust it to your needs. To generate the code, the generated `package.json` contains two NPM scripts:
   - `npm run generate-parser` regenerates the parser. Use this script whenever you make changes to your grammar for these changes to become effective.
   - `npm run generate-metamodel` regenerates the metamodel. Use this script whenever you make changes to the abstract syntax of your DSL.
3. **Adjust the editor services.** AnyText is built in such a way that you can easily extend the functionality of the generated language code and extend or customize it. As an example, the template includes a custom code lens and a specification that the abstract syntax element `Person` should be rendered with the symbol kind object. Note that the LSP is strict on the possible symbol kinds, so you have to chose from what LSP provides.
4. **Debug the extension.** You can start your VS Code extension right from VS Code. The template is configured to give you a *Run Extension* launch configuration. Running the extension in debug will pop up a window asking you which Visual Studio (or other IDE) window you want to use to debug the LSP server.
5. **Repeat.** Your grammar will probably not fit all your needs on the first attempt. Repeat the previous steps until you are happy with the result.

## Install your extension

- To start using your extension with VS Code, copy it into the `<user home>/.vscode/extensions` folder and restart Code.
- To share your extension with the world, read the [VS Code documentation](https://code.visualstudio.com/api/working-with-extensions/publishing-extension) about publishing an extension. The extension is already prepared to be packaged using `vsce pack`.

## Troubleshooting

The code generator should already have installed the AnyText code generator as a global .NET tool. If this did not work for some reason, you can install it manually:

`dotnet tool install nmf-anytextgen --global`

Afterwards, the code generator can be executed anywhere using `anytextgen`. You can see the documentation how to generate the code using `anytextgen help`.
