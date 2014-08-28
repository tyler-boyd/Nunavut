app = angular.module('myApp.controllers')

app.controller 'KitCtrl',
[
  '$scope', 'ApiFactory', '$modal', 'KitStore', 'ArtworkStore',
  ($scope, ApiFactory, $modal, KitStore, ArtworkStore) ->
    $scope.kit = KitStore.kit()
    $scope.addItem = (item) ->
      KitStore.addItem(item)
    $scope.removeItem = (item) ->
      KitStore.removeItem(item)
    $scope.save = () -> KitStore.save()
    $scope.reset = () -> $scope.kit = KitStore.reset()
    $scope.getArtwork = (id) ->
      ArtworkStore.getArtwork(id).then (artwork) ->
        $scope.artwork = artwork
    $scope.createArtwork = (artwork) ->
      ArtworkStore.createArtwork(artwork)
    $scope.artworkStore = ArtworkStore

    $scope.submitKit = () ->
      ApiFactory.submitKit($scope.kit).then (kit) ->
        if kit.errors.length == 0
          KitStore.deleteAll()
          alert 'Quote Request successfully submitted'
        else
          $scope.kit.errors = kit.errors

    $scope.pricePer = (product, quantity) ->
      window.pricePer(product, quantity)
    $scope.totalPrice = (item) ->
      window.totalPrice(item)
    $scope.total_price = () ->
      _.inject($scope.kit.items, (carry, item) ->
        carry + $scope.totalPrice(item)
      , 0)
]