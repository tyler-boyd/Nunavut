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
      params.min_net_price = min_net_price if min_net_price
      params.max_net_price = max_net_price if max_net_price
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

app.factory 'KitStore', ['$window', ($window) ->
  {
    _val: JSON.parse($window.localStorage.getItem('kit')) || {items: []}
    save: () -> $window.localStorage.setItem('kit', JSON.stringify(this._val))
    reset: () -> this._val = JSON.parse($window.localStorage.getItem('kit'))
    kit: () -> this._val
    addItem: (item) ->
      this._val.items ||= []
      if this._val.items.length == 0
        item.id = 1
      else
        item.id = this._val.items[this._val.items.length-1].id+1
      this._val.items.push item
    removeItem: (item) ->
      this._val.items ||= []
      this._val.items = _.select(this._val.items, (this_item) -> this_item.id != item.id)
  }
]

app.factory 'ArtworkStore', ['$window', '$q', ($window, $q) ->
  {
    initialized: false
    error: undefined
    db: null
    dbName: 'artworkDB'
    ensureInitialized: () ->
      promise = $q.defer()
      artstore = this
      promise.reject(this.error) if this.error
      if artstore.initialized
        promise.resolve(this.db)
      else
        artstore.initialize().then (db) ->
          promise.resolve(db)
      promise.promise
    initialize: () ->
      artstore = this
      promise = $q.defer()
      request = window.indexedDB.open(this.dbName, 1)
      request.onerror = (event) ->
        artstore.error = request.error
        promise.reject(artstore.error)
      request.onsuccess = (event) ->
        artstore.db = request.result
        artstore.db.onerror = (e) -> alert "Database error: " + e.target.errorCode
        promise.resolve(artstore.db)
      request.onupgradeneeded = (event) ->
        db = event.target.result
        objectStore = db.createObjectStore('artworks', { keyPath: 'id' })
        objectStore.createIndex('id', 'id', {unique: true})
      return promise.promise
    getArtwork: (id) ->
      promise = $q.defer()
      this.ensureInitialized().then (db) ->
        request = db.transaction('artworks', 'readonly').objectStore('artworks').get(id)
        request.onerror = (event) ->
          promise.reject("Database error: " + event.target.errorCode)
        request.onsuccess = (event) ->
          promise.resolve(request.result)
      return promise.promise
    createArtwork: (artwork) ->
      promise = $q.defer()
      this.ensureInitialized().then (db) ->
        transaction = db.transaction(['artworks'], 'readwrite')
        request = transaction.objectStore('artworks').add(artwork)
        ret = {}
        request.onsuccess = (e) ->
          ret.ret = e.target.result
        transaction.oncomplete = (e) ->
          promise.resolve(ret.ret)
        transaction.onerror = (e) ->
          promise.reject(e.target.errorCode)
      return promise.promise
  }
]