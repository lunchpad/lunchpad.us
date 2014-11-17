require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  should belong_to(:menu_item)
  should belong_to(:school)

  should validate_presence_of(:date)
end
