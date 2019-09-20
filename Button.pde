class Button extends UIObject {
  
  Button(float x, float y, float w, float h, Scene scene, String text, String onPressArg) {
    super(x, y, w, h, scene, text, onPressArg);
    this.text = text;
    this.onPressArg = onPressArg;
  }
  
  void check() {
    if (state == UIState.PRESS)
      state = UIState.HOVER;
    else
      super.check();
  }
  
  void update(float dt) {
    if (state == UIState.PRESS)
      scene.callback(this, onPressArg);
    
    check();
  }
  
  void display() {
    switch (state) {
      case IDLE:
        stroke(150);
        fill(100);
        break;
      case PRESS:
        stroke(255);
        fill(200);
        break;
      case HOVER:
        stroke(200);
        fill(150);
        break;
      case DISABLED:
        fill(50);
        stroke(100);
    }
    rect(pos.x, pos.y, size.x, size.y);
    if (state == UIState.DISABLED) fill(100); else fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(text, pos.x, pos.y, size.x, size.y);
  }
}
