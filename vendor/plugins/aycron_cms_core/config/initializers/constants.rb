# MODULES
BLOG_ACTIVE = false
SIMPLE_CAPTCHA_ACTIVE = false
ROLLOVER_BEETHOVEN_ACTIVE = false
LAST_UPDATED_ACTIVE = false
FCKEDITOR_S3_ACTIVE = false
ATTACHMENT_FU_S3_JO = false
APPLICATION_NAME = ""
AUTHETICATIONS_IDENTIFICATION_FIELD = "username"

# OPTIONS CONSTANTS
#LAST_UPDATED_DATE = 'LAST_UPDATED_DATE'
#GOOGLE_ANALYTICS_CODE = 'GOOGLE_ANALYTICS_CODE'
#OPTION_MAIL_SUBJECT  = 'MAIL_SUBJECT'
#OPTION_MAIL_TO       = 'MAIL_TO'
OPTION_MAIL_FROM     = 'MAIL_FROM'
MAIL_DELIVERY_METHOD = 'MAIL_DELIVERY_METHOD'
SMTP_ADDRESS        = 'SMTP_ADDRESS'
SMTP_PORT           = 'SMTP_PORT'
SMTP_DOMAIN         = 'SMTP_DOMAIN'
SMTP_USER_NAME      = 'SMTP_USER_NAME'
SMTP_PASSWORD       = 'SMTP_PASSWORD'
SMTP_AUTHENTICATION = 'SMTP_AUTHENTICATION'
#FOOTER_TEXT = 'FOOTER_TEXT'

STRING_OPTION_TYPE    = 'STRING'
TEXT_OPTION_TYPE      = 'TEXT'
RICH_TEXT_OPTION_TYPE = 'RICH_TEXT'
PASSWORD_OPTION_TYPE  = 'PASSWORD'

# FILE UPLOAD (FCKEditor, attachment_fu and render image)
UPLOADED_S3 = "uploads"
UPLOADED = "/uploads"
UPLOADED_PREFIX = "public" + UPLOADED
UPLOADED_ROOT = RAILS_ROOT + "/public" + UPLOADED
MIME_TYPES = [
  "image/jpg",
  "image/jpeg",
  "image/pjpeg",
  "image/gif",
  "image/png",
  "application/x-shockwave-flash",
  "application/pdf",
  "application/zip",
  "application/x-zip-compressed",
  "application/msword",
  "application/octet-stream"
]
IMAGE_MIME_TYPES = [
  "image/jpg",
  "image/jpeg",
  "image/pjpeg",
  "image/gif",
  "image/png"
]
FCKEDITOR_TOOLBAR_SET = 'Default'
FCKEDITOR_BLOG_TOOLBAR_SET = 'Default'
FCKEDITOR_BLOG_COMMENTS_TOOLBAR_SET = 'Default'
FCKEDITOR_WIDTH       = 600
FCKEDITOR_HEIGHT      = 300

# EXCEPTION NOTIFIER
EXCEPTION_NOTIFIER_FROM = %w(ruby.exception.listeners@aycron.com)
EXCEPTION_NOTIFIER_TO = %w(ruby.exception.listeners@aycron.com)
EXCEPTION_NOTIFIER_PREFIX = "[ERROR #{APPLICATION_NAME.upcase}] "
