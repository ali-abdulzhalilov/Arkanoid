abstract class Scene {
  
  ArrayList<GameObject> entities;
  
  Scene() {
    entities = new ArrayList<GameObject>();
  }
  
  void loop(float dt) {
    input();
    
    update(dt);
    for (GameObject entity : entities) {
      if (entity.isActive)
        entity.update(dt);
    }
    
    a.update(dt);
      
    display();  
    for (GameObject entity : entities) {
      if (entity.isActive)
        entity.display();
    }
  }
  
  void input(){};
  void update(float dt){};
  void display(){};
  
  void onEnter(String oldScene){}
  void onExit(){}
  
  void reset(){
    for (GameObject entity: entities) {
      entity.reset();
    }
  }
  void callback(GameObject o, String arg) {
    callback(o, arg, 0);
  }
  void callback(GameObject o, String arg, float value) {}
}
