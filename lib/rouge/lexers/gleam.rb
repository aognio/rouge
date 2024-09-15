module Rouge
  module Lexers
    class Gleam < RegexLexer
      title "Gleam"
      desc 'The Gleam programming language (https://gleam.run/)'
      tag 'gleam'
      filenames '*.gleam'
      mimetypes 'text/x-gleam'

      # Define Gleam keywords
      def self.keywords
        @keywords ||= %w(
          let fn import pub case of type as if else try opaque assert todo
        )
      end

      # Define built-in types in Gleam
      def self.builtins
        @builtins ||= Set.new %w(
          Int Float Bool String List Nil Result Option Error
        )
      end

      # Identifiers, numbers, and other common patterns
      id = /[a-zA-Z_][a-zA-Z0-9_]*/
      hex = /[0-9a-fA-F]/
      escapes = /\\([nrt'"\\0]|x#{hex}{2}|u\{#{hex}+\})/

      state :root do
        # Handle newlines
        rule %r/\n/, Text

        # Whitespace
        rule %r/\s+/, Text

        # Comments
        rule %r{//.*$}, Comment::Single
        rule %r{/\*}, Comment::Multiline, :multiline_comment

        # Keywords
        rule %r/\b(?:#{self.class.keywords.join('|')})\b/, Keyword

        # Built-in types
        rule %r/\b(?:#{self.class.builtins.to_a.join('|')})\b/, Keyword::Type

        # Function definitions
        rule %r/\bfn\b\s+(#{id})/, Name::Function

        # Numbers
        rule %r/\b0b[01_]+\b/, Num::Bin  # Binary numbers
        rule %r/\b0o[0-7_]+\b/, Num::Oct  # Octal numbers
        rule %r/\b0x[0-9a-fA-F_]+\b/, Num::Hex  # Hexadecimal numbers
        rule %r/\b\d+\.\d+(e[+-]?\d+)?\b/, Num::Float  # Float numbers
        rule %r/\b\d+\b/, Num::Integer  # Integer numbers

        # Strings (double quotes)
        rule %r/"(\\.|[^"\\])*"/, Str::Double

        # Strings (single quotes)
        rule %r/'(\\.|[^'\\])*'/, Str::Single

        # Escape sequences within strings
        rule escapes, Str::Escape

        # Attributes (e.g., @external)
        rule %r/@#{id}/, Name::Decorator

        # Identifiers (variables, module names)
        rule %r/\b#{id}\b/, Name

        # Operators
        rule %r{[-+/*%=!<>&|^~]}, Operator
        rule %r{[()\[\]{}.,:;]}, Punctuation
      end

      # Multiline comment state
      state :multiline_comment do
        rule %r{[^/*]+}, Comment::Multiline
        rule %r{/\*}, Comment::Multiline, :multiline_comment
        rule %r{\*/}, Comment::Multiline, :pop!
        rule %r{[/*]}, Comment::Multiline
      end
    end
  end
end

