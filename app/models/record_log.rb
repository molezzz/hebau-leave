class RecordLog < ApplicationRecord
  belongs_to :record
  belongs_to :user
  enum kind: {
    refusal: -2,  # 被驳回
    cancel: -1,  # 取消申请
    created: 0,
    superior: 1,  # 上级
    college: 2,   # 学校
    filing: 3     # 组织部备案
  }
  default_scope { order(created_at: :asc) }
end
