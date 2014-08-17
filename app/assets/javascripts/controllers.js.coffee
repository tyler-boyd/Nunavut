app = angular.module('myApp.controllers', [])

app.controller 'HomeCtrl',['$scope', ($scope)->
  
]

app.controller "ProductsIndexCtrl", [
  "$scope", "$modal", "ApiFactory", "$routeParams", "$location",
  ($scope, $modal, ApiFactory, $routeParams, $location) ->
    cats = undefined
    lines = undefined
    $scope._ = _
    $scope.search = (query) ->
      $scope.selected_categories = _.select($scope.all_categories, (cat) ->
        cat.selected
      )
      $scope.selected_lines = _.select($scope.all_lines, (line) ->
        line.selected
      )
      ApiFactory.searchProducts(query, $scope.selected_categories, $scope.selected_lines, $scope.data.currentPage, $scope.data.sort).then (result) ->
        $scope.data.totalItems = result.total_items
        $scope.products = result.products
        $location.search "query", query
        $location.search "sort", $scope.data.sort
        $location.search "categories", _.pluck($scope.selected_categories, "name")
        $location.search "lines", _.pluck($scope.selected_lines, "name")
        $location.search "currentPage", $scope.data.currentPage


    $scope.pageChange = ->
      $scope.search $scope.data.query

    cats = $routeParams.categories
    lines = $routeParams.lines
    cats = [cats]  if typeof cats is "string"
    lines = [lines]  if typeof lines is "string"
    $scope.data =
      query: $routeParams.query or ""
      currentPage: $routeParams.currentPage or 1
      sort: $routeParams.sort or "none"

    $scope.data.totalItems = $scope.data.currentPage * 24
    ApiFactory.getCategories().then (all_cats) ->
      if cats
        _.each all_cats, (cat) ->
          cat.selected = true  if _.contains(cats, cat.name)

      $scope.all_categories = all_cats
      ApiFactory.getLines().then (all_lines) ->
        if lines
          _.each all_lines, (line) ->
            line.selected = true  if _.contains(lines, line.name)

        $scope.all_lines = all_lines
        $scope.search $scope.search.query


    $scope.openCategoriesModal = ->
      modalInstance = undefined
      modalInstance = $modal.open(
        templateUrl: "partials/modal/categories_filter.html"
        controller: "CategoriesFilterModalCtrl"
        size: "lg"
        resolve:
          categories: ->
            $scope.all_categories
      )
      modalInstance.result.then (categories) ->
        $scope.all_categories = categories


    $scope.openLinesModal = ->
      modalInstance = undefined
      modalInstance = $modal.open(
        templateUrl: "partials/modal/lines_filter.html"
        controller: "LinesFilterModalCtrl"
        size: "lg"
        resolve:
          lines: ->
            $scope.all_lines
      )
      modalInstance.result.then (lines) ->
        $scope.all_lines = lines

]