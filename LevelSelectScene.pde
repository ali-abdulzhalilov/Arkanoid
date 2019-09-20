class LevelSelectScene extends Scene {
  
  LevelSelectScene() {    
    entities.add(new Button(width/2-100, height/2+150, 200, 30, this, "BACK", "back"));
    
    
    StringList tmp = new StringList();
    for (String key: r.levels.keySet())
      tmp.append(key);
    tmp.sort();
    
    for (int i=0; i<r.orderedLevels.size(); i++) {
      entities.add(new Button(width/2-100, height/2-100+i*30, 200, 30, this, r.orderedLevels.get(i).toUpperCase(), "level "+str(i))); 
    }
    
  }
  
  void callback(GameObject o, String arg) {
    if (o.getClass() == Button.class)
      if (splitTokens(arg, " ").length > 1) {
        r.resetProgress();
        game.initLevel(int(splitTokens(arg, " ")[1]));
        setScene("game");
      }
      else
      if (arg == "back")
        setScene("menu");
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
