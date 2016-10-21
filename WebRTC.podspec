Pod::Spec.new do |s|

  s.name         = "WebRTC"
  s.version      = "1.0.0"
  s.summary      = "WebRTC is a free, open project that provides browsers and mobile applications with Real-Time Communications capabilities via simple APIs."
  s.homepage     = "https://github.com/ChenYilong/WebRTC"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "ChenYilong" => "luohanchenyilong@163.com" }
  s.platform     = :ios, '7.0'
  s.frameworks = 'AVFoundation', 'AudioToolbox', 'CoreGraphics', 'CoreMedia', 'GLKit', 'UIKit', 'VideoToolbox'
  s.source       = { :git => "https://github.com/ChenYilong/WebRTC", :tag => s.version.to_s }
  s.vendored_frameworks = 'WebRTC/WebRTC.framework'
  s.requires_arc = true
  s.license      = {
    :type => 'https://webrtc.org/license/software/',
    :text => <<-LICENSE
      Copyright (c) 2011, The WebRTC project authors. All rights reserved.

      Redistribution and use in source and binary forms, with or without
      modification, are permitted provided that the following conditions are
      met:

        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.

        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in
          the documentation and/or other materials provided with the
          distribution.

        * Neither the name of Google nor the names of its contributors may
          be used to endorse or promote products derived from this software
          without specific prior written permission.

      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
      A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
      HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
      LICENSE
  }

end