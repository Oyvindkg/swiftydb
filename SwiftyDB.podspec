#
# Be sure to run `pod lib lint SwiftyDB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftyDB"
  s.version          = "0.8.2"
  s.summary          = "Making SQLite databases a blast"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
#  s.description      = <<-DESC
#                       DESC

  s.homepage         = "http://oyvindkg.github.io/swiftydb/"
  s.license          = 'MIT'
  s.author           = { "Øyvind Grimnes" => "oyvindkg@yahoo.com" }
  s.source           = { :git => "https://github.com/oyvindkg/SwiftyDB.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oyvindkg'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftyDB' => ['Pod/Assets/*.png']
  }


  s.dependency 'TinySQLite'
  
end
