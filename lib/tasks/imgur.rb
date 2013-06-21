require 'curb'
require 'crack/json'
require 'cgi'

# @author Justin Poliey
# Imgur module
module Imgur

	# General Imgur error container
	class ImgurError < RuntimeError
		
		def initialize message
			@message = message
			super
		end
		
	end

	# Imgur API interface
	class API

		# Creates a new Imgur API instance
		#
		# @param [String] api_key Your API key from http://imgur.com/register/api/
		# @return [API] An Imgur API instance
		def initialize api_key
			@api_key = api_key
		end

		# Uploads an image from local disk
		#
		# @param [String] image_filename The filename of the image on disk to upload
		# @raise [ImgurError]
		# @return [Hash] Image data
		def upload_file image_filename
			c = Curl::Easy.new("https://api.imgur.com/3/upload.json")
			c.multipart_form_post = true
			c.headers['Authorization'] = "Client-ID #{@api_key}"
			c.http_post(Curl::PostField.file('image', image_filename))
			response = Crack::JSON.parse c.body_str
			#raise ImgurError, response["error_msg"] if response["rsp"]["stat"] == "fail"
			response["data"]
		end
		
		# Uploads a file from a remote URL
		#
		# @param [String] image_url The URL of the image to upload
		# @raise [ImgurError]
		# @return [Hash] Image data
		def upload_from_url image_url
			c = Curl::Easy.new("https://api.imgur.com/3/upload.json")
			c.headers['Authorization'] = "Client-ID #{@api_key}"
			c.http_post(Curl::PostField.content('image', image_url))
			response = Crack::JSON.parse c.body_str
			#raise ImgurError, response["rsp"]["error_msg"] if response["rsp"]["stat"] == "fail"
			response["data"]
		end
end
