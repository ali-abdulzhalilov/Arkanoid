class GameObject {
  
  boolean isActive;
  protected boolean r_isActive = true;
  PVector pos;
  private PVector r_pos;
  PVector size;
  private PVector r_size;
  private Scene scene;
  
  GameObject(float x, float y, float w, float h, Scene scene) {
    this.isActive = true;
    this.pos = new PVector(x, y);
    this.size = new PVector(w, h);
    
    this.r_isActive = isActive;
    this.r_pos = new PVector(x, y);
    this.r_size = new PVector(w, h);
    this.scene = scene;
  }
  
  GameObject setActive(boolean value) {
    isActive = value;
    return this;
  }
  
  void reset() {
    isActive = r_isActive;
    pos.x = r_pos.x;
    pos.y = r_pos.y;
    size.x = r_size.x;
    size.y = r_size.y;
  }
  
  boolean doCollide(GameObject other) {
    return this.pos.x < other.pos.x + other.size.x &&
           this.pos.x + this.size.x > other.pos.x  &&
           this.pos.y < other.pos.y + other.size.y &&
           this.pos.y + this.size.y > other.pos.y;
  }
  
  void resolve(GameObject other) {}

  void update(float dt){};
  void display(){};
}
