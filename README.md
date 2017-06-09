# IOS猜题游戏

1. 新建项目

2. 拷贝素材

3. 懒加载模型数据

4. 通过storyboard设计"超级猜图"的上半部分界面。
1> 一个UIImageView做背景
2> 分析界面上的控件应该使用什么控件
** 注意按钮点击没有高亮效果取消: highlighted adjust image属性


5. 实现状态栏白色文字效果。

6. 实现点击"下一题"功能。
* 使用一个index属性来记录当前显示的题目的索引。
* 点击"下一题"的时候, 从数组中获取对应的题目, 并显示到对应的界面控件上。
* 解决最后一题之后再次点击"下一题"索引越界问题。sender.enabled = (self.index != self.questions.count - 1);
** 注意: 设置按钮图片的时候, 通过调用 setImage:forState:UIControlStateNormal] 方法来设置。


7. 在viewDidLoad中初始化第一个问题（显示第一个问题到界面上）。
* 设置self.index = -1
* 手动调用"下一题"按钮的点击事件


8. 实现"查看大图"功能。
** 点击右侧"大图"按钮, 显示大图
* 实现思路（步骤）:
1> 添加一个"阴影"按钮, 因为该"阴影"要实现点击, 所以用"按钮"。
2> 然后再把"头像按钮"显示在"阴影"上面。
3> 通过动画的方式改变"头像按钮"的frame(位置和尺寸)变成大图效果。

** 注意: 如果图片没有变大, 检查是否没有取消"自动布局(Auto Layout)"

** 点击"遮罩阴影", 回到小图
1> 通过动画慢慢将"遮罩阴影"的透明度变为0
2> 通过动画慢慢将"头像图片"的frame修改为原来的位置
3> 在动画执行完毕后, 移除"遮罩阴影"

** 点击图片本身显示大图, 再次点击图片本身显示小图





9. 动态生成"答案按钮"。
* 思路:
0> 在点击"下一题"按钮中实现该功能
1> 创建一个UIView来存放所有的"答案按钮"
2> 根据每个问题的答案的文字个数来创建按钮
3> 每次创建按钮之前, 先把旧的按钮都删除
4> 指定每个"答案按钮"的尺寸和中间的margin, 然后计算第一个按钮的x值（marginLeft）。
5> 在循环中, 计算每个按钮的x值（y值都是0）。



10. 动态生成"待选项按钮"。
* 思路:
0> 在点击"下一题"按钮中实现该功能
1> 创建一个UIView来存放所有的"待选项按钮"
2> 根据每个问题的options数组中的元素个数来创建按钮
3> 每次创建按钮之前, 先把旧的按钮都删除
4> 指定每个"答案按钮"的尺寸和中间的margin, 然后计算第一个按钮的x值（marginLeft）。
5> 计算每个按钮的y值。



11. 实现"待选按钮"的单击事件
* 隐藏当前被点击的"待选按钮"
* 将当前被点击的"待选按钮"的文字显示到"答案按钮"的左起第一个为空的按钮上
* 如果"答案按钮"已经全部填满了, 那么就不允许再点击"待选按钮"了。
(
** 注意: 只要父控件不能处理事件, 那么子控件也无法处理事件。
1> 如果"答案按钮"文字填满了, 则设置option view禁止与用户交互
self.optionsView.userInteractionEnabled = NO;

2> 当用户再次点击"答案按钮"时 或 点击"下一题"后在创建"待选按钮"的时候再次启用option view与用户的交互功能
self.optionsView.userInteractionEnabled = YES;
)



12. 实现"答案按钮"的单击事件
* 设置被点击的"答案按钮"文字为空(nil)
* 设置与当前被点击的"答案按钮"相对应的"待选按钮"显示出来
(
** 注意: 这里注意一个bug, 当答案按钮中有两个相同的文字的option按钮时的问题
** 解决: 
1> 为每个option按钮设置一个唯一的tag
2> 在点击某个option按钮的时候, 把option按钮的text和tag都设置到answer按钮上
3> 在点击answer按钮的时候, 判断answer按钮的文字与tag同时都与某个option按钮匹配时, 再显示这个option按钮
)
* 设置所有"答案按钮"的文字颜色为黑色


13. 在"待选按钮"的单击事件中, 判断当前的答案的正确性
* 每次点击"待选按钮"都需要做判断, 如果答案按钮"满了", 再去判断正确性
* 如果正确:
1> 那么设置"答案按钮"的文字颜色为蓝色
2> +100分
3> 0.5秒钟后自动跳转到下一题(如果遇到最后一题, 出现"数组越界"问题, 需要在"下一题"中做判断)
(
	在self.index++ 之后判断, 如果数组越界了, 那么就弹出一个UIAlertView提示用户。
)
* 如果错误:
1> 答案按钮的文字设置为红色


14. 点击"提示"按钮
* 扣除100分
* 清空所有"答案按钮"的文字（相当于点击了每一个"答案按钮", 不是简单的设置"答案按钮"的文字为nil）
* 并将正确答案的第一个文字设置到第一个"答案按钮"上(相当于正确答案的option按钮被点击了), 通过调用字符串的substringToIndex:来截取第一个字符的字符串



15. 数组的makeObjectsPerformSelector:SEL方法来减少自己写循环代码.

16. 封装方法
* 封装设置分数的代码
* 封装统一设置"答案按钮"颜色的文字
* 封装检查答案是否正确的代码



17. AppIcon 和 LaunchImage
* 为什么会有很多的AppIcon? 因为有很多地方要用到。
1> iPhone上显示的应用程序图标
2> 在AppStore上显示的图标
3> SpotLight上显示的图标

** AppIcon的尺寸可以查帮助文档:
iOS8.1 -> User Experience -> Guides -> App Icons on iPad and iPhone

* 启动图片介绍（参考ppt）

问题: 为什么同样一张图片要做很多张？
原因1> 因为不同的iPhone的屏幕大小可能不一样, 即便同样大小的屏幕, 分辨率也不一样, 所以为了在不同手机上都能正常显示（高质量显示）所以对于长得一样的图片要做不同的版本。
原因2> 同样一个图片（比如:AppIcon）在不同的地方都要显示, 并且不同的地方需要的图片的尺寸是不一样的, 所以在这种情况下也需要做多个图.



18.KVC(Key Value Coding)介绍: 通过给定一个对象的属性名称(以字符串方式), 然后找到对象的相应属性进行赋值。

* setValue:forKeyPath:
** 示例: [self setValue:dict[@"icon"] forKeyPath:@"icon"]
** 含义: 表示根据forKeyPath:@"icon"提供的@"icon"去self对象中查找名字叫icon的属性, 找到以后把dict[@"icon"]中获取到的值赋值给self的icon属性。


* setValuesForKyesWithDictionary:
** 含义: 更简便的调用方式。内部相当于调用了多次setValue:forKeyPath:

** 使用KVC时的注意点:
1> 必须保证字典中的key与模型的属性名称一致。
2> 必须保证模型的属性个数与字典一致或者模型的属性个数要大于等于字典的个数。

* 演示KVC:
1> 新建一个model类。
2> 演示对字符串类型、数字类型进行KVC赋值
3> 通过KVC取值。
id v = [对象 valueForKeyPath:@"key"];
int v1 = [[对象 valueForKeyPath:@"key"] intValue];

4> 把模型转成字典, 把对象中指定的属性转换为字典。
NSDictioanry *dict = [对象 dictionaryWithValuesForKeys:@[@"name", @"age"]];

5> 把一个person数组中的每个person对象的name都获取出来然后放到一个新的数组中。
(
	NSArray *names = [person数组 valueForKeyPath:@"name"];
)

6> keyPath介绍, 人拥有一本书, 通过kvc获取人所拥有的书的名称
(
	NSString *bkName = [person valueForKeyPath:@"book.name"];
	
	等价于
	
	NSString *bkName = person.book.name;
)

* KVO (Key Value Observing), 监听对象的属性值变化。




------------- UIAlertView通过代理来监听按钮的点击事件 ---------------------
1. 创建一个UIAlertView对象
2. 在创建UIAlertView对象的时候, 指定代理对象（一般情况下, 代理对象就是控制器）
3. 让代理对象遵守UIAlertViewDelegate
4. 让代理对象实现UIAlertViewDelegate协议中的clickedButtonAtIndex:方法
5. 在该方法中, 根据buttonIndex的索引来判断用户点击的是哪个按钮

------------- UIAlertView通过代理来监听按钮的点击事件 ---------------------








