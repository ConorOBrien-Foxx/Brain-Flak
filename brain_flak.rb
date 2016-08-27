require './stack.rb'
require './Interpreter.rb'

require 'optparse'

debug = false
arg_path = ""

parser = OptionParser.new do |opts|
  # This needs updating
  opts.banner = "Welcome to Brain-Flak!"\
                "\nUsage:"\
                "brain_flak source_file"\
                "brain_flak source_file args\n"

  opts.on("-d", "--debug", "Enables parsing of debug commands") do
    debug = true
  end

  opts.on("-f", "--file=FILE", "Reads input for the brain-flak program from FILE, rather than from the command line.") do |file|
    arg_path = file
  end
end

begin
  parser.parse!
rescue OptionParser::ParseError => e
  puts e
  puts "\n"
  puts parser
  exit
end

if ARGV.length < 1 then
  puts parser
  exit
end

source_path = ARGV[0]
if arg_path != "" then
  input_file = File.open(arg_path, 'r')
  numbers = input_file.read.gsub(/\s+/m, ' ').strip.split(" ").reverse
else
  numbers = ARGV[1..-1].reverse
end

if debug then
  puts "Debug mode... ENGAGED!"
end

source_file = File.open(source_path, 'r')
source = source_file.read
source_length = source.length

interpreter = BrainFlakInterpreter.new(source, numbers, debug)

begin
  while interpreter.running do
    interpreter.step
  end

  interpreter.active_stack.print
rescue BrainFlakError => e
  puts e.message
end

