class Record < ApplicationRecord
    belongs_to :user
    belongs_to :approver,required: false

    store :exdata, accessors: [:unit_opinion, :leader_opinion], coder: JSON
end
