# frozen_string_literal: true

require 'sinatra'
require_relative 'client'
require 'json'

set :port, 4567

# Route for the homepage
get '/' do
  erb :index
end

# Route to handle file uploads and display a form
post '/upload' do
  if params[:file] && params[:file][:tempfile]
    @file_path = params[:file][:tempfile].path
    erb :search
  else
    'Please upload a valid JSON file.'
  end
end

# Route to search for clients
post '/search' do
  query = params[:query]
  field = params[:search][:field]

  # Hidden field storing file content
  file_content_path = params[:search][:content_file_path]

  if !file_content_path.empty? && query
    client = Client.new(file_content_path)
    @results = client.search_by(query, field)
    erb :search_results
  else
    'Invalid search query or file.'
  end
end

# Route to find duplicates
post '/find_duplicates' do
  field = params[:duplicate][:field]
  file_content_path = params[:duplicate][:content_file_path]

  if !file_content_path.empty? && field
    client = Client.new(file_content_path)
    @duplicates = client.find_duplicate_by(field)
    erb :duplicates
  else
    'Please provide a valid file and field.'
  end
end
