String statusFlagConversed(int statusFlag){
  if(statusFlag ==0){
    return 'Waitting';
  }
  else if(statusFlag == 1){
    return 'Active';
  }
  else if(statusFlag == 2){
    return 'Offer';
  }
  else{
    return 'Hired';
  }
}