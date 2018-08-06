\# CKMeiTuanShopView

高仿美团外卖的店铺主页（包括下拉动画效果，解决各种手势问题，并且cell有列表样式，九宫格样式，卡片样式），各种动画效果纵享丝滑，因为写的比较急，还待优化.!

解决UIScollView嵌套UIScollView、UITableview或者UIcollectionView的问题，结合手势和仿动力学UIKit Dynamic实现自定义scollView效果。

![meituan](/image/meituan.gif)

高仿美团外卖GIF

1：手势问题，可参考👆的文章，解释的很详细，包括手势问题，以及如何实现自定义scrollView效果，模拟scrollView的回弹速度，阻尼效果等等.

2：tableview和collectionView都继承与scrollview，根据手势上下滚动以及计算父视图scrollview向上滑动到导航条无缝对接需要的偏移量_maxOffset_Y，来判断是父视图scrollview在进行偏移，还是子视图scrollview在进行偏移，从而设置scrollview.contentOffset.

3:根据scrollview的代理方法scrollViewDidScroll，来监听scrollview的偏移量，来实现头部的动画效果以及导航条的动画效果。

4：判断向下滑动偏移量是否大于设定好的最大偏移量，来让整个商品列表平移向下消失，展示店铺活动优惠券视图。通过滑动手势，从底部向上滑动或者点击导航条的返回按钮，让商品列表平移向上动画展示出来。

5：实现二级联动效果，根据父视图scrollview的偏移量来计算左侧菜单menuTableView的高度，实现动态高度，达到跟美团外卖一样的效果.

6：添加横向scrollview，实现可以横向滑动。

7：实现评价列表上拉加载效果，解决与自定义scrollview偏移量冲突问题。（使用MJRefresh会有问题。）



![店铺商品列表样式](/image/1.png)

店铺商品列表样式

![店铺商品卡片样式](/image/2.png)

店铺商品卡片样式

![店铺商品九宫格样式](/image/3.png)

店铺商品九宫格样式

![评价页面](/image/7.png)

评价页面

![店铺活动](/image/4.png)

店铺活动

![商家介绍](/image/5.png)

商家介绍 仿QQ菜单


**⚠️注意：demo只作为参考，如需使用，请熟悉代码，自行修改～**

简书：https://www.jianshu.com/p/aa920502a12f
