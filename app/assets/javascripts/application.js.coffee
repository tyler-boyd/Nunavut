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
# SYSTEM files
#= require underscore
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require angular
#= require angular-route
#= require ui-bootstrap
#= require ui-bootstrap-showErrors
#= require restangular
#
# USER files
#= require controllers
#= require_tree ./controllers
#= require services
#= require directives
#= require filters
#= require support
#
# first create the main Angular application with a whole bunch of dependencies.  A lot of these are really the 
# same as the list above, which is used by sprockets to convert coffee files to javascript and to bundle it all up together - 
#
# The dependencies listed below are used by the Angular compiler to make sure it compiles in all the modules it needs to run the app
# Note that ui-bootstrap is also a _module_ and not just a js file - it has a lot of widgets in it, some of which might even work,
#
Application = angular.module('micrositeTemplateApp', [
    'ngRoute',
    'restangular',
    'ui.bootstrap',
    'ui.bootstrap.showErrors'
    'micrositeTemplateApp.services',
    'micrositeTemplateApp.directives',
    'micrositeTemplateApp.controllers',
    'micrositeTemplateApp.filters',
])

# Add some configuration - initialization really.  
# Set up which 
Application.config(['$routeProvider', '$httpProvider', ($routeProvider, $httpProvider) ->
  $httpProvider.defaults.useXDomain = true;
  delete $httpProvider.defaults.headers.common['X-Requested-With'];
  $routeProvider.when '/home', {templateUrl: 'partial/home.html', controller: 'HomeCtrl' }
  $routeProvider.when '/contact', {templateUrl: 'partial/contact.html', controller: 'ContactCtrl' }
  $routeProvider.when '/products', {templateUrl: 'partial/products.html', controller: 'ProductsIndexCtrl', reloadOnSearch: false }
  $routeProvider.when '/kit', {templateUrl: 'partial/kit.html', controller: 'KitCtrl'}
  $routeProvider.otherwise {redirectTo: '/home'}
])

Application.config(['RestangularProvider', '$httpProvider', (RestangularProvider, $httpProvider) ->
  RestangularProvider.setBaseUrl('https://promocatalyst.net/api');
  RestangularProvider.addResponseInterceptor (data, operation, what, url, response, deferred) ->
    if data.options
      if _.isString(data.options)
        data.all_options = JSON.parse data.options
      else
        data.all_options = data.options
    data
])

Application.run(['$rootScope', '$location', ($rootScope, $location) ->
  $rootScope.$on '$routeChangeStart', (event, next, current) ->
    window.setActive($location.path())
  window.catalog_id||=1
  window.microsite_id||=1
])

window.setActive = (path) ->
  $.each($('li[route]'), (i,el) ->
    $(el).removeClass('active')
    $(el).addClass('active') if path.match($(el).attr('route'))
  )

window.pricePer = (product, quantity) ->
  return unless product && quantity && product.quantities && product.quantities[0]
  revq = angular.copy(product.quantities).reverse()
  _.find(angular.copy(product.prices).reverse(), (price, index) -> quantity >= revq[index] )||product.prices[0]
  
window.totalPrice = (item) ->
  alert ('ping')
  item.quantity * window.pricePer(item.product, item.quantity)
