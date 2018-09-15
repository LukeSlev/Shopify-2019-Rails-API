require 'rails_helper'

RSpec.describe LineItem, type: :model do
  # Association test
  it { should belong_to(:product) }
  it { should belong_to(:order) }
  # Validation test
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cost) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:total) }
end
