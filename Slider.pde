class Slider extends UIObject {
  
  int labelSize = 100;
  float value = 1f;
  
  Slider(float x, float y, float w, float h, Scene scene, String text, String onPressArg) {
    super(x, y, w, h, scene, text, onPressArg);
    this.text = text;
    this.onPressArg = onPressArg;
    if (a.s != null)
      a.setVolume(value);
  }
  
  void check() {
    if (state != UIState.DISABLED) {
    state = UIState.IDLE;
    if (mouseX > pos.x && mouseX < pos.x+size.x &&
        mouseY > pos.y && mouseY < pos.y+size.y) {
        if (mousePressed)
          state = UIState.PRESS;
        else
          state = UIState.HOVER;
    
        }
    }
  }
  
  void update(float dt) {
    if (state == UIState.PRESS) {
      value = (mouseX-pos.x)/size.x;
      value = (value < 0f) ? 0f : (value > 1f) ? 1f : value;
      scene.callback(this, onPressArg, value);
    }
    
    check();
  }
  
  void display() {
    fill(state == UIState.DISABLED ? 50 : 255);
    noStroke();
    rect(pos.x, pos.y+size.y/2-2, size.x, 4);
    
    getColor();
    rect(pos.x+value*size.x-5, pos.y, 10, size.y);
    
    fill(255);
    textAlign(LEFT, CENTER);
    text(text, pos.x-labelSize, pos.y, pos.x, size.y);
  }
}
