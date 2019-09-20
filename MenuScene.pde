class MenuScene extends Scene {
  
  Button continueButton;
  
  MenuScene() {
    entities.add(new Button(width/2-100, height/2-45, 200, 30, this, "NEW GAME", "play"));
    continueButton = new Button(width/2-100, height/2-15, 200, 30, this, "CONTINUE", "continue");
    entities.add(continueButton);
    entities.add(new Button(width/2-100, height/2+15, 200, 30, this, "LEVEL SELECT", "level"));
    entities.add(new Button(width/2-100, height/2+45, 200, 30, this, "LEADERBOARD", "board"));
    entities.add(new Button(width/2-100, height/2+75, 200, 30, this, "OPTIONS", "options"));
    entities.add(new Button(width/2-100, height/2+105, 200, 30, this, "EXIT", "exit"));
  }
  
  void callback(GameObject o, String arg) {
    if (o.getClass() == Button.class)
      if (arg == "play") {
        r.resetProgress();
        game.initLevel(0); //<>// //<>//
        setScene("game");
      }
      if (arg == "continue") {
        game.initLevel(r.progress.get("level"));
        setScene("game");
      }
      if (arg == "level")
        setScene("level");
      if (arg == "board")
        setScene("board");
      if (arg == "options")
        setScene("options");
      if (arg == "exit")
        exit();
  }
  
  void onEnter(String oldScene) {
    
    continueButton.setEnabled(r.progress.size()>0 && r.progress.get("lifes") > 0);
  }
  
  void display() {
    background(0);
    noStroke();
    
    int N = 32, M = 16;
    for (int i=0; i<M; i++)
      for (int j=0; j<N; j++) {
        fill(cos(millis()/1000.0+PI/M*(4*i+j))*50+50);
        rect(i*(width/M), j*(height/N), width/M, height/N);
      }
  }
}
