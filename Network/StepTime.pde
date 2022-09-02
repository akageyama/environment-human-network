
void StepTime() 
{  
  //flow_q();
  //remove_connection_if_life_is_zero();
  //give_to_someone_if_rich_enough();
  //move_nodes_by_spring();
    
  
  timeCounter += 1;
  
  
  human.connect_or_disconnect();
  human.live_on();  
  
  human.rearrange_position();
  
  for (int i=0; i<POPULATION; i++) {
    if ( human.person[i].life > 0 ) {
//println(" life[", i, "] = ", human.person[i].life );      
      // human.person[i].life -= 1;
    }
  }
  println( "timeCounter = ", timeCounter );
  
    
}
