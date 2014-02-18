# == Schema Information
#
# Table name: airports
#
#  id           :integer          not null, primary key
#  airport_id   :string(255)
#  airport_name :string(255)
#  city_id      :string(255)
#  city_name    :string(255)
#  country_id   :string(255)
#  country_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  latitude     :float
#  longitude    :float
#

require 'spec_helper'

describe Airport do
  pending "add some examples to (or delete) #{__FILE__}"
end
