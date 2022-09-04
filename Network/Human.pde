

class FluxTo {
  int id;
  
  FluxTo( int id_ ) {
    id = id_;
  }
}

class FluxFrom {
  int id;
  
  FluxFrom( int id_ ) {
    id = id_;
  }
}



class Person {
  int life;
  PVector position;
  ArrayList<FluxFrom> fluxFromResource;
  ArrayList<FluxFrom> fluxFromPerson;
  ArrayList<FluxTo>   fluxToResource;
  ArrayList<FluxTo>   fluxToPerson;

  Person( int l, PVector p ) {
    life = l;
    position = p;
    fluxFromResource = new ArrayList<FluxFrom>();
    fluxFromPerson   = new ArrayList<FluxFrom>();
    fluxToResource   = new ArrayList<FluxTo>();
    fluxToPerson     = new ArrayList<FluxTo>();

    float probability = 1.0/NUM_RESOURCE;
    
    for ( int r=0; r<NUM_RESOURCE; r++ ) {
      if ( random(1.0) < probability ){
        fluxFromResource.add( new FluxFrom( r) );
        fluxToResource.add( new FluxTo( r ) );
      }
    }

  }
  
    
   void add_new_connect_to_resource( int id_of_resource ) {
     for ( int j=0; j<fluxFromResource.size(); j++ ) {
       if ( id_of_resource == fluxFromResource.get(j).id ) {
         println("You are lready worker for this resource. Do nothing");
         return;
       }
     }
     fluxFromResource.add(new FluxFrom( id_of_resource ) );
     fluxToResource.add(new FluxTo( id_of_resource ) );
   }

  
   void disconnect_to_all_resource() {
     for (int j=0; j<fluxFromResource.size(); j++) {
       fluxFromResource.remove(j);
       fluxToResource.remove(j);
     }
   }

}


class Human {
  Person[] person;

  Human () {
    person = new Person[POPULATION];
    for (int i=0; i<POPULATION; i++) {
      int initial_life;
      // Just a small number of people is "alive" in the beginning.
      if ( i < POPULATION/20 ) {
        initial_life = 100;
      } else {  // Other people are "non-alive".
        initial_life = 0;
      }
      float random_x = random(width);
      float random_y = random(height);
      float x_with_separation = map( random_x, 0.0, float(width),  0.1*width,  0.9*width  );
      float y_with_separation = map( random_y, 0.0, float(height), 0.1*height, 0.9*height );
      PVector random_position = new PVector( x_with_separation, y_with_separation );
      person[i] = new Person( initial_life, random_position );
    }
    
    // person[0].add_new_connect_to_resource( NUM_RESOURCE-1 );
  }


  void draw() {
    for (int i=0; i<POPULATION; i++) {
      int ilife = person[i].life;
      if ( ilife > 0 ) {  // Show only alive person.
        float x0 = person[i].position.x;
        float y0 = person[i].position.y;

        // lines between resources.
        stroke( 200, 240, 200 );
        for (int j=0; j<person[i].fluxFromResource.size(); j++) {
          int resource_id = person[i].fluxFromResource.get(j).id;
          float x1 = environment.resource[resource_id].position.x;
          float y1 = environment.resource[resource_id].position.y;
          line( x0, y0, x1, y1);
        }
        
        // lines between person.
        stroke( 0, 0, 255 );
        for (int j=0; j<person[i].fluxToPerson.size(); j++) {
          int friend_id = person[i].fluxToPerson.get(j).id;
          float x1 = person[friend_id].position.x;
          float y1 = person[friend_id].position.y;
          line( x0, y0, x1, y1);
        }

        // person as a circle.
        if ( ilife > 255 ) {
          fill( 0 );
        } else {
          fill( 255 - ilife );
        }
        stroke(1);
        ellipse( x0, y0, 10, 10 );
      }
    }
  }

   
  void add_new_connect_between_two_person( int id_from, int id_to ) {
    for ( int j=0; j<person[id_from].fluxToPerson.size(); j++ ) {
      if ( id_to == person[id_from].fluxToPerson.get(j).id ) {
        println("You are lready connected to this person. Do nothing");
        return;
      }
    }
    FluxTo   from1to2 = new FluxTo( id_to );
    FluxFrom from2to1 = new FluxFrom( id_from );
    if ( person[id_from].life <= 0 ) {
      println(" Non-alive person cannot give anything.");
      return;
    }
    if ( person[id_to].life < 100 ) {
      person[id_to].life = 100;
    }
    person[id_from].fluxToPerson.add( from1to2 );
    person[id_to].fluxFromPerson.add( from2to1 );
  }
  
  
  void disconnect_between_two_person( int id_from, int id_to ) {
    for ( int j=0; j<person[id_from].fluxToPerson.size(); j++ ) {
      if ( id_to == person[id_from].fluxToPerson.get(j).id ) {
        person[id_from].fluxToPerson.remove(j);       
      }
    }
    for ( int j=0; j<person[id_to].fluxFromPerson.size(); j++ ) {
      if ( id_from == person[id_to].fluxFromPerson.get(j).id ) {
        person[id_to].fluxFromPerson.remove(j);       
      }
    }    
  }
   
   
  void expand() {
    for (int i=0; i<POPULATION; i++) {
      int allowance = person[i].life - 255;
      if ( allowance >= 0 ) {
        int id_of_new_friend = int( random( POPULATION ) );
        if ( id_of_new_friend == i ) continue; // skip self.
        add_new_connect_between_two_person( i, id_of_new_friend );
      }
    }    
  }


  void shrink() {
    for (int i=0; i<POPULATION; i++) {
      int allowance = person[i].life - 255;
      if ( allowance < 0 ) {
        for ( int j=0; j<person[i].fluxToPerson.size(); j++ ) {
          int id_of_counterpart = person[i].fluxToPerson.get(j).id;
          disconnect_between_two_person( i, id_of_counterpart );
        }
      }
    }    
  }

  
  void live_on() {    
    
    //// Sometimes, a person become a farmer.
    //float probability = 0.01;
    //if ( random(1.0) < probability ) {
    //  for (int i=0; i<POPULATION; i++) {
    //    float probability2 = 1.0 / POPULATION;
    //    if ( random(1.0) < probability2 ) {
    //      if ( person[i].life > 0 && person[i].Connect_counter == 0 ) {
    //        person[i].become_farmer( 4 );
    //      }
    //    }
    //  }
    //}

    // take from environment
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 0 ) {
        for (int j=0; j<person[i].fluxFromResource.size(); j++) {
          person[i].life += 3; 
        }
      }
    }
    
    // take from human
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 0 ) {
        for (int j=0; j<person[i].fluxFromPerson.size(); j++) {
          person[i].life += 1; 
        }
      }
    }
    
    // upper limit
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 1000 ) {
        person[i].life = 1000;
      }
    }
    
    // give to environment
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].fluxToResource.size(); j++) {
        person[i].life -= 1; 
      }
    }
    
    
    // give to human
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].fluxToPerson.size(); j++) {
        person[i].life -= 1; 
      }
    }      
    
    
    // Remove non-alive person
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life < 0 ) {
        for ( int j=0; j<person[i].fluxToPerson.size(); j++ ) {
          int id_of_counterpart = person[i].fluxToPerson.get(j).id;
          disconnect_between_two_person( i, id_of_counterpart );
        }
        for ( int j=0; j<person[i].fluxFromPerson.size(); j++ ) {
          int id_of_counterpart = person[i].fluxFromPerson.get(j).id;
          disconnect_between_two_person( i, id_of_counterpart );
        }
        person[i].disconnect_to_all_resource(); 
      }
    }
         
  }
    
  void rearrange_position() {
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 0 ) {
          float random_x = random(-1,1);
          float random_y = random(-1,1);
          person[i].position.x += random_x;
          person[i].position.y += random_y;          
      }
    }
  }
}
