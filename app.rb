# frozen_string_literal: true

require_relative 'command_line'

puts '===================='
puts '   Client Search    '
puts '===================='
puts "Enter clients file path (type 'quit' for exit):"
file_path = ''

loop do
  print '> '
  file_path = gets.chomp
  break if File.file?(file_path) || file_path == 'quit'

  puts "Enter a valid file path (type 'quit' for exit):"
end

if file_path && file_path != 'quit'
  begin
    file = File.read(file_path)
    JSON.parse(file)

    cli = CommandLine.new(file_path || 'clients.json')
    cli.start
  rescue JSON::ParserError
    puts 'Invalid JSON file'
  end
end
