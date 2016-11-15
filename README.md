# CHCarousel
Easy\Simple Carsousel
 
 ![](https://github.com/kldxcr/CHCarousel/raw/master/other/CHCarouselShow.gif)

集成步骤：

1、准备所有标题的数组menuTitleArray

2、初始化：赋值menuTitleArray，设置素材，设置初始化位置

3、实现代理：numberOfItemsInScrollMenu ／ VCForItemAtIndex：返回每一页的Controller对象

4、性能处理：页面出现后才加载数据；多页面跳转中间页面不处理；

