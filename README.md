# DSImageBrowse

##### 一个简单的图片浏览控件。

#效果图
### 默认模式
 ![效果图](https://github.com/helloAda/DSImageBrowse/blob/master/DSImageBrowse/SnapShot/default.gif)

### 聊天模式
 ![效果图](https://github.com/helloAda/DSImageBrowse/blob/master/DSImageBrowse/SnapShot/chat.gif)
### 网页图片
![效果图](https://github.com/helloAda/DSImageBrowse/blob/master/DSImageBrowse/SnapShot/web.gif)

#使用方法

1. 先将你的图片数据构成一个个DSImagesData对象，放入数组
2. 利用DSImagesData对象数组初始化DSImageLayout对象，调用layout方法完成排版
3. 把DSImageLayout对象放入_layout数组，_layout用于tableView的数据源
4. 将DSImageBrowseView做为cell的子控件，_layout中的layout对象依次设置给cell完成缩略图的显示。
5. 在cell的代理中或者block回调中，实现单击present展示视图。

*  基本的思路是这样，具体细节还请看Demo的实现。


```
//1
DSImagesData *imagesData =[[DSImagesData alloc] init];
imagesData.largeImage.url = [NSURL URLWithString:large];
...
//2
[images addObject:imagesData];

DSImageLayout *layout = [[DSImageLayout alloc] initWithImageData:images];
[layout layout];
[_layouts addObject:layout];

...
//3
[cell setLayout:_layouts[indexPath.row]];
...
//4
_imageBrowseView.layout = layout.imageLayout;

...
//5
DSImageScrollItem * item = [[DSImageScrollItem alloc] init];
item.thumbView = imgView;
item.largeImageURL = imageData.largeImage.url;
[items addObject:item];

DSImageShowView *scrollView = [[DSImageShowView alloc] initWithItems:items type:DSImageShowTypeDefault];
[scrollView presentfromImageView:fromView toContainer:self.navigationController.view index:index animated:YES completion:nil];


//展示网页图片只需实现以下方法
/**
@param images 图片的url数组 传NSString类型
@param currentImage 当前图片的url
*/
DSWebImageViewController *vc = [[DSWebImageViewController alloc] initWithImages:images currentImage:images[i]];
[self.navigationController pushViewController:vc animated:YES];
``



# 其他问题
* 当前版本 1.0.2
 
* 支持pod ,  pod 'DSImageBrowse'
* 依赖于YYWebImage、YYCache、YYImage


* 如果有任何疑问可以[Issues](https://github.com/helloAda/DSImageBrowse/issues)、联系邮箱hmd93@icloud.com、添加QQ群：667920542
* 觉得有帮助请点个star吧，我会持续跟进。

# 相关链接
[iOS图片浏览库](http://www.jianshu.com/p/6a5da7669755) 
