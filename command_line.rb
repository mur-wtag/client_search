# frozen_string_literal: true

require_relative 'client'

class CommandLine
  def initialize(file_path = 'clients.json')
    @client = Client.new(file_path)
    @commands = %w[search find_duplicates]
    @fields = %w[id full_name email]
  end

  def start
    puts "Select an option (type 'quit' for exit):"
    @commands.each_with_index do |option, index|
      puts "#{index + 1}. #{option}"
    end

    print '> '
    choice = gets.to_i

    if choice.between?(1, @commands.size)
      __send__(@commands[choice - 1])
    else
      puts 'You picked an invalid option!'
    end
  end

  private

  def search
    puts "Enter a query or part of a query to search (type 'quit' for exit):"
    print '> '
    query = gets.chomp
    return if query == 'quit'

    field = selected_query_field
    return if field.nil?

    results = @client.search_by(query, field)

    if results.empty?
      puts 'No clients found.'
    else
      puts '=========================================='
      puts "   Search result (by field #{field})      "
      puts '=========================================='
      results.each do |client|
        puts client
      end
    end
  end

  def find_duplicates
    field = selected_query_field('duplicate')
    return if field.nil?

    duplicates = @client.find_duplicate_by(field)
    if duplicates.empty?
      puts "No duplicate client found based on the field: #{field}."
    else
      duplicates.each do |duplicate_value, clients|
        puts "Duplicate client based on '#{field}' field: #{duplicate_value}"
        clients.each { |client| puts client }
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def selected_query_field(command_type = 'search')
    puts "Select a field to #{command_type == 'search' ? 'match the query' : 'find duplicates'} (type 'quit' for exit):"

    # show the fields list
    @fields.each_with_index do |field, index|
      puts "#{index + 1}. #{field}"
    end

    selected_field = 0
    loop do
      print '> '
      choice = gets.chomp
      selected_field = choice.to_i
      break if choice.to_i.between?(1, @fields.size) || choice == 'quit'

      puts "Enter a value between 1 and #{@fields.size}"
    end
    return if selected_field.zero?

    @fields[selected_field - 1]
  end
  # rubocop:enable Metrics/AbcSize
end
