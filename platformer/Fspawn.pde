class Fspawn extends FGameObject {
  boolean spawnOn;

  Fspawn(float x, float y) {
    super();
    setPosition (x, y);
    setName("spawn");
    setRotatable(false);
    setStatic(true);
    //setFill(255);
    attachImage(respawn[0]);
  }

  void act () {
    animate(respawn);
    collide();
  }

  void animate(PImage[] name) {
    if (spawnOn) {
      attachImage(name[0]);
    } else {
      attachImage(name[1]);
    }
  }

  void collide() {
    if (isTouching("player")) {
      for (int i = 0; i < spawnArray.size(); i++) {
        Fspawn s = spawnArray.get(i);
        s.spawnOn = false;
      }
      spawnOn = true;
      player.respawnX = getX();
      player.respawnY = getY()-100;
    }
  }
}
