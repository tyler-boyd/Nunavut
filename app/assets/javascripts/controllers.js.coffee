module = angular.module('micrositeTemplateApp.controllers', [])

module.controller 'HomeCtrl',['$scope', ($scope)->

]

module.controller 'ContactCtrl',['$scope', ($scope)->

]

# in the controller "function declaration" we have to put ALL the "dependencies", however trivial.  So, if this controller calls ANYTHING 
# from the 'banana' service, then 'banana' HAS to be listed as a dependency here, otherwise angular won't find it and responds 
# with a message saying the service is undefined (even though it actually means the service is not declared to be linked to)
# A dependency in this context means that "this module depends on something existing".  In other words it means "USES"  - this module uses 
# modules a, b and c
# This is sort of like the old concept of including all link headers at the top of a program so that the linker can resolve them.  The
# list of names in the array that precede the actual parameter list are a kludge to try to get the system to be able minify this script,
# even though it would just be easier to zip it. 
# 
module.controller "ProductsIndexCtrl", [
  "$scope", "$modal", "ApiFactory", "$routeParams", "$location", "$q"
  ($scope, $modal, ApiFactory, $routeParams, $location, $q) ->
    cats = undefined
    lines = undefined
    $scope._ = _
    
    $scope.data = {
      # collection of general data about what is showing in the products panel
      query: $routeParams.query || ""
      currentPage: $routeParams.currentPage || 1
      sort: $routeParams.sort || "none"
      prices: {
        min: $routeParams.min_price || undefined,
        max: $routeParams.max_price || undefined
      }
    }

    $scope.sortdropdown = {visible: false}
    
    $scope.setDataSortFromDropdown = (sortOrder) ->
      $scope.data.sort = sortOrder
      $scope.sortdropdown.visible = false
      
    $scope.search = (query) ->
      $scope.selected_categories = _.select($scope.all_categories, (cat) ->
        cat.selected
      )
      $scope.selected_lines = _.select($scope.all_lines, (line) ->
        line.selected
      )
      
      ApiFactory.searchProducts(query, $scope.selected_categories, $scope.selected_lines, $scope.data.currentPage, $scope.data.sort,
                                $scope.data.prices.min, $scope.data.prices.max).then (result) ->

        # this "then" function executes when the asynchronous call to searchProducts returns - it's a promise, but really just an easier way of chaining a callback
        $scope.data.totalItems = result.total_items

        # here we actually return the data from the database to the scope...
        $scope.products = result.products
        
        $location.search "query", query
        $location.search "sort", $scope.data.sort
        $location.search "categories", _.pluck($scope.selected_categories, "name")
        $location.search "lines", _.pluck($scope.selected_lines, "name")
        $location.search "currentPage", $scope.data.currentPage
        $location.search "min_price", $scope.data.prices.min
        $location.search "max_price", $scope.data.prices.max

    $scope.$watch 'data.sort', (newVal, oldVal)->
      $scope.search($scope.data.query) if newVal != oldVal
      
    $scope.pageChange = ->
      $scope.search $scope.data.query

    $scope.last = (arr) ->
      _.last(arr)

    cats = $routeParams.categories
    lines = $routeParams.lines
    cats = [cats]  if typeof cats is "string"
    lines = [lines]  if typeof lines is "string"

    $scope.data.totalItems = $scope.data.currentPage * 24
    categories_promise = ApiFactory.getCategories()
    categories_promise.then (all_cats) ->
      if cats
        _.each all_cats, (cat) ->
          cat.selected = true  if _.contains(cats, cat.name)
      $scope.all_categories = all_cats

    lines_promise = ApiFactory.getLines()
    lines_promise.then (all_lines) ->
      if lines
        _.each all_lines, (line) ->
          line.selected = true  if _.contains(lines, line.name)
      $scope.all_lines = all_lines

    $q.all([categories_promise, lines_promise]).then () ->
      $scope.search $scope.search.query

    $scope.openProductModal = (product) ->
      modalInstance = $modal.open(
        templateUrl: 'partial/modal/product.html'
        controller: 'ProductModalCtrl'
        size: 'lg'
        resolve:
          product: ->
            product
      )
      modalInstance.result.then (item) ->
        $location.path('/kit')

    $scope.openCategoriesModal = ->
      modalInstance = $modal.open(
        templateUrl: "partial/modal/categories_filter.html"
        controller: "CategoriesFilterModalCtrl"
        size: "lg"
        resolve:
          categories: ->
            $scope.all_categories
      )
      modalInstance.result.then (categories) ->
        $scope.all_categories = categories
        $scope.search($scope.data.query)
      , () -> $scope.search($scope.data.query)


    $scope.openLinesModal = ->
      modalInstance = $modal.open(
        templateUrl: "partial/modal/lines_filter.html"
        controller: "LinesFilterModalCtrl"
        size: "lg"
        resolve:
          lines: ->
            $scope.all_lines
      )
      modalInstance.result.then ((lines) ->
        $scope.all_lines = lines
        $scope.search($scope.data.query)
      ), () ->
        $scope.search($scope.data.query)

    $scope.openPricesModal = ->
      $scope.data.prices = $scope.data.prices || {}
      modalInstance = $modal.open(
        templateUrl: "partial/modal/prices.html"
        controller: "PricesModalCtrl"
        size: "lg"
        resolve:
          prices: ->
            $scope.data.prices
      )
      modalInstance.result.then ((result) ->
        $scope.data.prices = result
        $scope.search($scope.data.query)
      ), (result) ->
        $scope.data.prices = result
        $scope.search($scope.data.query)

]

