require 'rails_helper'

RSpec.describe Shop, type: :model do
  # Association test
  it { should have_many(:orders).dependent(:destroy) }
  it { should have_many(:products).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:name) }
end
