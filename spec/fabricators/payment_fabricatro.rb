Fabricator(:payment) do
  user
  reference_id { Faker::Lorem.characters(10) }
  amount { Faker::Number.number(3).to_i }
end