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

    $scope.pricePer = (product, quantity) ->
      window.pricePer(product, quantity)
    $scope.totalPrice = (item) ->
      window.totalPrice(item)
]