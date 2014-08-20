app = angular.module('myApp.controllers')

app.controller 'KitCtrl',
[
  '$scope', 'ApiFactory', '$modal', 'KitStore', 'ArtworkStore',
  ($scope, ApiFactory, $modal, KitStore, ArtworkStore) ->
    $scope.kit = KitStore.kit()
    $scope.addItem = (item) ->
      KitStore.addItem(item)
    $scope.save = () -> KitStore.save()
    $scope.reset = () -> $scope.kit = KitStore.reset()
    $scope.getArtwork = (id) ->
      ArtworkStore.getArtwork(id).then (artwork) ->
        $scope.artwork = artwork
    $scope.createArtwork = (artwork) ->
      ArtworkStore.createArtwork(artwork)
    $scope.artworkStore = ArtworkStore

    $scope.pricePer = (product, quantity) ->
      return unless product && quantity && product.quantities && product.quantities[0]
      revq = angular.copy(product.quantities).reverse()
      _.find(angular.copy(product.prices).reverse(), (price, index) -> quantity >= revq[index] )||product.prices[0]
    $scope.totalPrice = (item) ->
      item.quantity * $scope.pricePer(item.product, item.quantity)
]