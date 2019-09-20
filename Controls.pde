class Controls {
  boolean[] keys = new boolean[65536];
  boolean[] wasKeys = new boolean[65536];
  boolean[] keyCodes = new boolean[65536];
  boolean[] wasKeyCodes = new boolean[65536];
  ArrayList<Integer> specialKeys;
  IntList tmp;
  
  Controls() {
    specialKeys = new ArrayList<Integer>();
    specialKeys.add(int(BACKSPACE));
    specialKeys.add(int(TAB));
    specialKeys.add(int(ENTER));
    specialKeys.add(int(RETURN));
    specialKeys.add(int(ESC));
    specialKeys.add(int(DELETE));
    
    tmp = new IntList();
  }
  
  void set(int key, int keyCode, boolean value) {
    if (key == CODED) {
      keyCodes[keyCode] = value;
    }
    else {
      keys[key] = value;
    }
  }
  
  void update() {
    for (int i=0; i<keys.length; i++) {
      wasKeys[i] = keys[i];
      wasKeyCodes[i] = keyCodes[i];
    }
  }
  
  //getHold()
  //getPress()
  //getRelease()
  //getTyped() ?
  
  //isLetter(key)
  
  // get
  
  IntList getPress() {
    tmp.clear();
    
    for (int i=0; i<keys.length; i++)
      if (isPressed(i))
        tmp.append(i);
    
    return tmp;
  }
  
  IntList getHold() {
    tmp.clear();
    
    for (int i=0; i<keys.length; i++)
      if (isHeld(i))
        tmp.append(i);
    
    return tmp;
  }
  
  IntList getReleased() {
    tmp.clear();
    
    for (int i=0; i<keys.length; i++)
      if (isReleased(i))
        tmp.append(i);
    
    return tmp;
  }
  
  IntList getTyped() {
    tmp.clear();
    
    for (int i=0; i<keys.length; i++)
      if (isPressed(i) && isLetter(i))
        tmp.append(i);
    
    return tmp;
  }
  
  // is 
  
  boolean isPressed(int key) {
    return keys[key] && !wasKeys[key];
  }
  
  boolean isCodedPressed(int keyCode) {
    return keyCodes[keyCode] && !wasKeyCodes[keyCode];
  }
  
  boolean isHeld(int key) {
    return keys[key] && wasKeys[key];
  }
  
  boolean isCodedHeld(int keyCode) {
    return keyCodes[keyCode] && wasKeyCodes[keyCode];
  }
  
  boolean isReleased(int key) {
    return !keys[key] && wasKeys[key];
  }
  
  boolean isCodedReleased(int keyCode) {
    return !keyCodes[keyCode] && wasKeyCodes[keyCode];
  }
  
  boolean isLetter(int key) {
    return !specialKeys.contains(key);
  }
}
