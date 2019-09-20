class OptionsScene extends Scene {
  
  PImage back;
  String fromScene;
  Slider soundVolumeSlider;
  Button resetButton;
  
  OptionsScene() {
    soundVolumeSlider = (Slider)new Slider(width/2-50, height/2-15, 200, 30, this, "SOUND", "sound").setEnabled(a.s != null);
    entities.add(soundVolumeSlider);
    resetButton = new Button(width/2-150, height/2+15, 300, 30, this, "RESET LEADERBOARD", "reset");
    entities.add(resetButton);
    entities.add(new Button(width/2-150, height/2+45, 300, 30, this, "BACK", "back"));
    
    if (r.options.containsKey("soundVolume"))
      soundVolumeSlider.value = r.options.get("soundVolume")/100.0;
  }
  
  void callback(GameObject o, String arg, float value) {
    if (o.getClass() == Button.class)
      if (arg == "back")
        setScene(fromScene);
      if (arg == "reset") {
        r.leaderboard.clear();
        r.saveLeaderboard();
      }
    
    if (o.getClass() == Slider.class)
      if (arg == "sound") {
        a.setVolume(value);
        r.options.put("soundVolume", int(value*100));
      }
  }
  
  void display() {
    if (fromScene == "menu") {
      noStroke();
      int N = 32, M = 16;
      for (int i=0; i<M; i++)
      for (int j=0; j<N; j++) {
        fill(cos(millis()/1000.0+PI/M*(4*i+j))*50+50);
        rect(i*(width/M), j*(height/N), width/M, height/N);
      }
    } else if (back != null)
      background(back);
      
    stroke(200);
    fill(100);
    rect(width/2-200, height/2-100, 400, 200);
  }
  
  void onEnter(String oldScene) {
    fromScene = oldScene;
    if (oldScene != "menu") {
      back = get();
    }
    resetButton.setActive(oldScene.equals("menu"));
    resetButton.setEnabled(r.leaderboard.size()>0);
  }
  
  void onExit() {
    r.saveOptions();
  }
}
