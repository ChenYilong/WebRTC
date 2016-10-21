## WebRTC的iOS框架编译

 1. 下载源码
 2. 编译
 
### 下载源码

官方教程 ：https://webrtc.org/native-code/ios/

教旧的一篇教程（2013年的旧文）：

 原文：[How to get started with WebRTC and iOS without wasting 10 hours of your life](http://ninjanetic.com/how-to-get-started-with-webrtc-and-ios-without-wasting-10-hours-of-your-life/) 
 译文：[《WebRTC的iOS框架编译》]( http://io.diveinedu.com/2015/02/02/第五章-WebRTC的iOS框架编译.html ) 

这篇教程里的有一些命令是错误的：

 ```Objective-C
gclient config --name src http://webrtc.googlecode.com/svn/trunk
echo "target_os = ['ios']" >> .gclient
 ```

需要改为：

SVN已经改为了GIT管理， 地址是<https://chromium.googlesource.com/external/webrtc.git>

直接将 `.gclient` 改为：

 ```Objective-C
solutions = [{
  'name': 'src',
  'url': 'https://chromium.googlesource.com/chromium/src.git',
  'deps_file': '.DEPS.git',
  'managed': False,
  'custom_deps': {
    # Skip syncing some large dependencies WebRTC will never need.
    'src/chrome/tools/test/reference_build/chrome_linux': None,
    'src/chrome/tools/test/reference_build/chrome_mac': None,
    'src/chrome/tools/test/reference_build/chrome_win': None,
    'src/native_client': None,
    'src/third_party/cld_2/src': None,
    'src/third_party/hunspell_dictionaries': None,
    'src/third_party/liblouis/src': None,
    'src/third_party/pdfium': None,
    'src/third_party/skia': None,
    'src/third_party/trace-viewer': None,
    'src/third_party/webrtc': None,
  },
  'safesync_url': ''
}]
cache_dir = None
target_os = ['ios']
 ```
 
  见：[chromium / external / webrtc / master / . / chromium / .gclient](https://chromium.googlesource.com/external/webrtc/+/master/chromium/.gclient) 


 参考： [The chromium / webRTC build system](http://webrtcbydralex.com/index.php/2015/07/18/the-chromium-webrtc-build-system/) 
 
终端翻墙问题：

一般是通过环境变量翻墙：


 ```Objective-C
export HTTP_PROXY=xxxxx
export HTTPS_PROXY=xxxxx
 ```

但会sync失败，遇到的现象描述：

http://www.idom.me/articles/843.html

结论：终端环境变量翻墙：

谷歌的工程不支持访问。

报错如下：

 > NOTICE: You have PROXY values set in your environment, but gsutil in depot_tools does not (yet) obey them.
Also, --no_auth prevents the normal BOTO_CONFIG environment variable from being used.
To use a proxy in this situation, please supply those settings in a .boto file pointed to by the NO_AUTH_BOTO_CONFIG environment var. 

这个就是告诉你，google 的这套工具不支持 `HTTP_PROXY` 环境变量做代理

（推测使用 VPN 也可以解决，设置 VPN，然后把其他的代理设置都关掉。）

按照提示清除环境变量，设置一个 `.boto`文件，随便在一个文件夹下做一个`.boto`

 ```Objective-C
set NO_AUTH_BOTO_CONFIG=/Users/chenyilong/Documents/.boto
 ```

`.boto` 文件内容如下：

 ```Objective-C
[Boto]
proxy = 127.0.0.1
proxy_port = 8087
 ```

注意将 `HTTP_PROXY` 环境变量设为空是不行的，`HTTP_PROXY` 环境变量还是存在：

 ```Objective-C
	export http_proxy=
	export HTTPS_PROXY=
 ```

 ```Objective-C
echo $HTTPS_PROXY
 ```

要使用 `unset` 命令

 ```Objective-C
unset http_proxy
 ```
 
 `unset` 后，就可以重新借助 `.boto` 翻墙下载了:
 
 ```Objective-C
gclient runhooks
 ```

终端翻墙问题参考：
 [《使用代理同步Chromium代码的心得(V2.0)》]( http://blog.sina.com.cn/s/blog_496be0db0102voit.html ) 
 [《[已解决]下载chromium源码 download_from_google_storage 无法下载文件》]( http://www.cnblogs.com/ayanmw/p/4500825.html ) b

### 编译

译文： [《在iOS上搭建WebRTC框架》]( http://webrtc.org.cn/ios-framework/#respond ) 
原文： [Building a Fat WebRTC framework on iOS](https://medium.com/@atsakiridis/building-a-fat-webrtc-framework-on-ios-8610fffb2224#.rfvq4u1oa) 

注意文章中的命令应该是：

 ```Objective-C
gn gen out/Release-universal --args='target_os="ios" target_cpu="x64" additional_target_cpus=["arm", "arm64", "x86"] is_component_build=false is_debug=false ios_enable_code_signing=false'
 ```
 
 
 ```Objective-C
Done. Made 1181 targets from 105 files in 6942ms
 ```

其中，如果出现下面的错误：

 ```Objective-C
$ gn gen out/Debug-device-arm64 --args='target_os="ios" target_cpu="arm64" is_component_build=false'
['/Users/chenyilong/opensource/webrtc_build/webrtc/src/buildtools/mac/gn', 'gen', 'out/Debug-device-arm64', '--args=target_os="ios" target_cpu="arm64" is_component_build=false']
Traceback (most recent call last):
  File "/Users/chenyilong/opensource/webrtc_build/depot_tools/gn.py", line 39, in <module>
    sys.exit(main(sys.argv))
  File "/Users/chenyilong/opensource/webrtc_build/depot_tools/gn.py", line 34, in main
    return subprocess.call([gn_path] + args[1:])
  File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/subprocess.py", line 522, in call
    return Popen(*popenargs, **kwargs).wait()
  File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/subprocess.py", line 710, in __init__
    errread, errwrite)
  File "/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/subprocess.py", line 1335, in _execute_child
    raise child_exception
OSError: [Errno 13] Permission denied
 ```

如果没有权限，记得开启权限：

 ```Objective-C
chmod +x src/buildtools/mac/gn
 ```

 [《WebRTC-编译以及运行IOS的Demo》]( http://www.jianshu.com/p/1b4c79b45055 ) 
 
 
 编译后的 Framework 目录结构如下：
 
 
 ```Objective-C
 
└── Headers
    ├── RTCAVFoundationVideoSource.h
    ├── RTCAudioSource.h
    ├── RTCAudioTrack.h
    ├── RTCCameraPreviewView.h
    ├── RTCConfiguration.h
    ├── RTCDataChannel.h
    ├── RTCDataChannelConfiguration.h
    ├── RTCDispatcher.h
    ├── RTCEAGLVideoView.h
    ├── RTCFieldTrials.h
    ├── RTCFileLogger.h
    ├── RTCIceCandidate.h
    ├── RTCIceServer.h
    ├── RTCLegacyStatsReport.h
    ├── RTCLogging.h
    ├── RTCMacros.h
    ├── RTCMediaConstraints.h
    ├── RTCMediaSource.h
    ├── RTCMediaStream.h
    ├── RTCMediaStreamTrack.h
    ├── RTCMetrics.h
    ├── RTCMetricsSampleInfo.h
    ├── RTCPeerConnection.h
    ├── RTCPeerConnectionFactory.h
    ├── RTCRtpCodecParameters.h
    ├── RTCRtpEncodingParameters.h
    ├── RTCRtpParameters.h
    ├── RTCRtpReceiver.h
    ├── RTCRtpSender.h
    ├── RTCSSLAdapter.h
    ├── RTCSessionDescription.h
    ├── RTCTracing.h
    ├── RTCVideoFrame.h
    ├── RTCVideoRenderer.h
    ├── RTCVideoSource.h
    ├── RTCVideoTrack.h
    ├── UIDevice+RTCDevice.h
    └── WebRTC.h
 ```

下面做下分析：
下面做下分析：


🔴ICE

🔵PC

⬛RTP 统计数据处理API


 ```Objective-C
└── Headers
    ├── RTCAVFoundationVideoSource.h
    ├── RTCAudioSource.h
    ├── RTCAudioTrack.h # AudioMediaStreamTrack 是 MediaStreamTrack 的子类，只能承载sourceType为音频的媒体
    ├── RTCCameraPreviewView.h
    ├── RTCConfiguration.h    #🔴包含ICE服务的数组
    ├── RTCDataChannel.h #表示RTCPeerConnection 上可传输任意应用程序的通道
    ├── RTCDataChannelConfiguration.h
    ├── RTCDispatcher.h
    ├── RTCEAGLVideoView.h
    ├── RTCFieldTrials.h
    ├── RTCFileLogger.h
    ├── RTCIceCandidate.h     #🔴表示ICE候选项的容器
    ├── RTCIceServer.h        #🔴ICE服务器URL容器
    ├── RTCLegacyStatsReport.h
    ├── RTCLogging.h
    ├── RTCMacros.h
    ├── RTCMediaConstraints.h # 发Offer时需要使用到，告知对方自己的轨道情况是否有：音频、视频。
    ├── RTCMediaSource.h
    ├── RTCMediaStream.h       #表示MediaStreamTrack的集合，目前仅仅包含音频和视频。需要添加到RTCPeerConnection
    ├── RTCMediaStreamTrack.h #表示媒体源的单个轨道，请注意，每个轨道可包含多个通道，例如编码为单个轨道的6声道环绕声源。此外每个轨道只能包含一种媒体，而不它有多少个通道。 
    ├── RTCMetrics.h
    ├── RTCMetricsSampleInfo.h
    ├── RTCPeerConnection.h    #🔵表示两个对等端之间的WebRTC连接
    ├── RTCPeerConnectionFactory.h
    ├── RTCRtpCodecParameters.h
    ├── RTCRtpEncodingParameters.h
    ├── RTCRtpParameters.h
    ├── RTCRtpReceiver.h
    ├── RTCRtpSender.h
    ├── RTCSSLAdapter.h
    ├── RTCSessionDescription.h #SDP提议、应答或者临时应答（pranswer）的容器
    ├── RTCTracing.h
    ├── RTCVideoFrame.h
    ├── RTCVideoRenderer.h
    ├── RTCVideoSource.h
    ├── RTCVideoTrack.h  # 视频轨道，需要添加到RTCMediaStream上
    ├── UIDevice+RTCDevice.h
    └── WebRTC.h                 #头文件
 ```