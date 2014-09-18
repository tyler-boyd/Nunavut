#
# support files for general global functions/services
#

directives = angular.module('micrositeTemplateApp.directives')     # think about how to make this application independent

directives.directive "dropdownlist", ["$document", "$window", ($document, $window) ->
  {
    transclude: true
    template: "<div class='dropdownStyle' ng-transclude><!-- With ng-transclude (and transclude: true) the existing element is put in this place --></div>" 
    
    link: (scope, elm, attrs) ->
      # this is really $scope

      dropdownname=attrs["dropdownname"]
      
      $window.onclick = (event) ->
        t = event.target
        x=""
        loop
          x = t.tagName
          x = x.toUpperCase()
          break if (x is "BODY")
          return false if x is "DROPDOWNLIST" or x is "DROPDOWN"
          t = t.parentNode
          break if (t is null)
        x = 'scope.' + dropdownname + '.visible = false'
        eval(x)
        console.log (dropdownname)
        scope.$apply()
        return true
  }  
]
