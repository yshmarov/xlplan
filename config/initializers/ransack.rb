Ransack.configure do |config|
  {
    contained_within_array: :contained_within,
    contained_within_or_equals_array: :contained_within_or_equals,
    contains_array: :contains,
    contains_or_equals_array: :contains_or_equals,
    overlap_array: :overlap
  }.each do |rp, ap|
    config.add_predicate rp, arel_predicate: ap, wants_array: true
  end

  config.add_predicate 'datelteq',
    arel_predicate: 'lteq',
    formatter: proc { |v| v.end_of_day },
    type: :date


end