// Index.ets
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button('开始贪吃蛇游戏')
        .fontSize(24)
        .padding(20)
        .onClick(() => {
          // 按照官方最新规范获取路由实例并跳转 [11†L26-L28]
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/GamePage'
          });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}