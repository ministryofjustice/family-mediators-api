require_relative '../../lib/api/models/mediator'

class PopulateUrnPrefix < ActiveRecord::Migration[5.0]
  def self.up
    tot = API::Models::Mediator.count

    API::Models::Mediator.all.each_with_index do |mediator, i|
      mediator.set_urn_prefix
      mediator.save
      puts "Updated #{i}/#{tot}"
    end
  end
end
