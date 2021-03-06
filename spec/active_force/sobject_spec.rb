require 'spec_helper'

describe ActiveForce::SObject do

  before do
    ::Client = double('Client')
  end

  after do
    Object.send :remove_const, 'Client'
  end

  describe ".new" do
    it "create with valid values" do
      @SObject = Whizbang.new
      expect(@SObject).to be_an_instance_of Whizbang
    end
  end

  describe ".build" do
    let(:sobject_hash) { YAML.load(fixture('sobject/single_sobject_hash')) }

    it "build a valid sobject from a JSON" do
      expect(Whizbang.build sobject_hash).to be_an_instance_of Whizbang
    end
  end

  describe ".field" do
    it "add a mappings" do
      expect(Whizbang.mappings).to include(
        checkbox: 'Checkbox_Label',
        text: 'Text_Label',
        date: 'Date_Label',
        datetime: 'DateTime_Label',
        picklist_multiselect: 'Picklist_Multiselect_Label'
      )
    end

    it "set an attribute" do
      %w[checkbox text date datetime picklist_multiselect].each do |name|
        expect(Whizbang.attribute_names).to include(name)
      end
    end
  end

  describe '#create' do

    subject do
      Whizbang.new
    end

    before do
      Client.should_receive(:create!).and_return('id')
    end

    it 'delegates to the Client with create!' do
      subject.create
    end

    it 'sets the id' do
      subject.create
      expect(subject.id).to eq('id')
    end

  end

end
