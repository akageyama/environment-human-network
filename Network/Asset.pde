
class Asset {
  float information;
  float material;
  float happiness;
  
  Asset( float i, float m ) {
    information = i;
    material = m;
    happiness = information*material;
  }
}
