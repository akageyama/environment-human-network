
void StepTime() 
{  
  //flow_q();
  //remove_connection_if_life_is_zero();
  //give_to_someone_if_rich_enough();
  //move_nodes_by_spring();
    
  
  timeCounter += 1;
  
  
  human.expand();
  human.shrink();
  human.live_on();  
  
 // human.rearrange_position();
  
  for (int i=0; i<POPULATION; i++) {
    if ( human.person[i].life > 0 ) {
      human.person[i].life -= 3;
println(" life[", i, "] = ", human.person[i].life );      
    }
  }
  println( "timeCounter = ", timeCounter );
  
    
}
