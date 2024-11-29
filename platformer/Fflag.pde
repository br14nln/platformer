class Fflag extends FGameObject {
  
  Fflag(float x, float y) {
    super();
    setPosition (x, y);
    setName("flag");
    attachImage(flag);
    setStatic(true);
    setSensor(true);
  }
  
  void act () {
    
    if (isTouching("player")) {
      player.respawnX = 700;
      player.respawnY = 0;
      println("touching");
      win = true;
    }
  }
}
