class FHammerbro extends FGameObject {

  int direction = L;
  int frame = 0;
  int speed = 100;
  int counter = 0;
  int threshold = 100;


  FHammerbro(float x, float y) {
    super();
    setPosition(x, y);
    setName("hammerbro");
    setRotatable(false);
  }

  void act() {
    collide();
    move();
    animate();
    hammers();
  }

  void hammers() {
    if (counter >= threshold) {
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(this.getX(), this.getY());
      if (direction == R) b.setVelocity(400, -600);;
      if (direction == L) b.setVelocity(-400, -600);;
      b.setAngularVelocity(50);
      b.setSensor(true);
      b.setStatic(false);
      b.setName("hammer");
      b.attachImage(hammer);
      world.add(b);
      
      counter = 0;
    }

    counter++;
  }

  void animate() {
    if (frame >= hammerbro.length) frame = 0;
    if (frameCount % 8 == 0) {
      if (direction == R) attachImage(hammerbro[frame]);
      if (direction == L) attachImage(reverseImage(hammerbro[frame]));
      frame++;
    }
  }

  void collide() {
    if (isTouching("wall")) {
      direction *= -1;
      setPosition(getX() + direction, getY());
    }
    if (isTouching("player")) {
      if (player.getY() < getY()-gridSize/2) {
        if(lives<3) {
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
