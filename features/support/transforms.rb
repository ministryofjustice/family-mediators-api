ERROR_TABLE_SELECTOR = Transform(/\w errors/) do |selector|
  '#' + selector.downcase.tr(' ', '-')
end