

Pod::Spec.new do |s|
  s.name          = 'DSImageBrowse'
  s.version       = '1.0.2'
  s.summary       = '简单的图片浏览控件'
  s.homepage      = 'https://github.com/helloAda/DSImageBrowse'
  s.license       = 'MIT'
  s.author        = { 'Hello Ada' => 'hmd93@icloud.com' }
  s.platform        = :ios,'8.0'
  s.source        = { :git => 'https://github.com/helloAda/DSImageBrowse.git', :tag => s.version }
  s.source_files  = 'DSImageBrowse/DSImageBrowse/ImageBrowse/**/*'
  s.resources     = 'DSImageBrowse/DSImageBrowse/Resources/*.png'
  s.requires_arc  = true
  s.dependency 'YYCache'    , '~> 1.0.4'
  s.dependency 'YYImage'    , '~> 1.0.4'
  s.dependency 'YYWebImage' , '~> 1.0.5'
end
