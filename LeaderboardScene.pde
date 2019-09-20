class LeaderboardScene extends Scene {
  
  String name = "";
  int nameLength = 10;
  boolean doInput = false;
  Button saveButton;
  Button menuButton;
  
  LeaderboardScene() {
    saveButton = new Button(width/2-100, height/2+150, 200, 30, this, "SAVE", "save");
    entities.add(saveButton);
    menuButton = new Button(width/2-100, height/2+150, 200, 30, this, "MENU", "menu");
    entities.add(menuButton);
  }
  
  void callback(GameObject o, String arg) {
    if (o.getClass() == Button.class)
      if (arg == "menu") {
        setScene("menu");
      }
      if (arg == "save") {
        saveName();
      }
  }
  
  void saveName() {
    doInput = false;
    r.putToLeaderboard(name, r.progress.get("score"));
    
    menuButton.setActive(!doInput);
    saveButton.setActive(doInput);
  }
  
  void input() {
    IntList tmp = c.getTyped();
    for (int i=0; i<tmp.size(); i++) {
      if (name.length() < nameLength)
        name += char(tmp.get(i));
    }
    
    if (name.length() > 0 && c.isPressed(BACKSPACE)) name = name.substring(0, name.length()-1);
    if (c.isPressed(ENTER) || c.isPressed(RETURN)) saveName();
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
      
    if (doInput) {
      fill(255);
      textAlign(LEFT, CENTER);
      String tmp = ""; for (int i=0; i<nameLength-name.length(); i++) tmp += "_";
      text(name+tmp, width/2-100, height/2);
      textAlign(RIGHT, CENTER);
      text(r.progress.get("score"), width/2+100, height/2);
    }
    else {
      // print leaderboard
      String[] leaderboardNames = r.leaderboard.keyArray();
      for (int i=0; i<leaderboardNames.length; i++) {
        if (leaderboardNames[i].equals(name)) fill(255, 255, 0);
        else fill(255);
        textAlign(LEFT, CENTER);
        text(leaderboardNames[i],  width/2-100, height/2-100+i*20);
        textAlign(RIGHT, CENTER);
        text(r.leaderboard.get(leaderboardNames[i]), width/2+100, height/2-100+i*20);
      }
    }
  }
  
  void onEnter(String oldScene) {
    doInput = r.progress.containsKey("score");
    if (doInput) doInput = doInput && (r.leaderboard.size() < 10 || r.progress.get("score") > r.leaderboard.minValue());
    
    if (doInput) name = "";
    menuButton.setActive(!doInput);
    saveButton.setActive(doInput);
  }
  
  void onExit() {
    r.saveLeaderboard();
    r.resetProgress();
    name = "";
  }
}
