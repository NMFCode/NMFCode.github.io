# Yeoman Generator

We developed a [Yeoman](https://yeoman.io) generator that is used to create a new
*AnyText* extension for Visual Studio Code.
It is also [available on GitHub](https://github.com/NMFCode/anytext-generator).

## Prerequisites

Like for the benchmark, the code generators requires that you have the
.NET SDK installed. To install it, [follow the instructions](https://github.com/dotnet/core/blob/main/release-notes/9.0/install.md) provided
by Microsoft.

The generator itself can be installed as an NPM package. We recommend a
systemwide installation.

    npm install generator-anytext --global --save-dev

## Using the Generator

The code generator scaffolds a new
*AnyText* project. You can start it via the
command line as follows:

    yo anytext

By default, the code generator is interactive and will ask for a range
of details such as the name of your language and a repository link.
Based on this information, the code generator will generate a new
directory with the following artifacts already set up for you:

- An AnyText grammar document with an example grammar
- A file to manually fine-tune editor services for the generated parser
- A C# project that creates an LSP server of your grammar
- A Visual Studio Code extension that integrates the LSP server
- Visual Studio Code launch configurations such that you can easily
  debug your VS Code extension

These artifacts are set up such that they integrate with each other. For
example, the build directory of the LSP server is exactly where the VS
Code extension is expecting it. Because the code generator also compiles
the sources, you can start the extension straight away. Also, you can
immediately use `vsce` to pack your extension into a deployable VSIX
file.

The extension project also contains scripts that allow you to easily
regenerate the grammar and metamodel code once you did some changes:

- If you only changed the concrete syntax of your language, you can run
  `npm run generate-parser` to regenerate the internal parser DSL code
  of your language.

- If you changed the abstract syntax of your language, you can run
  `npm run generate-metamodel` to regenerate the code for your changed
  metamodel.
