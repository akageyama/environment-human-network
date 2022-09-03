

class Connect {
  int id;
  
  Connect( int id_ ) {
    id = id_;
  }
}



class Person {
  int life;
  PVector position;
  ArrayList<Connect>  connectToResource;
  ArrayList<Connect>  connectToPerson;

  Person( int l, PVector p ) {
    life = l;
    position = p;
    connectToResource = new ArrayList<Connect>();
    connectToPerson   = new ArrayList<Connect>();

    int id_resource_sun   = 0;
    int id_resource_soil  = 1;
    int id_resource_water = 2; 
    
    connectToResource.add( new Connect( id_resource_sun   ) );
    connectToResource.add( new Connect( id_resource_soil  ) );
    connectToResource.add( new Connect( id_resource_water ) );
  }
  
    
   void add_new_connect_to_resource( int id_of_resource ) {
     for ( int j=0; j<connectToResource.size(); j++ ) {
       if ( id_of_resource == connectToResource.get(j).id ) {
         println("You are lready worker for this resource. Do nothing");
         return;
       }
     }
     Connect new_work_place = new Connect( id_of_resource );
     connectToResource.add( new_work_place );
   }

  
   void disconnect_to_all_resource() {
     for (int j=0; j<connectToResource.size(); j++) {
       connectToResource.remove(j);
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
      if ( i < 10 ) {
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
    
    person[0].add_new_connect_to_resource( NUM_RESOURCE-1 );
  }


  void draw() {
    for (int i=0; i<POPULATION; i++) {
      int ilife = person[i].life;
      if ( ilife > 0 ) {  // Show only alive person.
        float x0 = person[i].position.x;
        float y0 = person[i].position.y;

        // lines between resources.
        stroke( 200, 240, 200 );
        for (int j=0; j<person[i].connectToResource.size(); j++) {
          int resource_id = person[i].connectToResource.get(j).id;
          float x1 = environment.resource[resource_id].position.x;
          float y1 = environment.resource[resource_id].position.y;
          line( x0, y0, x1, y1);
        }
        
        // lines between person.
        stroke( 0, 0, 255 );
        for (int j=0; j<person[i].connectToPerson.size(); j++) {
          int person_id = person[i].connectToPerson.get(j).id;
          float x1 = human.person[person_id].position.x;
          float y1 = human.person[person_id].position.y;
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

   
  void add_new_connect_between_two_person( int id1, int id2 ) {
    for ( int j=0; j<person[id1].connectToPerson.size(); j++ ) {
      if ( id2 == person[id1].connectToPerson.get(j).id ) {
        println("You are lready connected to this person. Do nothing");
        return;
      }
    }
    Connect connect_1to2 = new Connect( id2 );
    Connect connect_2to1 = new Connect( id1 );
    if ( human.person[id1].life <= 0 ) {
      human.person[id1].life = 100;
    }
    if ( human.person[id2].life <= 0 ) {
      human.person[id2].life = 100;
    }
    human.person[id1].connectToPerson.add( connect_1to2 );
    human.person[id2].connectToPerson.add( connect_2to1 );
  }
  
  
  void disconnect_between_two_person( int id1, int id2 ) {
    for ( int j=0; j<person[id1].connectToPerson.size(); j++ ) {
      if ( id2 == person[id1].connectToPerson.get(j).id ) {
        person[id1].connectToPerson.remove(j);       
      }
    }
    for ( int j=0; j<person[id2].connectToPerson.size(); j++ ) {
      if ( id1 == person[id2].connectToPerson.get(j).id ) {
        person[id2].connectToPerson.remove(j);       
      }
    }    
  }
   
   
  void expand() {
    for (int i=0; i<POPULATION; i++) {
      int allowance = person[i].life - 300;
      if ( allowance >= 0 ) {
        int id_of_new_friend = int( random( POPULATION ) );
        if ( id_of_new_friend == i ) continue; // skip self.
        add_new_connect_between_two_person( i, id_of_new_friend );
      }
    }    
  }


  void shrink() {
    for (int i=0; i<POPULATION; i++) {
      int allowance = person[i].life - 300;
      if ( allowance < 0 ) {
        for ( int j=0; j<person[i].connectToPerson.size(); j++ ) {
          int id_of_counterpart = person[i].connectToPerson.get(j).id;
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
        for (int j=0; j<person[i].connectToResource.size(); j++) {
          person[i].life += 2; 
        }
      }
    }
    
    // take from human
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 0 ) {
        for (int j=0; j<person[i].connectToPerson.size(); j++) {
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
      for (int j=0; j<person[i].connectToResource.size(); j++) {
        person[i].life -= 1; 
      }
    }
    
    
    // give to human
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].connectToPerson.size(); j++) {
        person[i].life -= 1; 
      }
    }      
    
    
    // Remove non-alive person
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life < 0 ) {
        for ( int j=0; j<person[i].connectToPerson.size(); j++ ) {
          int id_of_counterpart = person[i].connectToPerson.get(j).id;
          disconnect_between_two_person( i, id_of_counterpart );
        }
        person[i].disconnect_to_all_resource(); 
      }
    }
         
  }
  
  
  void rearrange_position() {
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 0 ) {
        float x0 = person[i].position.x;
        float y0 = person[i].position.y;
        for ( int j=0; j<10; j++ ) { // pickup 10 person to repulse
          int target_id = int( random( POPULATION ) );
          float x1 = person[target_id].position.x;
          float y1 = person[target_id].position.y;
          float distance = dist( x0, y0, x1, y1 );
          if ( distance > height / 10 ) {
            float dx = x1 - x0;
            float dy = y1 - y0;
            person[i].position.x = x0 - dx/(distance*distance);
            person[i].position.y = y0 - dy/(distance*distance);
          }
        }     
      }
    }
  }
}
