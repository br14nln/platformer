class FPlayer extends FGameObject {

  boolean canTakeDamage = true;
  int frame;
  int direction;
  int starTimer;
  
  float respawnX, respawnY;
  

  final int L = -1;
  final int R = 1;

  FPlayer () {
    super();
    respawnX = 700;
    respawnY = 0;
    setPosition (respawnX, respawnY);
    setName("player");
    setFillColor(green);
    direction = R;
    setRotatable(false);
    starTimer = 750;
  }

  void act() {
    handleInput();
    collisions();
    animate(action);
    
  }

  void handleInput() {
    float vx = getVelocityX();
    float vy = getVelocityY();

    if (vy == 0 && starOn==false) {
      action = idle;
    }
    
    if (vy == 0 && starOn) {
      action = idleStar;
    }

    if (akey && !starOn) {
      setVelocity(-200, vy);
      action = run;
      direction = L;
    }
    
    if (akey && starOn) {
      setVelocity(-200, vy);
      action = runStar;
      direction = L;
    }

    if (dkey && !starOn) {
      setVelocity(200, vy);
      action = run;
      direction = R;
    }
    
    if (dkey && starOn) {
      setVelocity(200, vy);
      action = runStar;
      direction = R;
    }

    if (wkey && canJump()) {
      setVelocity(vx, -400);
      jumpSound.play();
      jumpSound.rewind();
    }

    if (abs(vy) > 0.2 && !starOn) action = jump;
    if (abs(vy) > 0.2 && starOn) action = jumpStar;
  }

  void collisions() {
    if (isTouching("lava") && canTakeDamage && !starOn || isTouching("hammer") && canTakeDamage && !starOn || isTouching("spikes") && canTakeDamage&& !starOn ) {
      canTakeDamage = false;
      setPosition(respawnX, respawnY);

      lives--;
      killed.play();
      killed.rewind();
    }
    
    
    if (isTouching("respawn")) {
      respawnX = 700;
      respawnY = 400;
    }
    
    
    if (isTouching("tramp")) {
      slimeSound.play();
      slimeSound.rewind();
    }

    timer--;

    if (timer < 0) {
      timer = 30;
      canTakeDamage = true;
    }
    
    if (starOn) {
      starTimer--;

      if (starTimer <= 0) {
        starOn = false;
        starTimer = 750;
      }
    }
    
    if (!starOn) {
        starSound.pause();
    }
  }

  void animate(PImage[] name) {
    if (frame >= name.length) frame = 0;

    if (frameCount % 8 == 0) {
      if (direction == R) {
        attachImage(name[frame]);
      } else if (direction == L) {
        attachImage(reverseImage(name[frame]));
      }
      frame++;
    }
  }

  boolean canJump () {
    ArrayList<FContact> contactList = player.getContacts();
    for (int i = 0; i < contactList.size(); i++) {
      FContact fc = contactList.get(i);
      if (fc.contains("ground")|| fc.contains("leaves") || fc.contains("respawn") || fc.contains("spikes")) {
        return true;
      }
    }
    return false;
  }
}
