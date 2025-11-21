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
