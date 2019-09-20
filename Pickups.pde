abstract class Pickup extends GameObject {
  
  float gravity = 100f;
  String text = "";
  float scoreInc = 0f;
  float oneTimescoreInc = 0f;
  color c = color(255);
  float probability = 0.25f;

  Pickup(Scene scene) {
    super(0, 0, 100, 20, scene);
    isActive = false;
    r_isActive = false;
  }
  
  void update(float dt) {
    pos.y += gravity * dt;
    
    if (pos.y >= height) reset();
  }
  
  void display() {
    noStroke();
    fill(c);
    ellipse(pos.x+size.y/2, pos.y+size.y/2, size.y, size.y);
    ellipse(pos.x+size.x-size.y/2, pos.y+size.y/2, size.y, size.y);
    rect(pos.x+size.y/2, pos.y, size.x-size.y, size.y);
    
    fill((red(c)+blue(c)+green(c))/3 > 50 ? 0 : 255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(text, pos.x+size.x/2, pos.y+size.y/2);
  }
  
  void deploy(float x, float y) {
    if (!isActive && random(1.0)<probability) {
      pos.x = x;
      pos.y = y;
      isActive = true;
    }
  }

  void resolve(GameObject other) {
    if (other.getClass() == Paddle.class) {
      GameScene g = (GameScene)scene;
      g.pickupScoreMultiplier += scoreInc;
      g.scoreMultiplier += oneTimescoreInc;
      
      scene.callback(this, "blip");
      applyEffect();
      reset();
    }
  }
  
  abstract void applyEffect();
}

class SlowDownPickup extends Pickup {

  SlowDownPickup(Scene scene) {
    super(scene);
    text = "speed-";
    scoreInc = -0.2;
    c = color(0, 120, 0);
  }
  
  void applyEffect() {
    timeScale -= 0.2;
  }
}

class SpeedUpPickup extends Pickup {

  SpeedUpPickup(Scene scene) {
    super(scene);
    text = "speed+";
    scoreInc = 0.2;
    c = color(120, 0, 0);
  }
  
  void applyEffect() {
    timeScale += 0.2;
  }
}

class LifePickup extends Pickup {

  LifePickup(Scene scene) {
    super(scene);
    text = "life +1";
    oneTimescoreInc = -1;
    c = color(120, 255, 0);
    probability = 0.05f;
  }
  
  void applyEffect() {
    r.progress.put("lifes", r.progress.get("lifes")+1);
  }
}

class MultipleBallsPickup extends Pickup {

  MultipleBallsPickup(Scene scene) {
    super(scene);
    text = "balls++";
    oneTimescoreInc = -1;
    c = color(120, 0, 120);
    probability = 0.05f;
  }
  
  void applyEffect() {
    GameScene g = (GameScene)scene;
    g.addBalls(2);
  }
}

class BallSizeUpPickup extends Pickup {

  BallSizeUpPickup(Scene scene) {
    super(scene);
    text = "ball size+";
    oneTimescoreInc = -0.2;
    c = color(0, 120, 0);
  }
  
  void applyEffect() {
    GameScene g = (GameScene)scene;
    for (Ball b: g.activeBalls)
      b.size.mult(1.2);
  }
}

class BallSizeDownPickup extends Pickup {

  BallSizeDownPickup(Scene scene) {
    super(scene);
    text = "ball size-";
    oneTimescoreInc = 0.2;
    c = color(120, 0, 0);
  }
  
  void applyEffect() {
    GameScene g = (GameScene)scene;
    for (Ball b: g.activeBalls)
      b.size.mult(0.8);
  }
}

class PaddleSizeUpPickup extends Pickup {

  PaddleSizeUpPickup(Scene scene) {
    super(scene);
    text = "paddle size+";
    scoreInc = -0.2;
    c = color(0, 120, 0);
  }
  
  void applyEffect() {
    GameScene g = (GameScene)scene;
    g.paddle.size.x *= 1.2;
  }
}

class PaddleSizeDownPickup extends Pickup {

  PaddleSizeDownPickup(Scene scene) {
    super(scene);
    text = "paddle size-";
    scoreInc = 0.2;
    c = color(120, 0, 0);
  }
  
  void applyEffect() {
    GameScene g = (GameScene)scene;
    g.paddle.size.x *= 0.8;
  }
}
