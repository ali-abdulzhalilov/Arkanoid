class ResourceManager { 
  private HashMap<String, Level> levels;
  StringList orderedLevels;
  StringList orderedBoard;
  
  HashMap<String, Integer> options;
  HashMap<String, Integer> progress;
  IntDict leaderboard;
  
  ResourceManager() {
    levels = new HashMap<String, Level>();
    orderedLevels = new StringList();
    loadLevels();
    
    options = new HashMap<String, Integer>();
    loadOptions();
    
    progress = new HashMap<String, Integer>();
    loadProgress();
    
    leaderboard = new IntDict();
    orderedBoard = new StringList();
    loadLeaderboard();
  }
  
  // levels stuff
  void loadLevels() {
    java.io.File folder = new java.io.File(sketchPath("levels\\"));
    String [] filenames = folder.list();
    for (int i=0; i<filenames.length; i++) {
      println(filenames[i]);
      Level level = new Level("levels\\"+filenames[i]);
      String name = filenames[i].substring(0, filenames[i].length()-4);
      levels.put(name, level);
      orderedLevels.append(name);
    }
    orderedLevels.sort();
  }
  
  Level getLevel(int levelIndex) {
    if (levelIndex <= -1) return null;
    if (levelIndex >= orderedLevels.size()) return null;
    
    return r.levels.get(r.orderedLevels.get(levelIndex));  
  }
  
  int getNextLevelIndex(int levelIndex) {
    if (levelIndex+1 <= -1) return -1;
    if (levelIndex+1 >= orderedLevels.size()) return -1;
    
    return levelIndex+1;
  }
  
  // options stuff
  void loadOptions() {
    String[] tmp = loadStrings("options.txt");
    
    if (tmp != null) {
      for (int i=0; i<tmp.length; i++) {
        String[] row = splitTokens(tmp[i], ": ");
        options.put(row[0], int(row[1]));
      }
    }
  }
  
  void saveOptions() {
    StringList tmp = new StringList();
    for (String entry: options.keySet()) {
      tmp.append(entry+":"+options.get(entry));
    }
    
    saveStrings("options.txt", tmp.array());
  }
  
  // progress stuff
  void loadProgress() {
    String[] tmp = loadStrings("progress.txt");
    
    if (tmp != null) {
      for (int i=0; i<tmp.length; i++) {
        String[] row = splitTokens(tmp[i], ": ");
        progress.put(row[0], int(row[1]));
      }
    }
  }
  
  void saveProgress() {
    StringList tmp = new StringList();
    for (String entry: progress.keySet()) {
      tmp.append(entry+":"+progress.get(entry));
    }
    
    saveStrings("progress.txt", tmp.array());
  }
  
  void resetProgress() {
    progress.clear();
      
    saveStrings("progress.txt", new String[]{});
  }
  
  // leaderboard stuff
  void loadLeaderboard() {
    String[] tmp = loadStrings("leaderboard.txt");
    
    if (tmp != null) {
      for (int i=0; i<tmp.length; i++) {
        String[] row = splitTokens(tmp[i], ": ");
        leaderboard.set(row[0], int(row[1]));
      }
    }
    
    leaderboard.sortValuesReverse();
  }
  
  void saveLeaderboard() {
    StringList tmp = new StringList();
    for (String entry: leaderboard.keys()) {
      tmp.append(entry+":"+leaderboard.get(entry));
    }
    
    saveStrings("leaderboard.txt", tmp.array());
  }
  
  void putToLeaderboard(String name, int score) {
    if (name == "" || name == null)
      name = "_";
      
    leaderboard.set(name, score);
    
    if (leaderboard.size() > 10)
      leaderboard.remove(leaderboard.minKey());
      
    leaderboard.sortValuesReverse();
  }
}

class Level {
  ArrayList<String> level;
  int w, h, count;
  
  Level(String filepath) {
    
    level = new ArrayList<String>();
    String[] lines = loadStrings(filepath);
    w = 0; h = lines.length; count = 0;
    
    for (int i=0; i<lines.length; i++) {
      if (lines[i].length() > w) w = lines[i].length();
      level.add(lines[i]);
      for (int j=0; j<lines[i].length(); j++)
        if (lines[i].charAt(j) == '#') count++;
    }
  }
  
  void printLevel() {
    println("w:"+w+" h:"+h+" count:"+count);
    for (int i=0; i<level.size(); i++) {
      println(level.get(i));
    }
  }
}
