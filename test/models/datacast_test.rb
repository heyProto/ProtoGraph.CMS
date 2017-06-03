# == Schema Information
#
# Table name: datacasts
#
#  id                    :integer          not null, primary key
#  slug                  :string(255)
#  template_datum_id     :integer
#  external_identifier   :string(255)
#  status                :string(255)
#  data_timestamp        :datetime
#  last_updated_at       :datetime
#  last_data_hash        :string(255)
#  count_publish         :integer
#  count_duplicate_calls :integer
#  count_errors          :integer
#  input_source          :string(255)
#  error_messages        :text(65535)
#  data                  :text(65535)
#  created_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class DatacastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
