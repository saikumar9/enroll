SecurityQuestion =
  Init: ->
    @selectFirstSecurityQuestion()
    @selectSecondSecurityQuestion()
    @selectThirdSecurityQuestion()

  selectFirstSecurityQuestion: ->
    $(document).on 'change', '.security-question-select-1', ->
      select1 = $(@).val()
      select2 = $('.security-question-select-2').val()
      select3 = $('.security-question-select-3').val()
      if(select1 !='')
        params1 = [select1, select3]
        $('.question-wrapper-2').load("/users/filter?question_ids=#{params1}&index=2&selected=#{select2}")
        params2 = [select1, select2]
        $('.question-wrapper-3').load("/users/filter?question_ids=#{params2}&index=3&selected=#{select3}")

  selectSecondSecurityQuestion: ->
    $(document).on 'change', '.security-question-select-2', ->
      select1 = $('.security-question-select-1').val()
      select2 = $(@).val()
      select3 = $('.security-question-select-3').val()

      if(select2 !='')
        params1 = [select2, select3]
        $('.question-wrapper-1').load("/users/filter?question_ids=#{params1}&index=1&selected=#{select1}")
        params2 = [select2, select1]
        $('.question-wrapper-3').load("/users/filter?question_ids=#{params2}&index=3&selected=#{select3}")

  selectThirdSecurityQuestion: ->
    $(document).on 'change', '.security-question-select-3', ->
      select1 = $('.security-question-select-1').val()
      select2 = $('.security-question-select-2').val()
      select3 = $(@).val()

      if(select3 !='')
        params1 = [select3, select2]
        $('.question-wrapper-1').load("/users/filter?question_ids=#{params1}&index=1&selected=#{select1}")
        params2 = [select3, select1]
        $('.question-wrapper-2').load("/users/filter?question_ids=#{params2}&index=2&selected=#{select2}")

$ ->
  SecurityQuestion.Init()