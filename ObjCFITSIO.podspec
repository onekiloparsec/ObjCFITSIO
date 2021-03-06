Pod::Spec.new do |s|
  s.name         			= "ObjCFITSIO"
  s.version      			= "0.2.5"
  s.summary      			= "ObjCFITSIO is an asynchronous Objective-C wrapper around cfitsio bringing object concepts to the famous FITS file library."
  s.description  = <<-DESC
                   ObjCFITSIO has been started in support of the development of an OSX app which is intended to be a kind of iTunes-for-FITS files, currently ongoing at onekiloparsec's headquarters.
                   It is also used in the 3rd version of the FITS files QuickLook OSX plugin QLFits3, open source on github.
                   It is voluntarily asynchronous by design (since operations on large images can be long), and use Grand Central Dispatch to achieve so.
                   Ultimately, I would like to see it supporting most of the APIs of cfitsio.
                   DESC
  s.homepage     			= "http://onekilopars.ec/fits"
  s.license      			= { :type => 'GPLv2', :file => 'LICENSE' }
  s.author       			= { "Cédric Foellmi" => "cedric@onekilopars.ec" }
  s.osx.deployment_target 	= '10.8'
  s.source       			= { :git => "https://github.com/onekiloparsec/ObjCFITSIO.git", :tag => "#{s.version}" }
  s.source_files 			= 'ObjCFITSIO/**/*.{h,m,c}', 'Utilities/**/*.{h,m,c}', 'cfitsio/**/*.{h,m,c}'
  s.public_header_files 	    = 'ObjCFITSIO/*.h, cfitsio/.{h}'
  s.vendored_libraries 	 	= 'cfitsio/libcfitsio.a'
  s.dependency				'RegexKitLite', '~> 4.0'
  s.osx.framework   		    = 'Foundation'
  s.requires_arc 			= true
end

