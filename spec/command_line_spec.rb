# frozen_string_literal: true

require 'rspec'
require_relative '../command_line'
require_relative '../client'

RSpec.describe CommandLine do
  let(:mock_client) { instance_double('Client') }
  let(:command_line) { CommandLine.new }
  let(:mock_data) do
    [
      { 'id' => 1, 'full_name' => 'Jane Doe', 'email' => 'jane.doe@example.com' },
      { 'id' => 2, 'full_name' => 'John Smith', 'email' => 'john.smith@example.com' },
      { 'id' => 3, 'full_name' => 'Alex Johnson', 'email' => 'alex.johnson@example.com' }
    ]
  end

  before do
    allow(Client).to receive(:new).and_return(mock_client)
  end

  describe '#start' do
    before do
      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:print)
    end

    it 'displays the main menu and handles invalid input' do
      allow(command_line).to receive(:gets).and_return('5')
      expect { command_line.start }.to output(/You picked an invalid option!/).to_stdout_from_any_process
    end

    it 'invokes the search command when the user selects search' do
      allow(command_line).to receive(:gets).and_return('1', 'Jane', '1')
      allow(mock_client).to receive(:search_by).and_return(mock_data)

      expect(command_line).to receive(:search)
      command_line.start
    end

    it 'invokes the find_duplicates command when the user selects find_duplicates' do
      allow(command_line).to receive(:gets).and_return('2', '1')
      allow(mock_client).to receive(:find_duplicate_by).and_return({})

      expect(command_line).to receive(:find_duplicates)
      command_line.start
    end
  end

  describe '#search' do
    before do
      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:print)
    end

    it 'searches for a client and displays results' do
      allow(command_line).to receive(:gets).and_return('Jane', '1')
      allow(mock_client).to receive(:search_by).with('Jane', 'id').and_return(mock_data)

      expect { command_line.send(:search) }.to output(/Search result/).to_stdout_from_any_process
    end

    it 'handles no results found' do
      allow(command_line).to receive(:gets).and_return('Nonexistent', '1')
      allow(mock_client).to receive(:search_by).and_return([])

      expect { command_line.send(:search) }.to output(/No clients found/).to_stdout_from_any_process
    end

    it 'exits when user types quit' do
      allow(command_line).to receive(:gets).and_return('quit')

      expect(command_line.send(:search)).to be_nil
    end
  end

  describe '#find_duplicates' do
    before do
      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:print)
    end

    it 'displays duplicate clients if found' do
      duplicates = { 'jane.doe@example.com' => [mock_data.first, mock_data.last] }
      allow(command_line).to receive(:gets).and_return('3')
      allow(mock_client).to receive(:find_duplicate_by).with('email').and_return(duplicates)

      expect do
        command_line.send(:find_duplicates)
      end.to output(/Duplicate client based on/).to_stdout
    end

    it 'displays no duplicates found' do
      allow(command_line).to receive(:gets).and_return('1')
      allow(mock_client).to receive(:find_duplicate_by).and_return({})

      expect { command_line.send(:find_duplicates) }.to output(/No duplicate client found/).to_stdout_from_any_process
    end
  end

  describe '#selected_query_field' do
    before do
      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:print)
    end

    it 'returns a valid field selected by the user' do
      allow(command_line).to receive(:gets).and_return('2')
      expect(command_line.send(:selected_query_field)).to eq('full_name')
    end

    it 'handles invalid input and prompts again' do
      allow(command_line).to receive(:gets).and_return('5', '2')
      expect(command_line.send(:selected_query_field)).to eq('full_name')
    end

    it 'exits when user types quit' do
      allow(command_line).to receive(:gets).and_return('quit')
      expect(command_line.send(:selected_query_field)).to be_nil
    end
  end
end
