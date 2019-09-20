class Brick extends GameObject {

  color c;
  
  Brick(Scene scene) {
    super(0, 0, 0, 0, scene);
    this.isActive = false;
    this.r_isActive = false;
  }
  
  void set(float x, float y, float w, float h, color c) {
    this.pos.x = x;
    this.pos.y = y;
    this.size.x = w;
    this.size.y = h;
    this.c = c;
    this.isActive = true;
  }

  void display() {
    fill(c);
    stroke(0);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
