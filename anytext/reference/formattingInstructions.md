# Formatting Instructions

Formatting instructions in AnyText are used to control how a given parse tree should be printed to text. As soon as the pretty-printer has finished to process a rule application from a parse tree, all formatting instructions corresponding to the rule application are executed. Formatting instructions are stored at the caller of a rule (for instance in a sequence or a choice) such that the same rule can cause different formatting instructions depending on the context in which a rule was used in the parsing process.

AnyText currently supports the following formatting instructions:

- **Avoid Space** `<nsp>` (or `<!nsp>` is white spaces should cause parser failures)
- **Newline** `<nl>`
- **Indent** `<ind>`
- **Unindent** `<unind>`

## Avoid Space

When formatting a document, AnyText will normally insert a single white space between literal tokens. If a formatting instruction to avoid a space is used, this additional space is suppressed. Note that often multiple rules end at the same location in the text and it does not matter which rule issued a formatting instruction to avoid a space. If any, then the white space is suppressed.

The formatting instruction to avoid a space is idempotent: it only sets a flag in the pretty printer and if that flag is already set, another avoid space instruction has no effect.

## Newline

A newline formatting instruction does what it says, it inserts a line break. The new line is indented immediately with the current indentation level. The characters used for indentation are provided by the outside. Clients such as Visual Studio Code operate with default indentation strings such as a double white space or tab character.

## Indent / Unindent

Thes two formatting instructions do not have an immediate effect on the printed result but increase or decrease the indentation level.

The indentation level cannot be decreased lower than zero but on the other hand has no upper limit.
