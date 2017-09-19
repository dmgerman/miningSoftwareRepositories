#!/usr/bin/ruby

require 'logger'
require 'logger/colors'
require 'optparse'

logger = Logger.new(STDERR)
options = {}
groups = 1

# Parse user input

OptionParser.new do |opts|
  opts.banner = 'Usage: reviewers.rb [options]'
  opts.on('-i', '--in FILENAME', 'Text file with possible reviewers.') do |v|
    options[:input] = v
  end
  opts.on('-g', '--groups GROUPS', 'Number of groups (default 1).') do |v|
    options[:groups] = Integer(v)
  end
end.parse!

unless options.key?(:input) && File.file?(options[:input])
  logger.fatal('No participant list found.')
  exit(1)
end

if options.key?(:groups)
  logger.info('Using provided group value.')
  groups = options[:groups]
else
  logger.info('Using default group value.')
end

# Read participant file
participants = []
File.open(options[:input], 'r') do |f|
  f.each_line do |line|
    participants << line
  end
end

# Calculate group size given number of groups
group_size = ((participants.length * 1.0) / groups).ceil

# Generate required samples (without replacement)
groups.times do |count|
  puts "Participant Group #{count + 1}:"
  result = participants.sample(group_size)
  result.each do |del|
    participants.delete(del)
  end
  puts result
  puts '===================================================='
end
