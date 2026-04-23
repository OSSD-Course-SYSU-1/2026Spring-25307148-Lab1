// GamePage.ets - 贪吃蛇游戏 (解决枚举冲突)

const GRID_SIZE = 20;
const CELL_SIZE = 30;

// 将枚举名改为 SnakeDirection，避免与 Index.ets 或其他文件中的 Direction 冲突
enum SnakeDirection { UP, DOWN, LEFT, RIGHT }

@Entry
@Component
struct GamePage {
  @State snake: Array<Array<number>> = [[10, 10], [10, 9], [10, 8]];
  @State food: Array<number> = [8, 8];
  @State currentDir: SnakeDirection = SnakeDirection.RIGHT;
  @State nextDir: SnakeDirection = SnakeDirection.RIGHT;
  @State score: number = 0;
  @State gameOver: boolean = false;
  @State isPlaying: boolean = false;
  private gameInterval: number = -1;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);

  aboutToDisappear(): void {
    clearInterval(this.gameInterval);
  }

  startGame(): void {
    if (this.gameOver) {
      this.snake = [[10, 10], [10, 9], [10, 8]];
      this.currentDir = SnakeDirection.RIGHT;
      this.nextDir = SnakeDirection.RIGHT;
      this.score = 0;
      this.gameOver = false;
    }
    this.isPlaying = true;
    this.generateFood();
    clearInterval(this.gameInterval);
    this.gameInterval = setInterval(() => this.moveSnake(), 200);
  }

  generateFood(): void {
    const freeCells: Array<Array<number>> = [];
    for (let i = 0; i < GRID_SIZE; i++) {
      for (let j = 0; j < GRID_SIZE; j++) {
        if (!this.snake.some(seg => seg[0] === i && seg[1] === j)) {
          freeCells.push([i, j]);
        }
      }
    }
    if (freeCells.length > 0) {
      this.food = freeCells[Math.floor(Math.random() * freeCells.length)];
    } else {
      this.gameOver = true;
      this.isPlaying = false;
      clearInterval(this.gameInterval);
    }
  }

  changeDirection(newDir: SnakeDirection): void {
    if (!this.isPlaying || this.gameOver) return;
    if ((this.currentDir === SnakeDirection.UP && newDir !== SnakeDirection.DOWN) ||
      (this.currentDir === SnakeDirection.DOWN && newDir !== SnakeDirection.UP) ||
      (this.currentDir === SnakeDirection.LEFT && newDir !== SnakeDirection.RIGHT) ||
      (this.currentDir === SnakeDirection.RIGHT && newDir !== SnakeDirection.LEFT)) {
      this.nextDir = newDir;
    }
  }

  moveSnake(): void {
    if (!this.isPlaying || this.gameOver) return;
    this.currentDir = this.nextDir;
    const head = this.snake[0];
    let newHead: Array<number> = [...head];
    switch (this.currentDir) {
      case SnakeDirection.UP:    newHead[0]--; break;
      case SnakeDirection.DOWN:  newHead[0]++; break;
      case SnakeDirection.LEFT:  newHead[1]--; break;
      case SnakeDirection.RIGHT: newHead[1]++; break;
    }
    if (newHead[0] < 0 || newHead[0] >= GRID_SIZE || newHead[1] < 0 || newHead[1] >= GRID_SIZE ||
    this.snake.some(seg => seg[0] === newHead[0] && seg[1] === newHead[1])) {
      this.gameOver = true;
      this.isPlaying = false;
      clearInterval(this.gameInterval);
      return;
    }
    this.snake.unshift(newHead);
    if (newHead[0] === this.food[0] && newHead[1] === this.food[1]) {
      this.score += 10;
      this.generateFood();
    } else {
      this.snake.pop();
    }
    this.drawCanvas();
  }

  drawCanvas(): void {
    const ctx = this.canvasContext;
    ctx.clearRect(0, 0, GRID_SIZE * CELL_SIZE, GRID_SIZE * CELL_SIZE);
    ctx.fillStyle = '#E8F5E9';
    ctx.fillRect(0, 0, GRID_SIZE * CELL_SIZE, GRID_SIZE * CELL_SIZE);
    this.snake.forEach((seg, idx) => {
      ctx.fillStyle = idx === 0 ? '#2E7D32' : '#4CAF50';
      ctx.fillRect(seg[1] * CELL_SIZE, seg[0] * CELL_SIZE, CELL_SIZE - 1, CELL_SIZE - 1);
    });
    ctx.fillStyle = '#F44336';
    ctx.beginPath();
    ctx.arc(this.food[1] * CELL_SIZE + CELL_SIZE / 2,
      this.food[0] * CELL_SIZE + CELL_SIZE / 2,
      CELL_SIZE / 2 - 2, 0, 2 * Math.PI);
    ctx.fill();
  }

  build() {
    Column() {
      Row() {
        Text(`分数: ${this.score}`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20 })
        Blank()
        Button(this.isPlaying ? '暂停' : '开始')
          .fontSize(20)
          .onClick(() => {
            if (this.gameOver) this.startGame();
            else this.isPlaying = !this.isPlaying;
          })
        Button('重置')
          .fontSize(20)
          .margin({ left: 10, right: 20 })
          .onClick(() => {
            this.gameOver = true;
            this.isPlaying = false;
            this.startGame();
          })
      }
      .width('100%')
      .height(60)
      .margin({ top: 20 })

      Canvas(this.canvasContext)
        .width(GRID_SIZE * CELL_SIZE)
        .height(GRID_SIZE * CELL_SIZE)
        .backgroundColor('#FFFFFF')
        .border({ width: 2, color: '#CCCCCC' })
        .gesture(
          PanGesture({ direction: PanDirection.All })
            .onActionEnd((event: GestureEvent) => {
              const offsetX = event.offsetX;
              const offsetY = event.offsetY;
              if (Math.abs(offsetX) > Math.abs(offsetY)) {
                this.changeDirection(offsetX > 0 ? SnakeDirection.RIGHT : SnakeDirection.LEFT);
              } else {
                this.changeDirection(offsetY > 0 ? SnakeDirection.DOWN : SnakeDirection.UP);
              }
            })
        )
        .onReady(() => {
          this.startGame();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}