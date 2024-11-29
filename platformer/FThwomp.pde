class FThwomp extends FGameObject {

  int direction = L;
  int speed = 50;
  int frame = 0;
  int timer = 1000000;

  FThwomp(float x, float y) {
    super();
    setPosition(x, y);
    setName("thwomp");
    setStatic(true);
    setRotatable(false);
  }

  void act() {
    animate();
    collide();
    move();
  }

  void animate() {
    if (timer < 100 && timer > 0) {
      attachImage(thwomp1);
    } else if (timer > 100 || timer < 0) {
      attachImage(thwomp0);
    }
  }

  void collide() {
    if (isTouching("player")) {
      player.canTakeDamage = false;
      player.setPosition(player.respawnX, player.respawnY);

      lives--;
      timer--;
      killed.play();
      killed.rewind();
      if (timer < 0) {
        timer = 30;
        player.canTakeDamage = true;
      }
    }
  }

  void move() {
    timer--;
    if ((player.getX() > getX() - gridSize &&player.getX()<getX()+gridSize&& player.getY() < getY()+300-gridSize) && (timer > 100 || timer < 0)) {
      setStatic(false);
      thwompSound.play();
      thwompSound.rewind();
      timer = 100;
    }
    
    if (timer <  0) {
      setVelocity(getVelocityX(), -200);
    }
  }
}
