class Event < ApplicationRecord
	acts_as_taggable
	has_many_attached :images
	has_many_attached :videos
	has_one_attached :thumbnail

	extend FriendlyId
	friendly_id :title, use: :slugged

	scope :most_recent, -> { order(published_at: :desc)}
	scope :published, -> { where(published: true)}
	validates :title , presence: true
	validates :content, presence: true 
	validate :image_type
	
	def should_generate_new_friendly_id?
		title_changed?
	end

	def published_date
		if(published) 
			"Published #{published_at.strftime('%-b %-d, %Y')}"
		else
			"Not published yet"
		end
	end

	def resize_image input
		return self.images[input].variant(resize: "200x200!").processed
	end

	def image_type
		if !thumbnail.content_type.in?(%('image/jpeg image/png image/jpg'))
			errors.add(:thumbnail, "not in JPEG or PNG or JPG form")
		end
		images.each do |image|
			if !image.content_type.in?(%('image/jpeg image/png image/jpg'))
				errors.add(:images, "not in JPEG or PNG or JPG form")
			end
		end
	end
end
