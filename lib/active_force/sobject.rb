require 'active_model'
require 'active_attr'
require 'active_attr/dirty'
require 'active_support/core_ext/string/strip'

module ActiveForce
  class SObject
    include ActiveAttr::Model
    include ActiveAttr::Dirty

    class_attribute :mappings, :fields, :table_name

    def self.build sobject
      return nil if sobject.nil?
      model = new
      mappings.each do |attr, sf_field|
        model[attr] = sobject[sf_field]
      end
      model.changed_attributes.clear
      model
    end

    def self.soql_find id
      <<-SOQL.strip_heredoc
        SELECT #{fields.join(', ')}
        FROM #{table_name}
        WHERE Id = '#{id}'
      SOQL
    end

    def self.find id
      build Client.query(soql_find id).first
    end

    def update_attributes attributes
      assign_attributes attributes
      if valid?
        sobject_hash = { 'Id' => id }
        changed.each do |field|
          sobject_hash[mappings[field.to_sym]] = read_attribute(field)
        end
        result = Client.update table_name, sobject_hash
        changed_attributes.clear if result
        result
      else
        false
      end
    end

    def to_param
      id
    end

    def persisted?
      id?
    end

    def self.field field_name, from: field_name.camelize
      mappings[field_name] = from
      attribute field_name
    end

    def self.mappings
      @mappings ||= {}
    end

    def self.fields
      @mappings.values
    end
  end
end
