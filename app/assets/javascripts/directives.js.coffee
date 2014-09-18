module = angular.module('micrositeTemplateApp.directives', [])

module.directive 'formGroup' , ()->
    restrict: 'EA',
    transclude: true,
    scope: {},
    template: '<div class="form-group" show-errors ng-transclude></div>'

module.directive 'errors' , ()->
    restrict: 'A',
    scope: {
        errors: '='
    }
    template: '<div class="row" ng-show="errors"><div class="col-xs-12"><div class="alert alert-danger">' +
            '<ul><li ng-repeat="err in errors"> {{err}} </li></ul></div></div></div>'
module.directive 'formatter',  ($filter, $parse) ->
    {
        require: 'ngModel',
        link: (scope, element, attrs, ngModel) ->
            ngModel.$formatters.push (value) ->
                '$' + parseFloat(value).toFixed(2)
    }

module.directive 'inputGroup' , ()->
    {
        restrict: 'AE',
        scope: {
            for: '=',
            label: '@'
        },
        template: '<div class="form-group"><label class="col-lg-4 control-label" for="{{name}}">{{label}}</label><div class="col-lg-8"><input type="text" id="{{name}}" class="form-control" ng-model="for"></div></div>'
        link: (scope, element, attrs)->
            scope.name = attrs.for.replace(/\./g, '_')
    }
    
