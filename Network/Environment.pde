
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
    PVector position_center     = new PVector(  width/2,  height/2 );
    PVector position_north_west = new PVector(      +20,       +20 );
    PVector position_south_west = new PVector(      +20, height-20 );
    PVector position_south_east = new PVector( width-20, height-20 );
    PVector position_north_east = new PVector( width-20,       +20 );
    for (int i=0; i<NUM_RESOURCE; i++) {
      if ( i == 0 ) {  
        color c = color(200, 120, 140);
        resource[i] = new Resource( position_north_west, c );
      } else if ( i==1 ) {
        color c = color(200, 200, 140);
        resource[i] = new Resource( position_south_west,     c );
      } else if ( i==2 ) {
        color c = color(140, 120, 200);
        resource[i] = new Resource( position_south_east, c );
      } else if ( i==3 ) {
        color c = color(140, 200, 120);
        resource[i] = new Resource( position_north_east, c );
      } else {
        float random_x = random(width);
        float random_y = random(height);
        float x_with_separation = map( random_x, 0.0, float(width),  0.1*width,  0.9*width  );
        float y_with_separation = map( random_y, 0.0, float(height), 0.1*height, 0.9*height );
        PVector random_position = new PVector( x_with_separation, y_with_separation );
        color c = color(120, 255, 255);
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
