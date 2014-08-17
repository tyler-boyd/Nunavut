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
      ApiFactory.searchProducts(query, $scope.selected_categories, $scope.selected_lines, $scope.data.currentPage, $scope.data.sort,
                                $scope.data.prices.min, $scope.data.prices.max).then (result) ->
        $scope.data.totalItems = result.total_items
        $scope.products = result.products
        $location.search "query", query
        $location.search "sort", $scope.data.sort
        $location.search "categories", _.pluck($scope.selected_categories, "name")
        $location.search "lines", _.pluck($scope.selected_lines, "name")
        $location.search "currentPage", $scope.data.currentPage
        $location.search "min_price", $scope.data.prices.min
        $location.search "max_price", $scope.data.prices.max


    $scope.pageChange = ->
      $scope.search $scope.data.query

    $scope.last = (arr) ->
      _.last(arr)

    cats = $routeParams.categories
    lines = $routeParams.lines
    cats = [cats]  if typeof cats is "string"
    lines = [lines]  if typeof lines is "string"
    $scope.data = {
      query: $routeParams.query or ""
      currentPage: $routeParams.currentPage or 1
      sort: $routeParams.sort or "none"
      prices: {
        min: $routeParams.min_price || 0,
        max: $routeParams.max_price || undefined
      }
    }


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

    $scope.openPricesModal = ->
      $scope.data.prices = $scope.data.prices || {}
      modalInstance = $modal.open(
        templateUrl: "partials/modal/prices.html"
        controller: "PricesModalCtrl"
        size: "lg"
        resolve:
          prices: ->
            $scope.data.prices
      )
      modalInstance.result.then ((result) ->
        $scope.data.prices = result
      ), (result) ->
        $scope.data.prices = result

]

app.controller "CategoriesFilterModalCtrl", [
  "$scope"
  "$modalInstance"
  "categories"
  ($scope, $modalInstance, categories) ->
    $scope.development = false
    categories = _.select(categories, (cat) ->
      cat.super_category
    )
    $scope.groupsOf3 = (arr) ->
      ret = undefined
      ret = _.groupBy(arr, (val, index) ->
        Math.floor index / 3
      )

    $scope.search = (query) ->
      alph_sort = undefined
      grouped = undefined
      matching_categories = undefined
      ord_selected = undefined
      matching_categories = _.select($scope.categories, (cat) ->
        cat.name.match query
      )
      alph_sort = _.sortBy(matching_categories, "name")
      ord_selected = _.sortBy(alph_sort, (cat) ->
        cat.selected
      )
      grouped = $scope.groupsOf3(ord_selected)
      $scope._filtered_categories = grouped

    $scope.categories = categories
    $scope.filtered_categories = (query) ->
      return $scope._filtered_categories  if query is $scope.old_query
      if (query or "").length is 0
        $scope.search()
        $scope.old_query = query
      else
        $scope.search query
        $scope.old_query = query
      $scope._filtered_categories

    $scope._filtered_categories = undefined
    $scope.old_query = "notold"
    $scope.confirm = ->
      $modalInstance.close $scope.categories

    $scope.cancel = ->
      $modalInstance.dismiss()
]
app.controller "LinesFilterModalCtrl", [
  "$scope"
  "$modalInstance"
  "lines"
  ($scope, $modalInstance, lines) ->
    $scope.groupsOf3 = (arr) ->
      ret = undefined
      ret = _.groupBy(arr, (val, index) ->
        Math.floor index / 3
      )

    $scope.search = (query) ->
      alph_sort = undefined
      grouped = undefined
      matching_lines = undefined
      ord_selected = undefined
      matching_lines = _.select($scope.lines, (line) ->
        line.name.match query
      )
      alph_sort = _.sortBy(matching_lines, "name")
      ord_selected = _.sortBy(alph_sort, (line) ->
        line.selected
      )
      grouped = $scope.groupsOf3(ord_selected)
      $scope._filtered_lines = grouped

    $scope.lines = lines
    $scope.filtered_lines = (query) ->
      return $scope._filtered_lines  if query is $scope.old_query
      if (query or "").length is 0
        $scope.search()
        $scope.old_query = query
      else
        $scope.search query
        $scope.old_query = query
      $scope._filtered_lines

    $scope._filtered_lines = undefined
    $scope.old_query = "notold"
    $scope.confirm = ->
      $modalInstance.close $scope.lines

    $scope.cancel = ->
      $modalInstance.dismiss $scope.lines
]
app.controller "ProductModalCtrl", [
  "$scope"
  "product"
  "$modalInstance"
  ($scope, product, $modalInstance) ->
    $scope.development = false
    $scope.product = product
    $scope.close = ->
      $modalInstance.dismiss()
]
app.controller "PricesModalCtrl", [
  "$scope"
  "prices"
  "$modalInstance"
  ($scope, prices, $modalInstance) ->
    $scope.prices = prices
    $scope.close = ->
      $modalInstance.dismiss $scope.prices
]