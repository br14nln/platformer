void select() {

  textAlign(CENTER, CENTER);

  background(black);

  fill(introGrey);
  noStroke();
  rect(150, height/2, 190, 70);

  fill(white);
  textFont(font);
  textSize(50);
  text("map 1", width/4, height/2 + 35);

  fill(introGrey);
  noStroke();
  rect(650, height/2, 190, 70);

  fill(white);
  textFont(font);
  textSize(50);
  text("map 2", 3*width/4, height/2 + 35);
}

void selectClicks() {
  if (mouseX > 150 && mouseX < 340 && mouseY > height/2 && mouseY< height/2 + 70) {
    currentMap = map;
    loadWorld(currentMap);
    loadPlayer();
    lives = 3;
    player.respawnX = 700;
    player.respawnY = 0;
    win = false;
    world.add(player);
    print("?");
    win=false;
    mode = GAME;
  }

  if (mouseX > 650 && mouseX < 840 && mouseY > height/2 && mouseY< height/2 + 70) {
    currentMap = map1;
    loadWorld(currentMap);
    loadPlayer();
    world.add(player);
    print("!");
    win=false;
    lives = 3;
    player.respawnX = 700;
    player.respawnY = 0;
    win = false;
    mode = GAME;
  }
}
