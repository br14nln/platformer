void pause() {
  intro.pause();
  
  fill(white); 
  textFont(font);
  textSize(100);
  text("pause", width/2, height/2);
} 

void pauseClicks() { 
  mode = GAME;
  intro.play();
} 
