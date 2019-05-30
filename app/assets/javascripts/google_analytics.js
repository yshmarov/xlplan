/*global gtag*/

document.addEventListener('turbolinks:load', function(event) {
  if (typeof gtag === 'function') {
    gtag('config', 'UA-141138860-1', {
      'page_location': event.data.url
    })
  }
})