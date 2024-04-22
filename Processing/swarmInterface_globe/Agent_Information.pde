void makeMirrorList() {
  for(int i = 0; i<mirrorBees.size(); i++) {
    mirrorBees.remove(0);
  }
  for(int i = 0; i<bees.size(); i++) {
     mirrorBees.add(bees.get(i));
  }
}