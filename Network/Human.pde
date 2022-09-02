
class FluxGiveToEnvironment {
  int id_of_resource;
  float flux;

  FluxGiveToEnvironment( int id_of_resource_, float flux_ ) {
    id_of_resource = id_of_resource_;
    flux = flux_;
  }
}



class FluxTakeFromEnvironment {
  int id_of_resource;
  float flux;

  FluxTakeFromEnvironment( int id, float flux_ ) {
    id_of_resource = id;
    flux = flux_;
  }
}



class FluxGiveToHuman {
  int id_of_person;
  float flux;

  FluxGiveToHuman( int id, float flux_ ) {
    id_of_person = id;
    flux = flux_;
  }
}


class FluxTakeFromHuman {
  int id_of_person;
  float flux;

  FluxTakeFromHuman( int id, float flux_ ) {
    id_of_person = id;
    flux = flux_;
  }
}


class Person {
  float life;
  int connection_counter;
  PVector position;
  ArrayList<FluxGiveToEnvironment>   give_list_to_environment;
  ArrayList<FluxTakeFromEnvironment> take_list_from_environment;
  ArrayList<FluxGiveToHuman>         give_list_to_human;
  ArrayList<FluxTakeFromHuman>       take_list_from_human;

  Person( float l, PVector p ) {
    life = l;
    connection_counter = 0;
    position = p;
    give_list_to_environment   = new ArrayList<FluxGiveToEnvironment>();
    take_list_from_environment = new ArrayList<FluxTakeFromEnvironment>();
    give_list_to_human         = new ArrayList<FluxGiveToHuman>();
    take_list_from_human       = new ArrayList<FluxTakeFromHuman>();

    int id_resource_dump_site = 0;
    int id_resource_soil = 1; 
//    int id_resource_sea  = 2;
    give_list_to_environment.add( new FluxGiveToEnvironment( id_resource_dump_site, 1.1 ) );
    
    give_list_to_environment.add( new FluxGiveToEnvironment( id_resource_soil, 1.0 ) );
    take_list_from_environment.add(new FluxTakeFromEnvironment( id_resource_soil, 2.0 ) );

//    give_list_to_environment.add( new FluxGiveToEnvironment( id_resource_sea, 0.5 ) );    
//    take_list_from_environment.add(new FluxTakeFromEnvironment( id_resource_sea, 1.0 ) );
  }
  
  void remove_from_take_list( int id ) {
    for (int j=0; j<take_list_from_human.size(); j++) {
      int id_of_jth_person = take_list_from_human.get(j).id_of_person;
      if ( id_of_jth_person == id ) {
        take_list_from_human.remove(j);
      }
    }
  }
  
  void become_farmer( int id_of_resource ) {
    FluxGiveToEnvironment giveTo = new FluxGiveToEnvironment( id_of_resource, 0.5 );

    FluxTakeFromEnvironment takeFrom = new FluxTakeFromEnvironment( id_of_resource, 2.0 );
    
    give_list_to_environment.add( giveTo );
    take_list_from_environment.add( takeFrom ); 
  }
}

class Human {
  Person[] person;

  Human () {
    person = new Person[POPULATION];
    for (int i=0; i<POPULATION; i++) {
      float default_life = 100;
      float random_x = random(width);
      float random_y = random(height);
      float x_with_separation = map( random_x, 0.0, float(width),  0.1*width,  0.9*width  );
      float y_with_separation = map( random_y, 0.0, float(height), 0.1*height, 0.9*height );
      PVector random_position = new PVector( x_with_separation, y_with_separation );
      person[i] = new Person( default_life, random_position );
    }
    
    person[0].become_farmer( 3 );
  }


  void draw() {
    for (int i=0; i<POPULATION; i++) {
      int ilife = int(person[i].life);
      if ( ilife > 0 ) {  
        if ( ilife > 255 ) ilife = 255;

        float x = person[i].position.x;
        float y = person[i].position.y;

        stroke( 200, 240, 200 );
        for (int j=0; j<person[i].take_list_from_environment.size(); j++) {
          FluxTakeFromEnvironment fluxFrom = person[i].take_list_from_environment.get(j);
          int resource_id = fluxFrom.id_of_resource;
          float xr = environment.resource[resource_id].position.x;
          float yr = environment.resource[resource_id].position.y;
          line( x, y, xr, yr);
        }

        //stroke( 0 );
        //for (int j=0; j<person[i].give_list_to_environment.size(); j++) {
        //  FluxGiveToEnvironment fluxTo = person[i].give_list_to_environment.get(j);
        //  int resource_id = fluxTo.id_of_resource;
        //  if ( resource_id == 0 ) continue;
        //  float xr = environment.resource[resource_id].position.x;
        //  float yr = environment.resource[resource_id].position.y;
        //  line( x, y, xr, yr);
        //}
        
        stroke( 0, 0, 255 );
        for (int j=0; j<person[i].give_list_to_human.size(); j++) {
          FluxGiveToHuman fluxTo = person[i].give_list_to_human.get(j);
          int person_id = fluxTo.id_of_person;
          float xr = human.person[person_id].position.x;
          float yr = human.person[person_id].position.y;
          line( x, y, xr, yr);
        }

        fill( 255 - ilife );
        stroke(0);
        ellipse( x, y, 10, 10 );
      }
    }
  }


  void connect_or_disconnect() {
    for (int i=0; i<POPULATION; i++) {
      float allowance = person[i].life - 220;
      if ( person[i].connection_counter == 0  && allowance > 0 ) {
        for ( int k=0; k<2; k++ ) { // give to targets
          int target = int( random( POPULATION ) );
          if ( target == i || person[target].life==0 ) continue;
          FluxGiveToHuman giveTo = new FluxGiveToHuman( target, 0.6 );
          FluxTakeFromHuman takeFrom = new FluxTakeFromHuman ( i, 0.8 ); 
          person[i].give_list_to_human.add(giveTo);
          person[target].take_list_from_human.add(takeFrom);
          person[i].connection_counter += 1;
        }
      }
      if ( person[i].connection_counter > 0  && allowance < 0 ) {
        for ( int j=0; j<person[i].give_list_to_human.size(); j++ ) {
          int target = person[i].give_list_to_human.get(j).id_of_person;
          person[target].remove_from_take_list(i);
          person[i].connection_counter -= 1;
          person[i].give_list_to_human.remove(j);
        }
      }
    }
  }

  
  void live_on() {    
    
    // Sometimes, a personn become a farmer.
    float probability = 0.01;
    if ( random(1.0) < probability ) {
      for (int i=0; i<POPULATION; i++) {
        float probability2 = 1.0 / POPULATION;
        if ( random(1.0) < probability2 ) {
          if ( person[i].life > 0 && person[i].connection_counter == 0 ) {
            person[i].become_farmer( 4 );
          }
        }
      }
    }

    // take from environment
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].take_list_from_environment.size(); j++) {
        FluxTakeFromEnvironment fluxFrom = person[i].take_list_from_environment.get(j);        
        person[i].life += fluxFrom.flux; 
      }
    }
    
    // take from human
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].take_list_from_human.size(); j++) {
        FluxTakeFromHuman fluxFrom = person[i].take_list_from_human.get(j);        
        person[i].life += fluxFrom.flux; 
      }
    }
    
    // upper limit
    for (int i=0; i<POPULATION; i++) {
      if ( person[i].life > 255 ) {
        person[i].life = 255;
      }
    }
    
    // give to environment
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].give_list_to_environment.size(); j++) {
        FluxGiveToEnvironment fluxTo = person[i].give_list_to_environment.get(j);       
        person[i].life -= fluxTo.flux; 
        if ( person[i].life < 0 ) {
          person[i].life = 0;
        }
      }
      
      if ( person[i].life < 0 ) {
        for (int j=0; j<person[i].give_list_to_environment.size(); j++) {
          person[i].give_list_to_environment.remove(j);
        }
        for (int j=0; j<person[i].take_list_from_environment.size(); j++) {
          person[i].take_list_from_environment.remove(j);
        }
        for (int j=0; j<person[i].give_list_to_human.size(); j++) {
          person[i].give_list_to_human.remove(j);
        }
        for (int j=0; j<person[i].take_list_from_human.size(); j++) {
          person[i].take_list_from_human.remove(j);
        }
      }
    }
    
    // give to human
    for (int i=0; i<POPULATION; i++) {
      for (int j=0; j<person[i].give_list_to_human.size(); j++) {
        if ( person[i].life > 0 ) {
          FluxGiveToHuman fluxTo = person[i].give_list_to_human.get(j);       
          person[i].life -= fluxTo.flux; 
          if ( person[i].life < 0 ) person[i].life = 0;
        }
      }
    }        
  }
  
  
  void rearrange_position() {
    for (int i=0; i<POPULATION; i++) {
      float x0 = person[i].position.x;
      float y0 = person[i].position.y;

      
      for (int j=0; j<person[i].take_list_from_human.size(); j++) {
        FluxTakeFromHuman fluxFrom = person[i].take_list_from_human.get(j);        
        int id = fluxFrom.id_of_person;
        float x1 = person[id].position.x;
        float y1 = person[id].position.y;
        //float distance = dist( x0, y0, x1, y1 );
        //if ( distance > height / 10 ) {
        //  float dx = x1 - x0;
        //  float dy = y1 - y0;
        //  float random_x = random(-0.2, 0.2);
        //  float random_y = random(-0.2, 0.2);
        //  person[i].position.x += (random_x + 0.05*dx/distance);
        //  person[i].position.y += (random_y + 0.05*dy/distance);
        //}
        
        float amp = 0.5 * person[i].life / 255.0;
        person[i].position.x += random( -amp/2, amp/2 );
        person[i].position.y += random( -amp/2, amp/2 );        
      }

      for (int j=0; j<person[i].take_list_from_environment.size(); j++) {
        FluxTakeFromEnvironment fluxFrom = person[i].take_list_from_environment.get(j);        
        int id = fluxFrom.id_of_resource;
        //float x1 = environment.resource[id].position.x;
        //float y1 = environment.resource[id].position.y;
        //float distance = dist( x0, y0, x1, y1 );
        //if ( distance > height / 10 ) {
        //  float dx = x1 - x0;
        //  float dy = y1 - y0;          
        //  float random_x = random(-0.2, 0.2);
        //  float random_y = random(-0.2, 0.2);
        //  person[i].position.x += (random_x + 0.05*dx/distance);
        //  person[i].position.y += (random_y + 0.05*dy/distance);
        //}
        person[i].position.x += random( -1.0, 1.0 );
        person[i].position.y += random( -1.0, 1.0);
        
      }
      
    }

  }
}
