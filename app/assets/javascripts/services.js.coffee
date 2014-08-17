app = angular.module('myApp.services', [])

app.factory 'ApiFactory', ['Restangular', (Restangular) ->
  {
    searchProducts: (query, categories, suppliers, page, sort, min_price, max_price) ->
      params = {
        query: query,
        page: page
      };
      params.sort = sort.toLowerCase()
      if sort == "Price (High)"
        params.sort = "price"
      if sort == "Price (Low)"
        params.sort = "-price"
      params.min_price = min_price if min_price
      params.max_price = max_price if max_price
      params.categories = JSON.stringify(_.map categories, (cat) -> cat.name) if categories
      params.lines = JSON.stringify(_.map suppliers, (sup) -> sup.name) if suppliers
      params.catalog_id = window.catalog_id
      Restangular.one('products').get(params)
    , getProduct: (product_id) ->
      Restangular.one('products', product_id).get()
    , getCategories: () ->
      Restangular.all('categories').getList()
    , getSuppliers: () ->
      Restangular.all('suppliers').getList()
    , getLines: () ->
      Restangular.all('lines').getList()
    , getOrganization: (id) ->
      Restangular.one('organizations', id).get()
  }
]
