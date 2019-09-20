class UIObject extends GameObject{
  String text;
  String onPressArg;
  UIState state;
  boolean isVisible = true;
  
  UIObject(float x, float y, float w, float h, Scene scene, String text, String onPressArg) {
    super(x, y, w, h, scene);
    this.text = text;
    this.onPressArg = onPressArg;
  }
  
  void check() {
    if (state != UIState.DISABLED) {
    state = UIState.IDLE;
    if (mouseX > pos.x && mouseX < pos.x+size.x &&
        mouseY > pos.y && mouseY < pos.y+size.y) {
        if (mousePressed && !mouseWasPressed)
          state = UIState.PRESS;
        else
          state = UIState.HOVER;
    
        }
    }
  }
  
  void update(float dt) {
    if (state == UIState.PRESS)
      scene.callback(this, onPressArg);
    
    check();
  }
  
  UIObject setEnabled(boolean value) {
    state = value ? UIState.IDLE : UIState.DISABLED;
    return this;
  }
  
  void getColor() {
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
  }
  
  void display() {
    getColor();
    rect(pos.x, pos.y, size.x, size.y);
    if (state == UIState.DISABLED) fill(100); else fill(255);
    textAlign(CENTER, CENTER);
    text(text, pos.x, pos.y, size.x, size.y);
  }
}

enum UIState {
  IDLE,
  PRESS,
  HOVER,
  DISABLED
}
