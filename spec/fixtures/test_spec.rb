describe '#call' do
  subject { described_class.new(user, family).call(to_foo, foo_invitation) }
  
  shared_examples "201 Created が返ってくる" do
    specify do
      post endpoint, params.to_json, env
      expect(response).to have_http_status(201)
    end
  end


  context 'call with invalid argument' do
    it "raise argument error" do
      expect { described_class.new(user, family).call(to_foo, 'foobar') }.to raise_error ArgumentError
    end
  end
end
