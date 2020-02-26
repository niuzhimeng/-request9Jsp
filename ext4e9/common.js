function null2String(s){
  if(!s){
    return "";
  }
  return s;
}


function DateCheck(fromDate,fromTime,toDate,toTime,msg){

  var begin = new Date(fromDate.replace(/\-/g, "\/"));
  var end = new Date(toDate.replace(/\-/g, "\/"));
  if(fromTime != "" && toTime != ""){
    begin = new Date(fromDate.replace(/\-/g, "\/")+" "+fromTime+":00");
    end = new Date(toDate.replace(/\-/g, "\/")+" "+toTime+":00");
    if(fromDate!=""&&toDate!=""&&begin >end)
    {
      WfForm.showMessage(msg);
      return false;
    }
  }else{
    if(fromDate!=""&&toDate!=""&&begin >end)
    {
      WfForm.showMessage(msg);
      return false;
    }
  }
  return true;
}

function durationCheck(duration,msg){
  if(duration){
    if(parseFloat(duration) <= 0){
      WfForm.showMessage(msg);
      return false;
    }
  }else{
    WfForm.showMessage(msg);
    return false;
  }
  return true;
}