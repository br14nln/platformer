class FGameObject extends FBox {

  final int L = -1;
  final int R = 1;

  FGameObject() {
    super(gridSize, gridSize);
  }

  void act() {
  }

  boolean isTouching(String n) {
    ArrayList<FContact> contacts = getContacts();
    for (int i = 0; i < contacts.size(); i++) {
      FContact fc = contacts.get(i);
      if (fc.contains(n)) {
        return true;
      }
    }
    return false;
  }

  boolean hitGroundThwomp(FThwomp f) {
    ArrayList<FContact> contactList = f.getContacts();
    for (int i = 0; i < contactList.size(); i++) {
      if (contactList.size() > 0) {
        FContact t = contactList.get(i);
        if (!t.contains("player")) {
          return true;
        }
      }
    }
    return false;
  }
}
