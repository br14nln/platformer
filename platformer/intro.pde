void intro() {
  intro.play();
 
  textAlign(CENTER, CENTER);
  
  
  image(bg, 0, 0, width, height);
  
  fill(introGrey);
  noStroke();
  rect(width/2-250, height-105, 500,70);
  
  fill(white);
  textFont(font);
  textSize(50);
  text("map select", width/2, height-75);
}

void introClicks() {
  
  if (mouseX > width/2-250 && mouseX < width/2+250 && mouseY > height-105 && mouseY< height-35){
    mode = SELECT;
  }
} 
