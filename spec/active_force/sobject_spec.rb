require 'spec_helper'

describe ActiveForce::SObject do
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

  describe ".soql_find" do

    let(:sobject_id)         { '6253juye524' }
    let(:sobject_table_name) { Whizbang.table_name }
    let(:query)              { Whizbang.soql_find sobject_id }

    it "containt a valid SOQL format" do
      expect(query).to include(<<-SOQL.strip_heredoc)
        SELECT #{Whizbang.fields.join(', ')}
        FROM #{sobject_table_name}
        WHERE Id = '#{sobject_id}'
      SOQL
    end

    it 'find the sobject id' do
      expect(query).to match(/where id = '#{sobject_id}'/i)
    end

    it 'find on the table_name' do
      expect(query).to match(/from #{sobject_table_name}/i)
    end
  end
end
