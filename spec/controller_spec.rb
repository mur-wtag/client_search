# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Client Search WebApp' do
  describe 'GET /' do
    it 'displays the homepage' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Upload Clients JSON')
    end
  end

  describe 'POST /upload' do
    context 'when a valid file is uploaded' do
      let(:valid_file) { Rack::Test::UploadedFile.new('spec/fixtures/clients.json', 'application/json') }

      it 'renders the search form' do
        post '/upload', file: valid_file
        expect(last_response).to be_ok
        expect(last_response.body).to include('Client Search')
      end
    end

    context 'when no file is uploaded' do
      it 'returns an error message' do
        post '/upload'
        expect(last_response.body).to include('Please upload a valid JSON file.')
      end
    end
  end

  describe 'POST /search' do
    let(:valid_file) { Rack::Test::UploadedFile.new('spec/fixtures/clients.json', 'application/json') }

    before do
      post '/upload', file: valid_file
    end

    context 'when a valid search query is provided' do
      let(:file_content_path) { File.expand_path('spec/fixtures/clients.json') }

      it 'returns search results' do
        post '/search', {
          query: 'Jane',
          search: {
            field: 'full_name',
            content_file_path: file_content_path
          }
        }
        expect(last_response).to be_ok
        expect(last_response.body).to include('Jane Smith')
      end
    end

    context 'when no results are found' do
      let(:file_content_path) { File.expand_path('spec/fixtures/clients.json') }

      it 'returns a no results message' do
        post '/search', {
          query: 'Nonexistent',
          search: {
            field: 'full_name',
            content_file_path: file_content_path
          }
        }
        expect(last_response.body).to include('No clients found.')
      end
    end

    context 'when the file path is missing' do
      it 'returns an error message' do
        post '/search', {
          query: 'Jane',
          search: {
            field: 'full_name',
            content_file_path: ''
          }
        }
        expect(last_response.body).to include('Invalid search query or file.')
      end
    end
  end

  describe 'POST /find_duplicates' do
    let(:valid_file) { Rack::Test::UploadedFile.new('spec/fixtures/clients.json', 'application/json') }

    before do
      post '/upload', file: valid_file
    end

    context 'when duplicates are found' do
      let(:file_content_path) { File.expand_path('spec/fixtures/clients.json') }

      it 'returns the duplicate clients' do
        post '/find_duplicates', {
          duplicate: {
            field: 'email',
            content_file_path: file_content_path
          }
        }
        expect(last_response).to be_ok
        expect(last_response.body).to include('Duplicate: jane.smith@yahoo.com')
      end
    end

    context 'when no duplicates are found' do
      let(:file_content_path) { File.expand_path('spec/fixtures/clients_without_duplicates.json') }

      it 'returns a no duplicates message' do
        post '/find_duplicates', {
          duplicate: {
            field: 'email',
            content_file_path: file_content_path
          }
        }
        expect(last_response.body).to include('No duplicates found.')
      end
    end

    context 'when the file path is missing' do
      it 'returns an error message' do
        post '/find_duplicates', {
          duplicate: {
            field: 'email',
            content_file_path: ''
          }
        }
        expect(last_response.body).to include('Please provide a valid file and field.')
      end
    end
  end
end
