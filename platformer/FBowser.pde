class FBowser extends FGameObject {


  int direction = L;
  int speed = 100;
  int frame = 0;

  FBowser(float x, float y) {
    super();
    setPosition(x, y);
    setName("bowser");
    setRotatable(false);
  }

  void act() {
    animate();
    collide();
    move();
  }

  void animate() {
    if (frame >= bowser.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == L) attachImage(bowser[frame]);
      if (direction == R) attachImage(reverseImage(bowser[frame]));
      frame++;
    }
  }

  void collide() {
    if (isTouching("wall")) {
      direction *= -1;
      setPosition(getX() + direction, getY());
      speed = 100;
    }
    
    if (player.getX() < getX() && player.getY() >= getY()) {
      direction = L;
      speed = 270;
    } else if (player.getX() > getX() && player.getY() >= getY()) {
      direction = R;
      speed = 270;
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
