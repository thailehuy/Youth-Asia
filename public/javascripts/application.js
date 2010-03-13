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