# [MenuView](https://github.com/leiguang/MenuView)



多个标题栏视图。
使用时只需要"setTexts(...)"设置标题，当视图的宽度比内容宽度小时，自动可以左右滚动；反之不能滑动。
提供了三个点击的回调事件"selectedCallback"、“selectedRepeatedCallback”、“selectedIndexChangedCallback”。
提供了一个主动选中的方法”selectedIndex(at: )“。
- Note: 没有对AutoLayout做适配，用代码创建的话请使用先设置menuView.frame，再用“setTexts(..)”赋值
