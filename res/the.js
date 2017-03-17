function manipulateSlide(opts) {


  var slide = document.getElementById('slide');

  var bottom = document.createElement('div');

  var htmlText = "<div id='bottom'>";
  htmlText += "<a href='index.html'>Inhalt</a>";


  if (opts.next) {
    htmlText += " → <a href='" + opts.next[0] + "'>" + opts.next[1] + "</a>";
  }
  
  htmlText += "</div>";
  bottom.innerHTML = htmlText;

  slide.appendChild(bottom);
}
