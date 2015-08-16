# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window.onPhotoUpload = ->
  file = event.fpfile
  img = $("<img>").prop("src", file.url)
  $(event.target).parent().append(img)