require 'rouge'
require_relative 'lib/rouge/lexers/gleam.rb'

source_code = <<-GLEAM
pub fn main() {
  let number = 42
  let binary = 0b1010
  let hex = 0x1A3F
  let message = "Hello, Gleam!"
  // This is a comment
  /* This is a
     multi-line comment */
}
GLEAM

lexer = Rouge::Lexers::Gleam.new
formatter = Rouge::Formatters::Terminal256.new
puts formatter.format(lexer.lex(source_code))

