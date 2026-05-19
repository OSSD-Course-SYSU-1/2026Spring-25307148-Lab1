import router from '@ohos.router';

@Entry
@Component
struct BubbleSortVisual {
  @State array: number[] = [];
  @State compareIndex: number = -1;   // 当前正在比较的左侧元素索引
  @State sortedBoundary: number = -1; // 已排序部分的起始索引
  @State isRunning: boolean = false;
  @State stepMessage: string = '点击生成数组开始';
  private timer: number = 0;

  // 生成随机数组
  generateArray() {
    clearTimeout(this.timer);
    this.array = [];
    for (let i = 0; i < 8; i++) {
      this.array.push(Math.floor(Math.random() * 90) + 10); // 10~99
    }
    this.compareIndex = -1;
    this.sortedBoundary = -1;
    this.stepMessage = '数组已生成，点击【开始排序】';
  }

  // 执行一步排序，使用 async/await 制造动画效果
  async bubbleSortStepByStep() {
    if (this.array.length === 0 || this.isRunning) return;

    let arr = [...this.array];        // 拷贝数组，避免直接修改原状态
    let len = arr.length;
    this.isRunning = true;

    for (let i = 0; i < len - 1; i++) {
      for (let j = 0; j < len - 1 - i; j++) {
        // 高亮当前比较的两个元素
        this.compareIndex = j;
        this.sortedBoundary = len - i; // i轮之后，从 len-i 开始都是已排序区
        this.stepMessage = `比较索引 ${j} (${arr[j]}) 和 ${j + 1} (${arr[j + 1]})`;
        await this.delay(800);

        if (arr[j] > arr[j + 1]) {
          // 交换
          let temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;

          // 更新整个数组，触发 UI 重绘
          this.array = [...arr];
          this.stepMessage = `交换：${arr[j + 1]} ↔ ${arr[j]}`;
          await this.delay(600);
        }
      }
    }

    // 排序完成
    this.compareIndex = -1;
    this.sortedBoundary = 0; // 全部变成已排序
    this.isRunning = false;
    this.stepMessage = '排序完成！';
  }

  // 延时函数
  delay(ms: number): Promise<void> {
    return new Promise(resolve => {
      this.timer = setTimeout(resolve, ms);
    });
  }

  build() {
    Column() {
      // 标题
      Text('冒泡排序可视化')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      // 可视化区域：用柱状图表示数组
      Row() {
        ForEach(this.array, (value: number, index: number) => {
          Column() {
            Text(value.toString())
              .fontSize(12)
              .fontColor(Color.White)
              .margin({ bottom: 4 })
            // 柱子高度 = value * 2 增强视觉
            Blank()
              .height(value * 2)
              .width('18%')
              .backgroundColor(
                // 正在比较的两个元素 → 红色
                (index === this.compareIndex || index === this.compareIndex + 1) ? Color.Red :
                  // 已排序区域的元素 → 绿色
                  (this.sortedBoundary >= 0 && index >= this.sortedBoundary) ? Color.Green :
                    // 未排序元素 → 蓝色
                    Color.Blue
              )
              .borderRadius(4)
          }
          .width('11%')
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('100%')
      .height(250)
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ bottom: 20 })

      // 状态信息
      Text(this.stepMessage)
        .fontSize(16)
        .width('90%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 15 })

      // 按钮区
      Row() {
        Button('生成数组')
          .onClick(() => this.generateArray())
          .enabled(!this.isRunning)
          .width(120)
        Button('开始排序')
          .onClick(() => this.bubbleSortStepByStep())
          .enabled(!this.isRunning && this.array.length > 0)
          .width(120)
          .margin({ left: 20 })
      }
      .margin({ bottom: 20 })

      // 返回按钮
      Button('返回首页')
        .type(ButtonType.Normal)
        .width(120)
        .onClick(() => {
          clearTimeout(this.timer);
          router.back();
        })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}