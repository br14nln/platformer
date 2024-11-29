class FGoomba extends FGameObject {

  int direction = L;
  int speed = 220;
  int frame = 0;


  FGoomba(float x, float y) {
    super();
    setPosition (x, y);
    setName("slime");
    setRotatable(false);
    //setSensor(true);
    //setStatic(true);
  }

  void act () {
    animate(goomba);
    collide();
    move();
  }

  void animate(PImage[] name) {
    if (frame >= name.length) frame = 0;
    if (frameCount % 5 == 0) {
      attachImage(name[frame]);
      frame++;
    }
  }

  void collide() {
    if (isTouching("wall")) {
      direction *= -1;
      setPosition(getX()+direction, getY());
    }

    if (isTouching("player")) {
      if (player.getY() < getY()-gridSize/2) {
        if (lives<3) {
          lives++;
        }
        world.remove(this);
        enemies.remove(this);
        enemyDie.play();
        enemyDie.rewind();
        player.setVelocity(player.getVelocityX(), -300);
      } else if (!starOn){
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
      } else if (starOn && isTouching("player")) {
        if(lives<3) {
          lives++;
        }
        world.remove(this);
        enemies.remove(this);
        enemyDie.play();
        enemyDie.rewind();
        player.setVelocity(player.getVelocityX(), -300);
      }
    }
  }

  void move() {
    float vy = getVelocityY();
    setVelocity(speed*direction, vy);
  }
  
}
