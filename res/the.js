function manipulateSlide() {

  var slide = document.getElementById('slide');

  var bottom = document.createElement('div');
  bottom.innerHTML = "<div id='bottom'><a id='index' href='Inhaltsverzeichnis.html'>Inhalt</a></div>";

  slide.appendChild(bottom);
}
