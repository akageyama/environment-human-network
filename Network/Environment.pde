
class Resource {
  PVector position;
  color   rgb;

  Resource ( PVector p, color rgb_ ) {
    position = p;
    rgb = rgb_;
  }
}

class Environment {
  Resource[] resource;

  Environment( ) {
    resource = new Resource[NUM_RESOURCE];
    for (int i=0; i<NUM_RESOURCE; i++) {
      if ( i == 0 ) {  // Special "resource", negative resource. Dump site.
        color c = color(0, 0, 0);
        resource[i] = new Resource( new PVector(width-20,height-20), c );  // Lower-right corner.
      } else {
        float random_x = random(width);
        float random_y = random(height);
        float x_with_separation = map( random_x, 0.0, float(width),  0.1*width,  0.9*width  );
        float y_with_separation = map( random_y, 0.0, float(height), 0.1*height, 0.9*height );
        PVector random_position = new PVector( x_with_separation, y_with_separation );
        color c = color(255, 120, 140);
        resource[i] = new Resource( random_position, c );
      }
    }
  }

  void draw() {
    for (int i=0; i<NUM_RESOURCE; i++) {        
      fill( resource[i].rgb );
      ellipse( resource[i].position.x, 
               resource[i].position.y, 
               20, 20 );
    }
  }
}
