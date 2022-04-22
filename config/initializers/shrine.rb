require "cloudinary"
require "shrine/storage/cloudinary"
Cloudinary.config(
cloud_name: ENV['CLOUD_NAME'],
api_key:    ENV['CLOUD_API_KEY'],
api_secret: ENV['CLOUD_API_SECRET'],
)
Shrine.storages = {
cache: Shrine::Storage::Cloudinary.new(prefix: "cache"), # for direct uploads
store: Shrine::Storage::Cloudinary.new(prefix: "rails_uploads"),
}
Shrine.plugin :activerecord           # loads Active Record integration
