app = angular.module('myApp.controllers')

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