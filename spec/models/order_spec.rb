require 'rails_helper'

RSpec.describe Order, type: :model do
  # Association test
  it { should belong_to(:shop) }
  # Validation test
  it { should validate_presence_of(:date) }
end
