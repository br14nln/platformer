void game() {
  background(black);
  if (lives <= 0 || win) mode = GAMEOVER;
  

  drawWorld();
  actWorld();
  
  for (int i = 0; i < 3; i++) {
    image(noHeart, i*40 + 20,30,30,30);
  }
  
  for (int i = 0; i < lives; i++) {
    image(heart, i*40 + 20,30,30,30);
  }
}

void gameClicks() {
  mode = PAUSE;
}
