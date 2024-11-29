class FStar extends FGameObject {

  FStar(float x, float y) {
    super();
    setPosition (x, y);
    setName("star");
    attachImage(starImg);
    setStatic(true);
    setSensor(true);
  }

  void act () {
    if (isTouching("player")) {
      terrain.remove(this);
      world.remove(this);

      player.canTakeDamage = false;
      starOn = true;

      starSound.play();
      starSound.rewind();
    }
  }
}
