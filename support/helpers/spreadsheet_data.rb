class SpreadsheetData

  attr_reader :headings, :data

  def initialize(valid_item_count: 2, invalid_item_count: 0)
    @headings = valid_mediator.keys
    @data = []
    create(valid_item_count, invalid_item_count)
  end

  def create(valid_item_count, invalid_item_count)
    valid_item_count.times { @data << valid_mediator.values }
    invalid_item_count.times { @data << invalid_mediator.values }
  end

  def valid_mediator
    {
        'registration_no' => generate_valid_registration_no,
        'md_offers_dcc' => 'Y',
        'md_first_name' => 'John',
        'md_last_name' => 'Smith',
        'md_mediation_legal_aid' => 'Y'
    }
  end

  def invalid_mediator
    valid_mediator.merge('registration_no' => generate_invalid_registration_no)
  end

  def generate_valid_registration_no
    generate_registration_no('T')
  end

  def generate_invalid_registration_no
    generate_registration_no('X')
  end

  def generate_registration_no(postfix)
    rand.to_s[-4..-1]+postfix
  end

  # def collection
  #   data = []
  #   data << valid_mediator.values
  #   data << data[0]
  #   data
  # end

end