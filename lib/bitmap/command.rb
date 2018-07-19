module Bitmap
  class Command
    COMMANDS = {
      'I' => :create_bitmap,
      'C' => :clear,
      'L' => :colour_pixel,
      'V' => :draw_vertical_line,
      'H' => :draw_horizontal_line,
      'S' => :show,
      'F' => :fill
    }.freeze
    ARGS = {
      'I' => [:int, :int],
      'C' => [],
      'L' => [:int, :int, :str],
      'V' => [:int, :int, :int, :str],
      'H' => [:int, :int, :int, :str],
      'S' => [],
      'F' => [:int, :int, :str]
    }.freeze
    attr_accessor :cmd, :args, :editor

    def initialize(cmd, args, editor)
      @cmd = cmd
      @args = args
      @editor = editor
    end

    def perform
      method = COMMANDS[cmd]
      raise 'Unrecognised command.' if method.nil?
      editor.send(method, *prepare_args(args))
    end

    private

    def prepare_args(args)
      arg_types = ARGS[cmd]
      raise "Wrong number of arguments. Expected #{arg_types.length}, got #{args.length}." if args.length != arg_types.length
      arg_types.map.with_index { |type, i| self.send(type, args[i]) }
    end

    def int(arg)
      Integer(arg)
    rescue
      raise "Invalid argument error. Expected integer, got \"#{arg}\"."
    end

    def str(arg)
      arg = arg.to_s
      raise "Invalid argument error. Expected char, got \"#{arg}\"." if arg.length != 1
      arg
    end
  end
end
