class Paddle extends GameObject {
  
  int dx = 0;
  int speed = 750;

  Paddle(float x, float y, Scene scene) {
    super(x, y, 150, 20, scene);
  }
  
  void move(int dx) {
    this.dx = dx;
  }
  
  void update(float dt) {
    pos.x += dx * speed * dt;
    
    if (pos.x < 0) pos.x = 0;
    if (pos.x + size.x > width) pos.x = width - size.x;
    
    dx = 0;
  }
  
  void display() {
    fill(255);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
