class AudioManager {
  PApplet p;
  Sound s;
  
  private HashMap<String, SoundFile> sounds;
  FloatDict queue;
  float boopRate = 0.1f;
  float boopTimer = 0f;
  
  AudioManager(PApplet p) {
    this.p = p;
    
    sounds = new HashMap<String, SoundFile>();
    queue = new FloatDict();
    
    if (Sound.list().length > 0) {
      s = new Sound(p);
      loadFiles();
    }
  }
  
  void loadFiles() {
    java.io.File folder = new java.io.File(sketchPath("sounds\\"));
    String [] filenames = folder.list();
    for (int i=0; i<filenames.length; i++) {
      SoundFile file = new SoundFile(p, "sounds\\"+filenames[i]);
      String name = filenames[i].substring(0, filenames[i].length()-4);
      sounds.put(name, file);
    }
  }
  
  void setVolume(float value) {
    if (s != null)
      s.volume(value);
  }
  
  void update(float dt) {
    if (s != null)
      s.volume(r.options.get("soundVolume")/100.0f);
    
    boopTimer += dt;
    
    if (boopTimer >= boopRate) {
      if (queue.size() > 0) {
        if (queue.size() > 1)
          queue.sortValuesReverse();
        String soundName = queue.key(0);
        SoundFile sound = sounds.get(soundName);
        
        if (sound.isPlaying()) sound.stop();
        
        sound.rate(queue.get(soundName)+(timeScale-1));
        sound.play();
        
        queue.remove(soundName);
      }
      
      boopTimer = 0f;
    }
  }
  
  void clear() {
    queue.clear();
  }
  
  void playSound(String soundName) {
    playSound(soundName, 1f);
  }
  
  void playSound(String soundName, float soundRate) {
    if (sounds.containsKey(soundName)) {
      if (queue.hasKey(soundName))
        if (queue.get(soundName) > soundRate)
          soundRate = queue.get(soundName);
      
      queue.set(soundName, soundRate);
    }
  }
}
