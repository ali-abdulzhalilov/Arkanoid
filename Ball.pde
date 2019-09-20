class Ball extends GameObject {
  
  PVector dir;
  int speed = 750;
  boolean bump = false;
  
  Ball(Scene scene) {
    super(width/2-10, height-100, 20, 20, scene);
    setDir(random(2)-1, -1);
  }
  
  void reset() {
    super.reset();
    setDir(random(2)-1, -1);
  }
  
  void setDir(float x, float y) {
    if (dir == null) dir = new PVector(x, y);
    else dir.set(x, y);
    
    dir.normalize();
  }
  
  void update(float dt) {
    pos.x += dir.x * speed * dt;
    pos.y += dir.y * speed * dt;
    
    // wall collisions
    if (pos.x < 0) { bump = true; dir.x = abs(dir.x); } // left
    if (pos.x + size.x > width) { bump = true; dir.x = -abs(dir.x); } // right
    if (pos.y < 0) { bump = true; dir.y = abs(dir.y); } // top
    //if (pos.y + size.y > height) dir.y = -abs(dir.y); // bottom
    if (pos.y + size.y > height) {
      scene.callback(this, "fail");
    }
    
    if (bump) 
      scene.callback(this, "wall");
    bump = false;
  }
  
  void resolve(GameObject other) {
    if (!Pickup.class.isAssignableFrom(other.getClass())) {
      if (pos.x < other.pos.x) dir.x = -abs(dir.x); // left
      if (pos.x + size.x > other.pos.x + other.size.x) dir.x = abs(dir.x); // right
      if (pos.y < other.pos.y) dir.y = -abs(dir.y); // top
      if (pos.y + size.y > other.pos.y + other.size.y) dir.y = abs(dir.y); // bottom
    }
    
    if (other.getClass() == Paddle.class) {
      scene.callback(this, "paddle");
      if (pos.y < other.pos.y) {
        float percent = (pos.x+size.x/2 - other.pos.x)/other.size.x;
        float k = 1.5f;
        float d = k*(percent-0.5f);
        setDir(d, dir.y);
      } 
    }
    else if (other.getClass() == Brick.class) {
      scene.callback(this, "hit");
      other.isActive = false;
    }
  }

  void display() {
    fill(255);
    rect(pos.x, pos.y, size.x, size.y);
  }
}
