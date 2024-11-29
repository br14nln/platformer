class FSpikes extends FGameObject {
  
  int frame = 0;

  FSpikes(float x, float y) {
    super();
    setPosition (x, y);
    setName("spikes");
    setStatic(true);
  }

  void act () {
    animate(spikes);
  }
  
  void animate(PImage[] name){
    if (frame >= name.length) frame = 0;
    if (frameCount % 5 == 0) {
      attachImage(name[frame]);
      frame++;
    }
  }
}
