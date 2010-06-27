// ============
// = Includes =
// ============
if (Array.prototype.includes==null) Array.prototype.includes=function(item){ 
  var return_val = false;
  for (var i=0; i < this.length; i++) {
    if(this[i] == item){return_val = true; break;}
  };
  return return_val;
}


function parseAttr(string){
  var obj = {};
  $.each(string.split(':'), function(){
    var array = this.split('=');
    obj[array[0]] = array[1];
  });
  return obj;
}

function pad(item){
  switch(typeof(item)){
    case 'number': if(item > 9 || item < 0){return item}else{return "0" + item}; break;
  }
}

function number_to_currency(number){
  return "$" + Math.round(number * 100)/100;
}