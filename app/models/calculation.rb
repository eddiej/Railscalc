class Calculation
  include Mongoid::Document
  field :a, type: Integer
  field :b, type: Integer
  field :operator, type: String
  field :result, type: Float
  field :count, type: Integer, :default => 1
  index({ a: 1, b: 1, operator: 1}) # define index on the search fields 
end
