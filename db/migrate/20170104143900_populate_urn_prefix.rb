require_relative '../../lib/api/models/mediator'

class PopulateUrnPrefix < ActiveRecord::Migration[5.0]
  def self.up
    tot = API::Models::Mediator.count

    API::Models::Mediator.all.each_with_index do |mediator, index|
      mediator.set_urn_prefix
      mediator.save
      puts "Updated #{index+1}/#{tot}"
    end
  end
end
