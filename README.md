# 自己动手实现自己的库支持cocoPods

# 要支持cocoPods,需先注册trunk

1. 注册trunk 命令<br />

>sudo gem install cocoapods

>pod trunk register 邮件名 [用户名]

```objc
邮件名是一个真实的邮箱地址:QQ,hotmial,126等等
用户:leefenghy
```
* 注册成功后返回你的实际邮箱地址进行确认<br />
* 可以用 `pod trunk me`查看个人信息<br />


# 以上完成后接下来才是开始

1. 在`github`上面new 一个Repository<br />
2. 选择Public<br />
3. ☑️`Initialize this repository with a README`<br />
4. Add.gitignore`Objective-C`, Add.license.`MIT`<br />

# 把刚才新建的`Repository `clone到你本地
1. 用终端cd 到你刚才lclone到本地文件的根目录<br />
2. 新建一个`podspec`后缀的文件,终端命令为:`pod spec create XXXXX`<br />
3. 编辑xxxx.podspec,在终端进入编辑:`vi xxxx.podspec` 修改如下信息:可选<br />
```objc
Pod::Spec.new do |s|
  s.name         = "LLLaunchAd"
  s.version      = "1.0.0"
  s.summary      = "A iOS LaunchAd show of MyPodDemo."
  s.homepage     = "https://github.com/LeeFengHY/MyPodDemo"
  s.license      = "MIT"
  s.author             = { "LeeFengHY" => "578545715@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/LeeFengHY/MyPodDemo.git", :tag => "1.0.0" }
  s.source_files  = "LLLaunchAd/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
 end
```
4. 把你要开源的库文件放入到`clone`本地文件夹中,并和刚才修改过的xxxx.podspec一并提交到git仓库中<br />
5. 对于多次修改先给git打上tag如下:<br />
```objc
git commit -m Release 0.0.1
git tag 0.0.1
git push --tags  
git push origin master
```
6. 验证podspec如下:<br />
```objc
pod lib lint --allow-warnings 
或者pod lib lint XXXX.podspec --allow-warnings
```
7. 如果一切顺利会出现`MyPodDemo passed validation.` ,恭喜你<br />
8. 如果有错误和警告会不通过,你可以对应修改相关错误,警告可以用`--allow-warnings`忽略<br />

## 最后一步`trunk`到cocoPods
> `pod trunk push XXXX.podspec`
> `成功可以使用:pod search命令查找你的库了`
<br />
如图在使用`pod search`过程中失败, 或出现这类字样:<br />
`[!] Unable to find a pod with name, author, summary, or descriptionmatching LLLaunchAd`, <br />请参考这篇[文章](http://www.jianshu.com/p/b5e5cd053464)解决

## 效果图
<img src="https://raw.github.com/LeeFengHY/MyPodDemo/master/podspec.png" width="320">
<img src="https://raw.github.com/LeeFengHY/MyPodDemo/master/podspec-2.png" width="320">
<img src="https://raw.github.com/LeeFengHY/MyPodDemo/master/podspec-3.png" width="320">

# 写在结尾
* 过程其实很简单也不繁琐,最重要的还是要自己实现一遍
* 有问题可以联系我QQ578545715

