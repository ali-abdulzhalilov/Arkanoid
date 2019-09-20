class PauseScene extends Scene {
  
  PImage back;
  
  PauseScene() {
    entities.add(new Button(width/2-100, height/2-15, 200, 30, this, "RESUME", "resume"));
    entities.add(new Button(width/2-100, height/2+15, 200, 30, this, "OPTIONS", "options"));
    entities.add(new Button(width/2-100, height/2+45, 200, 30, this, "MENU", "menu"));
  }
  
  void callback(GameObject o, String arg) {
    if (o.getClass() == Button.class)
      if (arg == "resume")
        setScene("game");
      if (arg == "options")
        setScene("options");
      if (arg == "menu") {
        r.saveProgress();
        setScene("menu");
      }
  }
  
  void display() {
    if (back != null)
      background(back);
    fill(100);
    rect(width/2-150, height/2-100, 300, 200);
  }
  
  void onEnter(String oldScene) {
    if (oldScene == "game") {
      back = get();
    }
  }
}
