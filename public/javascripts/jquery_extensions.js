// ============
// = Fuctions =
// ============
function currency_to_float(item){
  return parseFloat(item.replace("$", "").replace(/,/g, ""));
}

function number_to_currency(item){
  if(typeof(item) != 'number'){alert("Number expected in 'number_to_currency'.  Received " + typeof(item) + ".")}
  var integer = Math.floor(item);
  var decimal = Math.round((item - integer)*100)/100;
  var decimal_string = decimal == 0 ? "00" : [decimal.toString()[2], (decimal.toString()[3] || 0)].join("");
  
  var divby3 = integer.toString().length/3;
  var leftovers = divby3 - Math.ceil(divby3);
  var comma_count = leftovers > 0 ? divby3 : (divby3 - 1);
  
  var length = integer.toString().length
  var old_integer_string = integer.toString();
  var integer_string = "";
  var j = 1;
  for (var i = length - 1; i >= 0; i--){
    if(j == 4){
      integer_string = old_integer_string[i] + "," + integer_string;
      j = 1;
    }else{
      integer_string = old_integer_string[i] + integer_string;
    }
    j++;
  };
  
  return "$" + integer_string + "." + decimal_string;
}

// ============
// = Array =
// ============
if (Array.prototype.detect==null) Array.prototype.detect=function(my_function){ 
  var return_val = null;
  if(typeof(my_function) == 'function'){
    for (var i=0; i < this.length; i++) {
      var item = this[i];
      if(my_function(item)){
        return item;
      }
    };
  }else{
    for (var i=0; i < this.length; i++) {
      var item = this[i];
      if(item == my_function){
        return item;
      }
    };
  }
  
  return null;
}

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

$.fn.sum = function(){
  var sum = 0;
  for (var i=0; i < this.length; i++) {
    var num = parseFloat(this[i]) || 0;
    sum += num;
  };
  return sum;
}

// ==========
// = String =
// ==========
if (String.prototype.apostrophe_escape==null) String.prototype.apostrophe_escape=function(){ 
  return this.replace(/'/g,"&#39;");
}

if (String.prototype.reverse==null) String.prototype.reverse=function(){ 
  var new_string = "";
  for (var i = this.length - 1; i >= 0; i--){
    new_string += this[i];
  };
  return new_string
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