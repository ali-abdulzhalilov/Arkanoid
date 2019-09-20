class GameScene extends Scene {
  
  Paddle paddle;
  ArrayList<Ball> balls;
  ArrayList<Ball> activeBalls;
  ArrayList<Brick> bricks;
  ArrayList<Pickup> pickups;
  GameState state;
  float currentStateTimer;
  float scoreMultiplier;
  float pickupScoreMultiplier;
  
  private float refreshTimer = 0f;
  private float refreshRate = 0.5f;
  
  private float shake_amount = 0.1f;
  private float shake_current = 0;
  
  GameScene() {
    paddle = new Paddle(width/2-50, height-50, this);
    entities.add(paddle);
    balls = new ArrayList<Ball>();
    activeBalls = new ArrayList<Ball>();
    for (int i=0; i<10; i++) {
      Ball b = new Ball(this);
      balls.add(b);
      entities.add(b);
    }
    disableAllBalls();
    //ball = new Ball(this);
    //entities.add(ball);
    
    bricks = new ArrayList<Brick>();
    for (int i=0; i<50; i++) {
      Brick b = new Brick(this);
      bricks.add(b);
      entities.add(b);
    }
    
    pickups = new ArrayList<Pickup>();
    pickups.add(new SlowDownPickup(this));
    pickups.add(new SpeedUpPickup(this));
    pickups.add(new LifePickup(this));
    pickups.add(new MultipleBallsPickup(this));
    pickups.add(new BallSizeUpPickup(this));
    pickups.add(new BallSizeDownPickup(this));
    pickups.add(new PaddleSizeUpPickup(this));
    pickups.add(new PaddleSizeDownPickup(this));
    
    for (Pickup p: pickups)
      entities.add(p);
  }
  
  void input() {
    int dx = 0;
    
    if (c.isHeld('a') || c.isCodedHeld(LEFT)) dx += -1;
    if (c.isHeld('d') || c.isCodedHeld(RIGHT)) dx += 1;
    
    paddle.move(dx);
    
    if (c.isPressed('p') || c.isPressed(' ')) setScene("pause");
    if (c.isPressed(ESC)) setScene("menu");
    if (c.isHeld('s')) timeScale = 1.5;
  }
  
  void update(float dt) {
    currentStateTimer += dt;
    shake_current *= 0.1f;
    
    refreshTimer += dt; 
    if (refreshTimer >= refreshRate) {
      refreshTimer = 0f;
      stateResolve(dt);
    }
    
    for (GameObject one : entities) 
      if (one.isActive)
        for (GameObject another : entities)
           if (one != another && another.isActive)
             if (one.doCollide(another))
               one.resolve(another);
  }
  
  void display() {
    translate(width/2, height/2);
    
    int dw = width/10; int dh = height/10;
    translate((dw*noise(millis()/50f)-dw/2)*shake_current*scoreMultiplier,
              (dh*noise(100+millis()/50f)-dh/2)*shake_current*scoreMultiplier);
    rotate((HALF_PI/8*noise(millis()/100f)-HALF_PI/16)*shake_current);
    
    translate(-width/2, -height/2);
    
    float d = 0;
    if (state == GameState.LOSE && r.progress.get("lifes") <= 1 || state == GameState.WIN) d = 50*currentStateTimer;
    if (state == GameState.PRE) d = 50*(1-currentStateTimer);
    
    background(d+shake_current*100);
    stroke(0);
    fill(255);
    textSize(20);
    textAlign(RIGHT, TOP);
    text(pickupScoreMultiplier+" "+scoreMultiplier+" "+r.progress.get("score"), width, 0);
    if (r.progress.containsKey("lifes"))
      for (int i=0; i<r.progress.get("lifes"); i++)
        rect(i*20, 0, 20, 20);
        
    if (state == GameState.PRE) {
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(50);
      text(r.orderedLevels.get(r.progress.get("level")).toUpperCase(), width/2, height/2);
    }
  }
  
  void onEnter(String oldScene) {
    //if (oldScene == "menu")
      //reset();
  }
  
  // some gameplay util functions
  
  void callback(GameObject o, String arg) {
    if (o.getClass() == Ball.class)
      if (arg == "fail") {
        scoreMultiplier = 1f;
        disableBall((Ball)o);
        if (state == GameState.GAME && activeBalls.size() == 0) {
          if (r.progress.get("lifes") <= 1) timeScale = 0.5f;
          setState(GameState.LOSE);
        }
      }
      if (arg == "hit") {
        r.progress.put("score", r.progress.get("score") + int(20*(scoreMultiplier+pickupScoreMultiplier)));
        scoreMultiplier += 0.1f;
        a.playSound("hit", scoreMultiplier);
        shake_current = shake_amount;
        pickups.get(int(random(pickups.size()))).deploy(o.pos.x-50, o.pos.y-15);
      }
      if (arg == "wall") {
        a.playSound("bump");
        if (shake_current < shake_amount/2) shake_current = shake_amount/2;
        //scoreMultiplayer = 1f;
      }
      if (arg == "paddle") {
        a.playSound("bump");
        if (shake_current < shake_amount/2) shake_current = shake_amount/2;
      }
  }
  
  void setState(GameState newState) {
    println(state + " changed to "+newState+" at "+currentStateTimer);
    state = newState;
    currentStateTimer = 0f;
  }
  
  void stateResolve(float dt) {
    switch (state) {
      case PRE:
        if (currentStateTimer >= 1f) {
          setState(GameState.GAME);
        }
        if (currentStateTimer/timeScale >= 1f)
          timeScale = (1-timeScale)*dt+1;
      case GAME:
        if (isAllBricksDown()) {
          r.saveLeaderboard();
          timeScale = 0.5f;
          setState(GameState.WIN);
        }
        break;
      case LOSE:
        if (currentStateTimer >= 1f) {
          //if (activeBalls.size() == 1)
          r.progress.put("lifes", r.progress.get("lifes") - 1);
          a.clear();
          if (r.progress.get("lifes") <= 0) {
            r.saveLeaderboard();
           
            setScene("board");
          }
          else {
            //resetBalls();
            addActiveBall();
            scoreMultiplier = 1f;
          }
          setState(GameState.GAME);
        }
        break;
      case WIN:
        if (currentStateTimer >= 1f) {
            r.progress.put("level", r.getNextLevelIndex(r.progress.get("level")));
            if (r.progress.get("level") == -1) {
              r.saveLeaderboard();
              
              setScene("board");
            }
            else {
              r.saveProgress();
              initLevel(r.progress.get("level"));
              setScene("game");
            }
        }
        break;
      default:
        println("????");
        break;
    }
  }
  
  // level stuff
  void loadBricks(int levelIndex) {
    Level l = r.getLevel(levelIndex);
    int ww = width/l.w;
    int hh = (height/2)/l.h;
    int counter = 0;
    
    for (int i=0; i<l.level.size(); i++) {
      String row = l.level.get(i);
      for (int j=0; j<row.length(); j++)
        if (row.charAt(j) == '#') {
          if (counter < bricks.size()-1) {
            Brick b = bricks.get(counter);
            b.set(j*ww, i*hh, ww, hh, color(255));
            counter++;
          }
        }
    }
    
    for (int i=counter; i<bricks.size(); i++) {
      bricks.get(i).isActive = false;
      counter++;
    }
  }
  
  void initLevel(int levelIndex) {
    currentStateTimer = 0f;
    scoreMultiplier = 1;
    pickupScoreMultiplier = 1;
    timeScale = 0.5;
    
    state = GameState.PRE;
    r.progress.put("level", levelIndex);
    disableAllBalls();
    addBalls(1);
    //ball.reset();
    paddle.reset();
    
    if (!r.progress.containsKey("lifes") || r.progress.get("lifes") <= 0) r.progress.put("lifes", MAX_LIFES);
    if (!r.progress.containsKey("score")) r.progress.put("score", 0);
    
    loadBricks(levelIndex);
    for (Pickup p: pickups)
      p.reset();
  }
  
  // some brick pool functions
  boolean isAllBricksDown() {
    boolean result = true;
    
    for (Brick brick : bricks) {
      if (brick.isActive)
        result = false;
    }
    
    return result;
  }
  
  // some ball functions
  boolean isAllBallsDown() {
    boolean result = true;
    
    for (Ball ball: balls)
      if (ball.isActive) {
        result = false;
        break;
      }
    
    return result;
  }
  
  void disableBall(Ball ball) {
    ball.setActive(false);
    
    if (activeBalls.contains(ball))
      activeBalls.remove(ball);
  }
  
  void disableAllBalls() {
    for (Ball ball: balls)
      disableBall(ball);
  }
  
  void addActiveBall() {
    Ball ball = getDeadBall();
    
    if (ball != null) {
      activeBalls.add(ball);
      ball.setActive(true);
      ball.reset();
    }
  }
  
  void addBalls(int amount) {
    for (int i=0; i<amount; i++)
      addActiveBall();
  }
  
  Ball getDeadBall() {
    for (Ball ball: balls)
      if (!activeBalls.contains(ball))
        return ball;
    
    return null;
  }
  
  void resetBalls() {
    for (Ball ball: activeBalls)
      ball.reset();
  }
}

enum GameState {
  PRE,
  GAME,
  WIN,
  LOSE
}
