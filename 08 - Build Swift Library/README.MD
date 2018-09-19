# [Build Swift Library](https://github.com/vision66/Tutorial/tree/master/07%20-%20Device%20Base%20Paramters)

参考: [Swift构建通用版本Framework以及Framework的使用及其注意事项](https://www.jianshu.com/p/13ee670f21ac)

从GitHub下载[Alamofire](https://github.com/Alamofire/Alamofire), 然后打开Alamofire.xcodeproj, 于是启动了Xcode.

01.顶部的Scheme切换到Alamofire iOS
![image1](http://img.blog.csdn.net/20180313100828745)

02.中间的TARGETS选中Alamofire iOS, 切换到Build Settings, 搜索Mach-O Type, 将值切换为Static Library
![image2](http://img.blog.csdn.net/20180313100948126)

03.菜单栏Product → Scheme → Edit Scheme, 选中Run, 选中Info, 将Build Configuration改成Release
![image3](http://img.blog.csdn.net/20180313101114384)

04.顶部的Target切换到iPhoneSE(任意模拟器), 然后编译项目(cmd+b)
![image4](http://img.blog.csdn.net/20180313101232357)

05.从左边的Products中, 右键Alamofire.framework, 选择Show in Finder, 可以定位到静态库的目录. 返回上级目录(cmd+↑), 会发现文件夹名是Release-iphonesimulator, 并且在附近有很多类似文件夹
![image5](http://img.blog.csdn.net/20180313101357338)

06.顶部的Target切换到Generic iOS Device(或者真机), 然后编译项目, 会在Release-iphoneos生成类似文件

07.打开终端, 使用cd命令, 定位到这个目录, 执行lipo -info命令, 检查Alamofire, 会发现两个文件分别是"i386 x86_64"和"armv7 arm64"

08.执行lipo -create命令, 将两文件合并为一个, 直接输出到当前目录, 检查新的Alamofire, 会发现它是"i386 x86_64 armv7 arm64"
![image6](http://img.blog.csdn.net/20180313102724886)

09.拷贝Release-iphoneos目录, 并命名为Release. 将新生成的Alamofire替换进去. 将Release-iphonesimulator中Alamofire.swiftmodule目录下的文件, 拷贝到Release中的Alamofire.swiftmodule目录下

10.Release目录下的Alamofire.framework就是我需要的静态库了
![image7](http://img.blog.csdn.net/20180313103025999)

另外, 如果不进行步骤3, Build Configuration将是Debug. 最终对应生成的文件将会在Debug-iphonesimulator和Debug-iphoneos中, 并且Debug-iphoneos中的Alamofire只有x86_64, 如果需要i386, 需要在Build Settings中搜索Build Active Architecture Only, 将Debug的值设置为NO

在我的项目中SwiftlyJSON是使用的源码, 我将Alamofire同样以源码的方式引入项目后, 发现部分方法重复定义了. 并且在调用Alamofire的request等方法时, 是直接request调用, 而不是Alamofire.request这种形式, 于是决定打包一个Alamofire静态库出来