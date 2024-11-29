import fisica.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

int mode;


final int INTRO = 0;
final int GAME = 1;
final int PAUSE = 2;
final int GAMEOVER = 3;
final int SELECT = 4;

FWorld world;

Minim minim;
AudioPlayer intro, jumpSound, killed, slimeSound, enemyDie, starSound, thwompSound;

//colours
color white = #FFFFFF;
color grey = #8f8f8f;
color black = #000000;
color lightBlue = #51a7ff;
color burgundy = #863939;
color brown = #503131;
color green = #1c7128;
color skyBlue = #87CEEB;
color yellow = #cfcb80;
color brightGreen = #00ff02;
color blue = #0045ff;
color purple = #ea00ff;
color introGrey = #707372;
color enemyPurple = #7a00ff;
color lightGrey = #b9b9b9;
color orange = #ff7600;
color brightYellow = #fff200;
color red = #ff0000;

//font
PFont font;

int lives, timer;

boolean starOn;
boolean win;

PImage map, map1, map2, currentMap, heart, dirt, ice, wood, leaves, tramp, endLeaves, lava, sand, slime, ball, background, bg, noHeart, hammer, starImg, flag;

FStar star;


//player
PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] idleStar;
PImage[] jumpStar;
PImage[] runStar;
PImage[] action;

PImage[] spikes;
PImage[] respawn;

PImage[] goomba;
PImage[] hammerbro;
PImage[] bowser;
PImage thwomp0, thwomp1;


int gridSize = 32;
float zoom = 1.2;
boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey, dkey, qkey, ekey, spacekey;
FPlayer player;

ArrayList<FGameObject> terrain;
ArrayList<Fspawn> spawnArray;
ArrayList<FGameObject> enemies;

void setup () {
  size(1000, 600);
  mode = INTRO;

  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  spawnArray = new ArrayList<Fspawn>();
  enemies = new ArrayList<FGameObject>();


  lives = 3;
  timer = 30;
  font = createFont("font.ttf", 200);

  loadImages();
  loadSounds();
  loadPlayer();
}


void draw() {
  if (mode == INTRO) {
    intro();
  } else if (mode == GAME) {
    game();
  } else if (mode == PAUSE) {
    pause();
  } else if (mode == GAMEOVER) {
    gameover();
  } else if (mode == SELECT) {
    select();
  }
}


void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 5000, 5000);
  world.setGravity(0, 900);

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {

      color c = img.get(x, y); //current pixel
      color l = img.get(x-1, y); //colour left to pixel
      color r = img.get(x+1, y); //colour right to pixel

      if (c == black) {
        FBox b = new FBox(gridSize, gridSize);
        b.attachImage(dirt);
        b.setName("ground");
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(2);
        world.add(b);
      } else if (c == grey) {
        FBox b = new FBox(gridSize, gridSize);
        b.attachImage(lava);
        b.setName("lava");
        b.setFriction(2);
        b.setSensor(true);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        world.add(b);
      } else if (c == lightBlue) {
        FBox b = new FBox(gridSize, gridSize);
        b.attachImage(ice);
        b.setName("ground");
        b.setPosition(x*gridSize, y*gridSize);
        b.setFriction(0.01);
        b.setStatic(true);
        world.add(b);
      } else if (c == burgundy) {
        FBox b = new FBox(gridSize, gridSize);
        b.attachImage(slime);
        b.setName("tramp");
        b.setRestitution(1.4);
        b.setFriction(2);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        world.add(b);
      } else if (c == brown) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.attachImage(wood);
        b.setSensor(true);
        b.setFriction(2);
        b.setName("trunk");
        b.setStatic(true);
        world.add(b);
      } else if (c == green && l != green && r == green) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setFriction(2);
        b.attachImage(endLeaves);
        b.setStatic(true);
        b.setName("leaves");
        world.add(b);
      } else if (c == green && l == green && r != green) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.attachImage(endLeaves);
        b.setFriction(2);
        b.setStatic(true);
        b.setName("leaves");
        world.add(b);
      } else if (c == green && l != green && r != green) {
        FBox b = new FBox(gridSize, gridSize);
        b.setFriction(2);
        b.setPosition(x*gridSize, y*gridSize);
        b.attachImage(endLeaves);
        b.setStatic(true);
        b.setName("leaves");
        world.add(b);
      } else if (c == green) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setFriction(2);
        b.attachImage(leaves);
        b.setStatic(true);
        b.setName("leaves");
        world.add(b);
      } else if (c == yellow) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        terrain.add(br);
        world.add(br);
      } else if (c == lightGrey) {
        FSpikes spike = new FSpikes(x*gridSize, y*gridSize);
        terrain.add(spike);
        world.add(spike);
      } else if (c == brightGreen) {
        FGoomba goomba = new FGoomba(x*gridSize, y*gridSize);
        enemies.add(goomba);
        world.add(goomba);
      } else if (c == purple) {
        FHammerbro hammerbro = new FHammerbro(x*gridSize, y*gridSize);
        enemies.add(hammerbro);
        world.add(hammerbro);
      } else if (c == enemyPurple) {
        FThwomp thwomp = new FThwomp(x*gridSize, y*gridSize);
        enemies.add(thwomp);
        world.add(thwomp);
      } else if (c == orange) {
        FBowser bowser = new FBowser(x*gridSize, y*gridSize);
        enemies.add(bowser);
        world.add(bowser);
      } else if (c == blue) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setFriction(2);
        b.setStatic(true);
        b.attachImage(dirt);
        b.setName("wall");
        world.add(b);
      } else if (c == white) {
        Fspawn spawn = new Fspawn(x*gridSize, y*gridSize);
        spawnArray.add(spawn);
        world.add(spawn);
      } else if (c == brightYellow) {
        star = new FStar(x*gridSize, y*gridSize);
        terrain.add(star);
        world.add(star);
      } else if (c == red) {
        Fflag flag = new Fflag(x*gridSize, y*gridSize);
        terrain.add(flag);
        world.add(flag);
      }
    }
  }
}

void loadPlayer() {
  player = new FPlayer();
}

void loadImages() {
  map = loadImage("map.png");
  map1 = loadImage("map1.png");
  currentMap = map;
  bg = loadImage("background.jpg");

  heart = loadImage("heart.png");
  noHeart = loadImage("noHeart.png");

  dirt = loadImage("dirt.png");
  dirt.resize(gridSize, gridSize);

  ice = loadImage("ice.png");
  ice.resize(gridSize, gridSize);

  wood = loadImage("wood.png");
  wood.resize(gridSize, gridSize);

  leaves = loadImage("leaves.png");
  leaves.resize(gridSize, gridSize);

  tramp = loadImage("tramp.png");
  tramp.resize(gridSize, gridSize);

  endLeaves = loadImage("endLeaves.png");
  endLeaves.resize(gridSize, gridSize);

  lava = loadImage("lava.png");
  lava.resize(gridSize, gridSize);

  sand = loadImage("sand.png");
  sand.resize(gridSize, gridSize);

  slime = loadImage("slime.png");
  slime.resize(gridSize, gridSize);

  ball = loadImage("ball.png");
  ball.resize(gridSize, gridSize);

  hammer = loadImage("hammer.png");
  hammer.resize(gridSize, gridSize);

  starImg = loadImage("star.png");
  starImg.resize(gridSize, gridSize);

  flag = loadImage("flag.png");
  flag.resize(gridSize, gridSize);


  idle = new PImage[2];
  idle[0] = loadImage("idle0.png");
  idle[1] = loadImage("idle1.png");

  jump = new PImage[1];
  jump[0] = loadImage("jump0.png");

  run = new PImage[3];
  run[0] = loadImage("run0.png");
  run[1] = loadImage("run1.png");
  run[2] = loadImage("run2.png");

  idleStar = new PImage[2];
  idleStar[0] = loadImage("idleStar0.png");
  idleStar[1] = loadImage("idleStar1.png");

  jumpStar = new PImage[1];
  jumpStar[0] = loadImage("jumpStar0.png");

  runStar = new PImage[3];
  runStar[0] = loadImage("runStar0.png");
  runStar[1] = loadImage("runStar1.png");
  runStar[2] = loadImage("runStar2.png");


  goomba = new PImage[2];
  goomba[0] = loadImage("goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("goomba1.png");
  goomba[1].resize(gridSize, gridSize);

  respawn = new PImage[2];
  respawn[0] = loadImage("respawn.png");
  respawn[0].resize(gridSize, gridSize);
  respawn[1] = loadImage("respawnOff.png");
  respawn[1].resize(gridSize, gridSize);

  hammerbro = new PImage[2];
  hammerbro[0] = loadImage("hammerbro0.png");
  hammerbro[0].resize(gridSize, gridSize);
  hammerbro[1] = loadImage("hammerbro1.png");
  hammerbro[1].resize(gridSize, gridSize);

  spikes = new PImage[3];
  spikes[0] = loadImage("spike0.png");
  spikes[0].resize(gridSize, gridSize);
  spikes[1] = loadImage("spike1.png");
  spikes[1].resize(gridSize, gridSize);
  spikes[2] = loadImage("spike2.png");
  spikes[2].resize(gridSize, gridSize);

  bowser = new PImage[4];
  bowser[0] = loadImage("bowser0.png");
  bowser[0].resize(gridSize+2, gridSize+2);
  bowser[1] = loadImage("bowser1.png");
  bowser[1].resize(gridSize+2, gridSize+2);
  bowser[2] = loadImage("bowser2.png");
  bowser[2].resize(gridSize+2, gridSize+2);
  bowser[3] = loadImage("bowser3.png");
  bowser[3].resize(gridSize+2, gridSize+2);

  thwomp0 = loadImage("thwomp0.png");
  thwomp0.resize(gridSize, gridSize);
  thwomp1 = loadImage("thwomp1.png");
  thwomp1.resize(gridSize, gridSize);
}

void loadSounds() {
  minim = new Minim(this);
  intro = minim.loadFile("intro.mp3");
  jumpSound = minim.loadFile("jumpSound.mp3");
  jumpSound.setVolume(0.1);
  killed = minim.loadFile("killed.mp3");
  slimeSound = minim.loadFile("slimeSound.mp3");
  enemyDie = minim.loadFile("enemyDie.mp3");
  starSound = minim.loadFile("starSound.mp3");
  thwompSound = minim.loadFile("thwompSound.mp3");
}

void sensorMove() {
  //senDown.setPosition(player.getX(), player.getY()+12);

  //float lvx = player.getVelocity();
  //float lvy = player.getVelocity();

  //senDown.setVelocity(lvx-10,lvy-250);
}

void drawWorld() {
  if (world!= null && player!= null) {
    pushMatrix();
    translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
    scale(zoom);
    world.step();
    world.draw();
    popMatrix();
  }
}

void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }

  for (int i = 0; i < spawnArray.size(); i++) {
    Fspawn t = spawnArray.get(i);
    t.act();
  }

  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
}
