void gameover() {
  println(mode);
  intro.pause();
  for (int i = 0; i < spawnArray.size(); i++) {
    Fspawn s = spawnArray.get(i);
    s.spawnOn = false;
  }
  player.respawnX = 700;
  player.respawnY = 100;
  if (lives > 0 || win) {
    background(black);
    stroke(white);
    fill(white);
    textFont(font);
    textSize(50);
    text("W's in the SHAETTA", width/2, height/2);
    text("click = start screen", width/2, 500);
    //println(win);
  } else {
    background(72, 27, 29);
    stroke(white);
    fill(white);
    textFont(font);
    textSize(50);
    text("L, clipped", width/2, height/2);
    text("click = start screen", width/2, 500);
    //println(win);
  }
  
  win = false;
  //println(win);
  
  
}

void gameoverClicks() {
  mode = INTRO;
  lives = 3;
  player.respawnX = 700;
  player.respawnY = 0;
  win = false;
  
}
