#!/usr/bin/ruby

require 'getoptlong'
require './lib/markovletters'


def usage
  puts "Overview: Reads text from standard input, creates a markov chain"
  puts "(n-gram) model, and outputs words based on that model."
  puts
  puts "Usage:"
  puts __FILE__ + " [options...] [beginning [beginning] [...]]"
  puts "       --minlen <n>    Minimum length of generated string"
  puts "       --maxlen <n>    Maximum length of generated string"
  puts "  -l | --length <n>    Set min and max length of generated string"
  puts "  -n | --count  <n>    Number of strings to generate"
  puts "  -o | --order  <n>    Markov chain order (default: 2)"
  puts "  -h | --help          Show command line usage"
  exit 1
end


opts = GetoptLong.new(
  [ '--minlength', GetoptLong::REQUIRED_ARGUMENT],
  [ '--maxlength', GetoptLong::REQUIRED_ARGUMENT],
  [ '--length', '-l', GetoptLong::REQUIRED_ARGUMENT],
  [ '--count', '-n', GetoptLong::REQUIRED_ARGUMENT],
  [ '--order', '-o', GetoptLong::REQUIRED_ARGUMENT],
  [ '--help', '-h', GetoptLong::NO_ARGUMENT],
)

mc = MarkovLetters.new
reps = 10

opts.each do |opt, arg|
  case opt
    when '--help'
      usage
    when '--count'
      reps = arg.to_i
    when '--order'
      mc.order = arg.to_i
    when '--minlength'
      mc.minlength = arg.to_i
    when '--maxlength'
      mc.maxlength = arg.to_i
    when '--length'
      mc.minlength = arg.to_i
      mc.maxlength = arg.to_i
  end
end


STDIN.each_line do |line|
  line.scan(/[A-Za-z]+/).each do |word|
    mc.digest(word.downcase)
  end
end

#mc.status

if ARGV.size > 0
  prefixes = ARGV
else
  prefixes = ['']
end

prefixes.each do |start|
  reps.times do
    puts mc.generate(start.downcase).capitalize
  end
end

