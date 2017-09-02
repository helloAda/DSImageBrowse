# DSImageBrowse

##### 一个简单的图片浏览控件，效果图如下。

### 默认模式下
 ![效果图](https://github.com/helloAda/DSImageBrowse/blob/master/Demo/SnapShot/default.gif)

### 聊天模式下
 ![效果图](https://github.com/helloAda/DSImageBrowse/blob/master/Demo/SnapShot/chat.gif)

### 具体使用步骤(只显示这个控件的情况)：

* 先将你的图片数据构成一个个DSImagesData对象，放入数组。
* 再利用DSImagesData对象数组初始化DSImageLayout对象，调用laout方法完成排版。
* 然后把DSImageLayout对象放入数组，用于tableView的数据源。
* 接着利用每一个DSImageLoyout对象，初始化DSImageBrowseView，这样就可以出现缩略图的浏览了。
* 最后如果要实现点击、长按、ForceTouch的实现，请参考Demo中的ViewController.



* 当前版本 1.0.1
 
* 支持pod ,  pod 'DSImageBrowse'
* 依赖于YYWebImage、YYCache、YYImage


* 如果有任何疑问可以联系邮箱hmd93@icloud.com，或者添加QQ群：667920542
* 觉得有帮助请Star
