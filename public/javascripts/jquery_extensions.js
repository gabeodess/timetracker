// ============
// = Fuctions =
// ============
function currency_to_float(item){
  return parseFloat(item.replace("$", ""));
}

function number_to_currency(item){
  if(typeof(item) != 'number'){alert("Number expected in 'number_to_currency'.  Received " + typeof(item) + ".")}
  var integer = Math.floor(item);
  var decimal = Math.round((item - integer)*100)/100;
  var decimal_string = decimal == 0 ? "00" : [decimal.toString()[2], (decimal.toString()[3] || 0)].join("");
  return "$" + integer + "." + decimal_string;
}

// ============
// = Array =
// ============
if (Array.prototype.sum==null) Array.prototype.sum=function(){ 
  var return_val = 0;
  for (var i=0; i < this.length; i++) {
    return_val += this[i];
  };
  return return_val;
}

if (Array.prototype.includes==null) Array.prototype.includes=function(item){ 
  var return_val = false;
  for (var i=0; i < this.length; i++) {
    if(this[i] == item){return_val = true; break;}
  };
  return return_val;
}

if (Array.prototype.does_not_include==null) Array.prototype.does_not_include=function(item){ 
  return !this.includes(item);
}

if (Array.prototype.reject==null) Array.prototype.reject=function(item){ 
  var return_val = [];
  for (var i=0; i < this.length; i++) {
    if(this[i] != item){return_val.push(this[i])}
  };
  return return_val;
}

// ==========
// = jQuery =
// ==========
$.fn.disableSelect = function(){
  for (var i=0; i < this.length; i++) {
    this[i].onselectstart = function(){return false;}
  };
}

$.fn.map = function(my_function){
  // var original_item = this;
  // var array = new Array
  // for (var i=0; i < this.length; i++) {
  //   array.push(my_function($(original_item[i])));
  // }
  this.each(my_function);
  return array;
}


// ==========
// = String =
// ==========
if (String.prototype.apostrophe_escape==null) String.prototype.apostrophe_escape=function(){ 
  return this.replace(/'/g,"&#39;");
}



// =======
// = Map =
// =======
function map_attr(array, attr){
  var return_val = new Array();
  for (var i=0; i < array.length; i++) {
    return_val.push($(array[i]).attr(attr));
  };
  return return_val;
}