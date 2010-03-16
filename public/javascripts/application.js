function htmlentities(txt) {
  var i,tmp,ret='';
  for(i=0; i < txt.length; i++) {
    tmp = txt.charCodeAt(i);
    if( (tmp > 47 && tmp < 58) || (tmp > 62 && tmp < 127) ) {
      ret += txt.charAt(i);
    } else{
      ret += "&#" + tmp + ";";
    }
  }
  return ret;
}

function show_more_info_popup(){
    alert("Who? What? Where? When? Why?");
}

function show_info(index){
    $('must_know_1').hide();
    $('must_know_2').hide();
    $('must_know_3').hide();
    $('must_know_4').hide();
    $('must_know_' + index).show();
}