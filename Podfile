platform :ios, '10.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

project 'app/app.xcodeproj'

def import_pods 
    # sockets
    pod 'Starscream', :git => 'https://github.com/daltoniam/Starscream.git', :branch => 'swift3'
    pod 'ActionCableClient', :git => 'https://github.com/danielrhodes/Swift-ActionCableClient', :branch => 'swift3'
end

target "app" do
    import_pods
end
