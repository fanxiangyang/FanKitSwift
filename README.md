# FanKitSwift

A Swift Tool Kit collection of iOS components(一个iOS Swift 集成实用工具库,以后会添加更多更多的工具类库，实用类，封装类，封装小效果等)


## Introduce（介绍）

FanKitSwift 是一组庞大、功能丰富的 iOS 组件。
对于OC支持，部分类功能做了兼容，一些全局方法 没有做适配，建议自己直接写成宏，
或内联函数，或者用到部分函数自己再用类封装一层

目前只是实现了一些常用的方法，SwiftUI的相关东西还没有整理。下面是一些基本功能

* FanSwift — 公共Foundation全局方法。
* FanTool    — Foundation框架的类及工厂方法。
* FanUIKitHead — 公共UIKit全局方法。
* FanUIKitTool — UIKit工具类相关的基本方法。
* FanString — String相关扩展
* FanDataExtension Data Int数据转换
* FanImageExtension 图片裁剪+缩放+截图等方法
* FanViewExtension View VC扩展
* FanPlayer 音视频播放器
* FanSwiftUI SwiftUI相关-目前待完善


### SPM（安装）支持

1. git tag = `1.0.0` 初始版本

### 手动安装

1. 下载 FanKitSwift 项目。
2. 将 FanKitSwift项目。项目里面Sources文件夹及内的源文件添加(拖放)到你的工程。

### Requirements(系统要求)
FanKitSwift该项目最低支持 iOS 12.0。
改一下swift-tools-version: 5.7 降级可能支持iOS11

注意：随着iOS系统更新换代，iOS12.0以下，不适配了,部分API必须12.0。


### Function Example(功能事例)
目前一些基础的测试在Tests里面
测试demo [FanKitDemo](https://github.com/fanxiangyang/FanKitDemo)

更新历史(Version Update)
==============

### Release 1.0.0 
* 1.常用数据处理，Data,String,字典，文件
* 2.FanPlayer 音视频播放器
* 3.全局方法，快捷调用

Like(喜欢)
==============
#### 有问题请直接在文章下面留言,喜欢就给个Star(小星星)吧！ 
#### Email: fqsyfan@gmail.com
#### Email: fanxiangyang_heda@163.com 
