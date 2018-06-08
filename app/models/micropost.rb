class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true,
    length: {maximum: Settings.maximum_contain}
  validate :picture_size
  default_scope ->{order created_at: :desc}
  scope :find_user_id_in_db, ->(id, following_ids){where "user_id IN (?) OR user_id = ?", following_ids, id}
  mount_uploader :picture, PictureUploader

  private

  # Validates the size of an uploaded picture.
  def picture_size
    errors.add :picture, I18n.t("lessthen5MB") if picture.size > Settings.size_of_picture.megabytes
  end
end
