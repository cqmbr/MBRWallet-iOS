
Pod::Spec.new do |s|

  s.name         = "MBRWallet"
  s.version      = "0.0.5"
  s.summary      = "MBRWallet."
  s.description  = <<-DESC 
  								MBRWallet For all kind pay
                   DESC

  s.homepage     = "https://github.com/cqmbr/MBRWallet-iOS"
  s.license      = { :type => "Copyright", :text => "LICENSE Copyright 2017 - 2018 cqmbr.net, Inc. All rights reserved." }
  s.author             = { "mbr" => "250153903@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/cqmbr/MBRWallet-iOS.git", :tag => "#{s.version}" }


	s.dependency 'GVUserDefaults'
	s.dependency 'UICKeyChainStore'
	s.dependency 'MBRWalletNetworking'
  
  s.vendored_frameworks = "SDK/Required/*.framework"

end
