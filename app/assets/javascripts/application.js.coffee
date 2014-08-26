# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require underscore
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require angular
#= require angular-route
#= require ui-bootstrap
#= require ui-bootstrap-showErrors
#= require restangular
#= require controllers
#= require_tree ./controllers
#= require services
#= require directives
#= require filters

myApp = angular.module('myApp', [
    'ngRoute',
    'myApp.services',
    'myApp.directives',
    'myApp.controllers',
    'myApp.filters',
    'restangular',
    'ui.bootstrap',
    'ui.bootstrap.showErrors'
]).
config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when '/home', {templateUrl: 'partial/home.html', controller: 'HomeCtrl' }
  $routeProvider.when '/products', {templateUrl: 'partial/products.html', controller: 'ProductsIndexCtrl', reloadOnSearch: false }
  $routeProvider.when '/kit', {templateUrl: 'partial/kit.html', controller: 'KitCtrl'}
  $routeProvider.otherwise {redirectTo: '/home'}
]).
config(['RestangularProvider', '$httpProvider', (RestangularProvider, $httpProvider) ->
  RestangularProvider.setBaseUrl('https://promocatalyst.net/api');
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if data.options
      if _.isString(data.options)
        data.all_options = JSON.parse data.options
      else
        data.all_options = data.options
    data
]).run(['$rootScope', '$location', ($rootScope, $location) ->
  $rootScope.$on '$routeChangeStart', (event, next, current) ->
    window.setActive($location.path())
])

window.setActive = (path) ->
  $.each($('li[route]'), (i,el) ->
    $(el).removeClass('active')
    $(el).addClass('active') if path.match($(el).attr('route'))
  )
window.catalog_id=1

window.pricePer = (product, quantity) ->
  return unless product && quantity && product.quantities && product.quantities[0]
  revq = angular.copy(product.quantities).reverse()
  _.find(angular.copy(product.prices).reverse(), (price, index) -> quantity >= revq[index] )||product.prices[0]
window.totalPrice = (item) -> item.quantity * window.pricePer(item.product, item.quantity)