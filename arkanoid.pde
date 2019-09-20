import processing.sound.*;

ResourceManager r;
AudioManager a;
Controls c;

Scene scene;
String sceneName;
GameScene game;
HashMap<String, Scene> scenes;
boolean keys[] = new boolean[255];
int oldTime;
float timeScale = 1f;
boolean mouseWasPressed;

int MAX_LIFES = 3;

void setup() {
  size(640, 640);
  textSize(20);
  
  r = new ResourceManager();
  a = new AudioManager(this);
  c = new Controls();
  
  scenes = new HashMap<String, Scene>();
  scenes.put("menu", new MenuScene());
  scenes.put("level", new LevelSelectScene());
  game = new GameScene();
  scenes.put("game", game);
  scenes.put("pause", new PauseScene());
  scenes.put("options", new OptionsScene());
  scenes.put("board", new LeaderboardScene());
  setScene("menu");
  
  oldTime = millis();
}

void draw() {
  float dt = (millis() - oldTime)/1000.0;
  
  scene.loop(dt * timeScale);
  
  oldTime = millis();
  mouseWasPressed = mousePressed;
  
  c.update();
}

void setScene(String newSceneName){
  if (scenes.get(newSceneName) != null) {
    String oldScene = null;
    if (scene != null) {
      scene.onExit();
      oldScene = sceneName;
    }
    scene = scenes.get(newSceneName);
    sceneName = newSceneName;
    scene.onEnter(oldScene);
  }
}

void exit() {
  r.saveProgress();
  r.saveLeaderboard();
  super.exit();
}

// controls
void keyPressed() {
  c.set(key, keyCode, true);
}

void keyReleased() {
  c.set(key, keyCode, false);
}

void setKey(int keyCode, boolean value) {
  keys[keyCode] = value;
}
