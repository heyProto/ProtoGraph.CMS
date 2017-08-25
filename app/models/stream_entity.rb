# == Schema Information
#
# Table name: stream_entities
#
#  id           :integer          not null, primary key
#  stream_id    :integer
#  entity_type  :string(255)
#  entity_value :string(255)
#  is_excluded  :boolean
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class StreamEntity < ApplicationRecord
end
