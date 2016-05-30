# WQPChartView
这是基于SNChartView,自己进一步进行整合并且完善的quartz2D,即柱状折线图,希望大家支持.
=======
#The premise
因为个人的项目需求是柱状和折线结合的图,所以就在SNChartView的基础上自己再封装了一个WQPChartAll类来满足需求.

##WQPChart
提供接口方法,也就是初始化化图形,选择Chartstyle,给Datasource赋值即可.
- (NSMutableArray *)chatConfigYValue:(WQPChart *)chart;//Y轴的坐标赋值
- (NSMutableArray *)chatConfigXValue:(WQPChart *)chart;//X轴的坐标赋值

##WQPChartAll
这个类提供了柱状折线为一体的功能.另外还附加了本人写的button,label,毕竟一张图,不可能就空空的放在那里.写的不会很复杂,小伙伴们可以根据
自己的需求进行增加.

##WQPChartBar
这个类只提供柱状图.

##WQPChartLine
这个类只提供折线图.

##Running effect
![](http://img0.ph.126.net/HMA-G1Wh-qX4DtDjBGoY5w==/6631705482442625997.jpeg)
