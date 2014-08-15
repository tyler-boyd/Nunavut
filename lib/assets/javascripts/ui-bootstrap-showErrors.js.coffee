angular.module('ui.bootstrap.showErrors', [])
  .directive 'showErrors', ($timeout) ->

    linkFn = (scope, el, attrs, formCtrl) ->
      $timeout(() ->
        blurred = false
        inputEl   = el[0].querySelector("[name]")
        inputNgEl = angular.element(inputEl)
        inputName = inputNgEl.attr('name')
        errorMap = {
          "required": "Can't be blank!",
          "minlength": "Too short!",
          "maxlength": "Too long!"
        }
        unless inputName
          throw "show-errors element has no child input elements with a 'name' attribute"
        inputNgEl.parent().append('<span class="error ng-hide"></span>')
        errorEl = inputNgEl.siblings()

        inputNgEl.bind 'blur', ->
          blurred = true
          el.toggleClass 'has-error', formCtrl[inputName].$invalid
          errorEl.toggleClass 'ng-hide', !formCtrl[inputName].$invalid
          errorEl.text(errorMap[_.select(_.pairs(formCtrl[inputName].$error), (pair)->pair[1]==true)[0][0]]) # Retrieves key from errorMap
        scope.$watch ->
          formCtrl[inputName].$invalid
        , (invalid) ->
          return if !blurred && invalid
          errorEl.toggleClass 'ng-hide', !invalid
          el.toggleClass 'has-error', invalid
          errorEl.text(errorMap[_.select(_.pairs(formCtrl[inputName].$error), (pair)->pair[1]==true)[0][0]]) # Retrieves key from errorMap

        scope.$on 'show-errors-check-validity', ->
          el.toggleClass 'has-error', formCtrl[inputName].$invalid
          errorEl.toggleClass 'ng-hide', !formCtrl[inputName].$invalid
          errorEl.text(errorMap[_.select(_.pairs(formCtrl[inputName].$error), (pair)->pair[1]==true)[0][0]]) # Retrieves key from errorMap

        scope.$on 'show-errors-reset', ->
          $timeout ->
            # want to run this after the current digest cycle
            el.removeClass 'has-error'
            errorEl.addClass 'ng-hide'
            blurred = false
          , 0, false
      , 0)


    {
      restrict: 'A'
      require: '^form'
      compile: (elem, attrs) ->
        unless elem.hasClass 'form-group'
          throw "show-errors element does not have the 'form-group' class"
        linkFn
    }