# frozen_string_literal: true

require 'json'

class Client
  attr_reader :clients

  def initialize(file_path)
    file = File.read(file_path)
    @clients = JSON.parse(file)
  end

  def search_by(query, field = 'full_name')
    query = query.to_s.downcase
    @clients.select do |client|
      client[field].to_s.downcase.include?(query)
    end
  end

  def find_duplicate_by(field = 'email')
    grouped_by_field = @clients.group_by { |client| client[field] }
    grouped_by_field.select { |_, group| group.size > 1 }
  end
end
