# [MenuView](https://github.com/leiguang/MenuView)

### 多个标题栏视图。

使用"func setTexts(_ texts: [String], config: ((Config)->Void)? = nil)"设置标题及视图配置。<br>
当视图的宽度比内容宽度小时，可以左右滑动；反之不能滑动。

- 获取当前被选中的button的index:
  private(set) var selectedIndex: Int = 0
- 按钮被点击的回调（只要按钮被点击就回走这个回调）:
  var selectedCallback: ((Int)->Void)?
- 按钮已被选中，再次被重复点击时才会回调:
  var selectedRepeatedCallback: ((Int)->Void)?
- 切换了选中按钮时才会回调:
  var selectedIndexChangedCallback: ((Int)->Void)?
- 主动选中某index:
  func selectButtonAt(_ index: Int)

![MenuView](https://github.com/leiguang/MenuView/blob/master/MenuView.gif)
