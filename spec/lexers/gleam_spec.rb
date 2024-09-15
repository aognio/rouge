# -*- coding: utf-8 -*- #
# frozen_string_literal: true


describe Rouge::Lexers::Gleam do
  let(:subject) { described_class.new }

  describe 'lexing keywords' do
    it 'recognizes keywords' do
      %w[let fn import pub case of type as if else try opaque].each do |keyword|
        expect(subject.lex(keyword).to_a).to include([:keyword, keyword])
      end
    end
  end

  describe 'lexing built-in types' do
    it 'recognizes built-in types' do
      %w[Int Float Bool String List Nil Result Option Error].each do |builtin|
        expect(subject.lex(builtin).to_a).to include([:keyword_type, builtin])
      end
    end
  end

  describe 'lexing numbers' do
    it 'recognizes integers' do
      expect(subject.lex('42').to_a).to include([:num_integer, '42'])
    end

    it 'recognizes hexadecimal numbers' do
      expect(subject.lex('0x1A3F').to_a).to include([:num_hex, '0x1A3F'])
    end

    it 'recognizes binary numbers' do
      expect(subject.lex('0b1010').to_a).to include([:num_bin, '0b1010'])
    end

    it 'recognizes floating-point numbers' do
      expect(subject.lex('3.14').to_a).to include([:num_float, '3.14'])
    end
  end

  describe 'lexing strings' do
    it 'recognizes double-quoted strings' do
      expect(subject.lex('"Hello, Gleam!"').to_a).to include([:str_double, '"Hello, Gleam!"'])
    end

    it 'recognizes single-quoted strings' do
      expect(subject.lex("'Hello, Gleam!'").to_a).to include([:str_single, "'Hello, Gleam!'"])
    end
  end

  describe 'lexing comments' do
    it 'recognizes single-line comments' do
      expect(subject.lex('// This is a comment').to_a).to include([:comment_single, '// This is a comment'])
    end

    it 'recognizes multi-line comments' do
      code = <<~GLEAM
        /*
        This is a multi-line comment
        */
      GLEAM
      expect(subject.lex(code).to_a).to include([:comment_multiline, "/*\nThis is a multi-line comment\n*/"])
    end
  end
end

