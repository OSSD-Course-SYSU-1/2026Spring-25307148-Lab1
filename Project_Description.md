# ArkTSAlgorithm 工程代码深度解析

## 一、项目概述
- **项目名称**：ArkTSAlgorithm
- **项目来源**：华为 HarmonyOS Codelabs（Gitee 开源）
- **许可证**：Apache-2.0
- **开发语言**：ArkTS
- **目标平台**：HarmonyOS NEXT (API 11)
- **项目简介**：通过 ArkTS 语法实现多种常用算法，并提供交互界面展示运行结果，适合学习 ArkTS 声明式 UI 和基础算法。

## 二、目录结构及功能说明

ArkTSAlgorithm/
├── AppScope/                  # 应用全局配置
│   └── app.json5              # 应用包名、版本、图标等
├── entry/                     # 主模块
│   └── src/main/
│       ├── ets/               # ArkTS 源代码
│       │   ├── entryability/  # 应用入口 Ability
│       │   │   └── EntryAbility.ets
│       │   ├── pages/         # 页面文件
│       │   │   ├── Index.ets           # 主页（算法列表）
│       │   │   ├── BubbleSort.ets      # 冒泡排序
│       │   │   ├── BinarySearch.ets    # 二分查找
│       │   │   ├── HanoiTower.ets      # 汉诺塔
│       │   │   ├── ... (其他算法页面)
│       │   │   └── ...
│       │   └── common/        # 公共工具
│       │       └── utils/     # 随机数生成等工具函数
│       ├── resources/         # 资源文件
│       │   └── base/
│       │       ├── element/   # 字符串、颜色
│       │       ├── media/     # 图片等
│       │       └── profile/
│       │           └── main_pages.json  # 页面路由注册表
│       └── module.json5       # 模块配置
├── hvigor/                    # 构建工具配置
├── build-profile.json5        # 构建参数
├── hvigorfile.ts              # 构建脚本
├── oh-package.json5           # 依赖管理
├── screenshots/               # 效果截图
└── README.md / README_EN.md   # 项目说明

## 三、核心文件解析

### 3.1 应用入口：EntryAbility.ets
- **路径**：`entry/src/main/ets/entryability/EntryAbility.ets`
- **功能**：继承 `UIAbility`，管理应用的生命周期（创建、前台、后台、销毁）。
- **关键代码**：
  ```typescript
  export default class EntryAbility extends UIAbility {
    onCreate(want, launchParam) {
      hilog.info(0x0000, 'testTag', 'Ability onCreate');
    }
    onWindowStageCreate(windowStage: window.WindowStage) {
      windowStage.loadContent('pages/Index', (err, data) => {
        // ...
      });
    }
  }
  · 分析：应用启动时加载 pages/Index 作为首页，使用的是 Stage 模型标准写法。

### 3.2 主页：Index.ets

· 路径：entry/src/main/ets/pages/Index.ets
· 功能：展示算法列表，点击每一项通过 router.pushUrl 跳转到对应算法页面。
· UI 结构：
· 使用 List + ListItem 渲染列表。
· 每个 ListItem 里是一个 Text，绑定了点击事件。
· 核心代码片段：
  ```typescript
  ListItem() {
    Text('冒泡排序')
      .fontSize(20)
      .textAlign(TextAlign.Center)
      .width('100%')
      .padding(16)
      .onClick(() => {
        router.pushUrl({ url: 'pages/BubbleSort' })
      })
  }
  ```
· 分析：界面简洁，没有使用 @State 动态数据，所有算法入口都是静态配置的。

3.3 冒泡排序页面：BubbleSort.ets

· 路径：entry/src/main/ets/pages/BubbleSort.ets
· 功能：
· 生成随机数组。
· 执行冒泡排序算法。
· 展示原始数组和排序后的数组。
· 关键数据：@State array: number[]，用于驱动 UI 更新。
· UI 布局：
· 标题文本。
· 原始数组展示区域。
· 排序后数组展示区域。
· “生成随机数组”和“开始排序”两个按钮。
· 核心逻辑：
  ```typescript
  // 冒泡排序算法
  for (let i = 0; i < len - 1; i++) {
    for (let j = 0; j < len - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        // 交换
        let temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
  this.array = arr; // 更新状态，触发 UI 刷新
  
· 分析：算法逻辑与 UI 分离，排序完成后一次性更新数组，UI 自动刷新。

3.4 其他算法页面（简要说明）

页面文件 算法功能 实现特点
BinarySearch.ets 二分查找 生成有序数组，输入目标值，查找并返回索引
HanoiTower.ets 汉诺塔问题 递归实现，输出移动步骤
QuickSort.ets 快速排序 递归分治，展示排序结果

3.5 公共工具模块

· 路径：entry/src/main/ets/common/utils/
· 功能：提供 RandomUtils.randomInt(min, max) 等工具函数，用于生成测试数据。
· 分析：代码复用性良好，避免每个算法页面重复写随机数逻辑。

3.6 页面路由配置：main_pages.json
· 路径：entry/src/main/resources/base/profile/main_pages.json
· 内容：列出所有需要注册的页面路径。
  {
    "src": [
      "pages/Index",
      "pages/BubbleSort",
      "pages/BinarySearch",
      ...
    ]
  }
  
· 分析：这是 Stage 模型的页面注册机制，只有在这里注册的页面才能被 router.pushUrl 跳转。

3.7 配置文件

· app.json5：应用包名 com.example.arktsalgorithm，版本信息，图标设置。
· module.json5：模块配置，注册 Ability，声明权限等。
· build-profile.json5：编译 SDK 版本、产品类型等。

四、架构与设计模式

· 整体架构：基于页面的简单 MVC 模式。
· View + Controller：每个 .ets 页面文件同时负责 UI 和交互逻辑。
· Model：算法逻辑直接嵌入页面，没有独立抽离（适合小型演示项目）。
· 状态管理：使用 @State 装饰器管理组件内部状态，状态变化自动触发 UI 更新。
· 路由管理：基于 @ohos.router 实现页面跳转，配置在 main_pages.json。

五、资源与配置说明

· 图标和名称：在 AppScope/app.json5 中配置应用图标和名称。
· 字符串资源：部分页面使用了 $r('app.string.xxx') 引用资源，便于国际化。
· 多媒体文件：screenshots/ 目录存放了应用运行截图，但未在代码中直接使用，仅作为文档展示。

六、改进与扩展建议

1. 代码解耦：将算法逻辑从页面中抽离到独立的 model 或 utils 目录，提高复用性和可测试性。
2. 增加可视化动画：如排序过程的分步演示，提升教学效果（已在任务三中部分实现）。
3. 数据持久化：可以加入 Preferences 存储用户的算法参数设置。
4. 响应式布局：当前页面主要适配手机竖屏，可增加横屏或平板适配。

七、总结

本项目作为一个 HarmonyOS 官方的 Codelab 示例，结构清晰、代码规范，非常适合新手学习 ArkTS 的声明式 UI、页面路由、状态管理等基础知识。通过解析这个项目，我深入理解了 Stage 模型的目录组织和页面开发流程，为后续的功能扩展打下了扎实的基础。