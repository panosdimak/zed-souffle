# Zed Soufflé

A [Soufflé](https://souffle-lang.github.io/index.html) Datalog extension for Zed.

- Tree-sitter: [tree-sitter-souffle](https://github.com/langston-barrett/tree-sitter-souffle)
- LSP: [souffle-lsp-plugin](https://github.com/jdaridis/souffle-lsp-plugin)

## Installation

Clone the repo and use `zed: install dev extension`, pointing Zed at the repo directory.

## Features

- Syntax highlighting that distinguishes relations, variables, and the wildcard `_`.
- Bracket matching and autoclose for `()`, `[]`, `{}`, and strings.
- Syntax-aware indentation for record (`[]`) and component (`{}`) blocks.
- Outline / symbol navigation for `.decl`, `.type` (all variants), `.comp`, `.init`, and `.functor`.
- LSP features via the Soufflé language server: hover, go-to-definition, and diagnostics. Requires Java (see below); the server jar is downloaded automatically on first use.

## Requirements

- A JDK (Java 11 or newer) on your `PATH`, or `JAVA_HOME` set. This is only required for LSP features, highlighting/outline/indent work without Java.

## Configuration

You can override the auto-downloaded server with your own jar. The path must be absolute:
```json
{
  "lsp": {
    "souffle-lsp": {
      "settings": { "jar_path": "/absolute/path/to/server.jar" }
    }
  }
}
```

## License

[MIT](LICENSE)
