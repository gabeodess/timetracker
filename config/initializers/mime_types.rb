# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
# Mime::Type.register "md5", :md5
# Mime::Type.register "images", :images

# => MIME_MAP = [['type1', 'extention1'], ['type2', 'extention2']... etc.]
MIME_MAP = open(`pwd`.gsub("\n",'/config/initializers/mime_types.txt')).read.split("\n").map{|item| item.split("\t")}

IMAGE_EXTENSIONS = ['jpg', 'png', 'gif']
AUDIO_EXTENSIONS = ["mp2", "mp3", "mpga"]
VIDEO_EXTENSIONS = ["mp2", "mp4", "mpe", "mpeg", "mpg", "mov", "qt", "avi"]

IMAGE_TYPES = MIME_MAP.select{|item| IMAGE_EXTENSIONS.include?(item.last)}.map(&:first).uniq
AUDIO_TYPES = MIME_MAP.select{|item| AUDIO_EXTENSIONS.include?(item.last)}.map(&:first).uniq
VIDEO_TYPES = MIME_MAP.select{|item| VIDEO_EXTENSIONS.include?(item.last)}.map(&:first).uniq

# IMAGE_TYPES = ['image/gif', 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png']
# AUDIO_TYPES = ['audo/mpeg']
# VIDEO_TYPES = ['video/x-msvideo', 'video/quicktime', 'video/mpeg']

