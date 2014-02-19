# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  settings   :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  start_at   :date
#  end_at     :date
#

require 'spec_helper'

describe Wishlist do
  pending "add some examples to (or delete) #{__FILE__}"
end
