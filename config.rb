###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  activate :minify_html

  activate :image_optim

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :deploy do |deploy|

end

aws_config = YAML::load(File.open('aws.yml'))


activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = aws_config['s3_bucket'] # The name of the S3 bucket you are targetting. This is globally unique.
  s3_sync.region                     = aws_config['aws_region']     # The AWS region for your bucket.
  s3_sync.aws_access_key_id          = aws_config['access_key_id']
  s3_sync.aws_secret_access_key      = aws_config['secret_access_key']
  s3_sync.delete                     = false # We delete stray files by default.
  s3_sync.after_build                = false # We chain after the build step by default. This may not be your desired behavior...
  s3_sync.prefer_gzip                = true
  s3_sync.reduced_redundancy_storage = false
  end

activate :cloudfront do |cf|
  cf.access_key_id              = aws_config['access_key_id']
  cf.secret_access_key          = aws_config['secret_access_key']
  cf.distribution_id            = aws_config['cloud_front_dist_id']
  cf.filter                     = /(.html|.xml)/
  cf.after_build                = false
end
