# frozen_string_literal: true

require 'rspec'
require_relative '../client'

RSpec.describe Client do
  let(:mock_data) do
    [
      { id: 1, full_name: 'Jane Doe', email: 'jane.doe@example.com' },
      { id: 2, full_name: 'John Smith', email: 'john.smith@example.com' },
      { id: 3, full_name: 'Jane Smith', email: 'jane.smith@example.com' },
      { id: 4, full_name: 'Alex Johnson', email: 'alex.johnson@example.com' },
      { id: 5, full_name: 'Jane Doe', email: 'jane.doe@example.com' }
    ]
  end

  before do
    allow(File).to receive(:read).and_return(mock_data.to_json)
  end

  let(:client) { Client.new('mock_file.json') }

  describe '#initialize' do
    it 'loads and parses the JSON data into clients' do
      expect(client.clients.size).to eq(5)
      expect(client.clients.first['full_name']).to eq('Jane Doe')
    end
  end

  describe '#search_by' do
    context 'when searching by full_name' do
      it 'returns clients with names partially matching the query' do
        result = client.search_by('Jane')
        expect(result.size).to eq(3)
        expect(result.map { |c| c['full_name'] }).to contain_exactly('Jane Doe', 'Jane Smith', 'Jane Doe')
      end

      it 'is case insensitive' do
        result = client.search_by('jane')
        expect(result.size).to eq(3)
      end

      it 'returns an empty array if no match is found' do
        result = client.search_by('nonexistent')
        expect(result).to be_empty
      end
    end

    context 'when searching by email' do
      it 'returns clients with emails partially matching the query' do
        result = client.search_by('jane', 'email')
        expect(result.size).to eq(3)
      end
    end

    context 'when searching by id' do
      it 'returns clients with id matching the query' do
        result = client.search_by(4, 'id')
        expect(result.size).to eq(1)
      end
    end
  end

  describe '#find_duplicate_by' do
    context 'when finding duplicates by email' do
      it 'returns clients with duplicate emails' do
        duplicates = client.find_duplicate_by('email')
        expect(duplicates.keys).to contain_exactly('jane.doe@example.com')
        expect(duplicates['jane.doe@example.com'].size).to eq(2)
      end
    end

    context 'when finding duplicates by full_name' do
      it 'returns clients with duplicate full names' do
        duplicates = client.find_duplicate_by('full_name')
        expect(duplicates.keys).to contain_exactly('Jane Doe')
        expect(duplicates['Jane Doe'].size).to eq(2)
      end
    end

    context 'when there are no duplicates' do
      it 'returns an empty hash' do
        result = client.find_duplicate_by('id')
        expect(result).to be_empty
      end
    end
  end
end
