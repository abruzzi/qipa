require_relative '../spec_helper'
 
describe 'Plants Application' do
  describe 'List all plants' do
    before { get '/plants' }
 
    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'is empty at the very begining' do
      list = JSON.parse(last_response.body)
      expect(list.length).to eq 0
    end
  end

  describe 'Create a plant' do
  	let(:body) { {:name => "plant", :description => "really weird"} }

  	it 'create a plant'  do
  		post '/plants', body, {'Content-Type' => 'application/json'}
  		expect(last_response.status).to eq 201
  		
  		get '/plants'
  		created = JSON.parse(last_response.body)[0]

  		expect(created['name']).to eq "plant"
  		expect(created['description']).to eq "really weird"
  	end

  end
end