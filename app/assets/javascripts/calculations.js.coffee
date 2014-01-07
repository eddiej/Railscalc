# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  calculator.setupForm()  

calculator =
  setupForm: ->
    $('input[type=text]').on 'input', ->
      $('input[type=submit]').attr('disabled', !calculator.validInputs() )
         
    $('form').submit ->
      $('input[type=submit]').attr('disabled', true) 
      
    $('form').on "ajax:success", (evt, data) ->
      $('textarea').val(data) 
      $('input[type=submit]').attr('disabled', false) 
    
      
      
  validInputs: ->
    valid = true
    $('input[type=text]').each ->
      data = $(this).val()
      if !( !isNaN(parseFloat(data)) && (data > 0 && data <= 100) && (data%1==0) )
        valid = false
        return
    valid
    

    