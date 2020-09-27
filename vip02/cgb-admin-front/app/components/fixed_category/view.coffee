categoryClass = require "category_list/view"
Store = require "extras/store"

class fixedCategory extends categoryClass
  sort =
    "backCategories":
      "maxLength": 4
      "url": Store.context + "/api/admin/backCategories"
      "container": ".back-category-list"
    "frontCategories":
      "maxLength": 3
      "url": Store.context + "/api/admin/frontCategories"
      "container": ".front-category-list"
  constructor: (@type)->
    @nextLever = "li.divide-li"
    @categorySearch = (".js-search-item")
    @categoryType = sort[@type]
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    $(".fixed-category").on("click", @nextLever, @nextCategory)
    $(".fixed-category").on("keyup", @categorySearch, @categorySearchItem)

  categorySearchItem: ->
    super()

  nextCategory: ->
    $(this).parents(".category").nextAll().remove()
    categoryData = $(@).data("category")
    $(@).addClass("selected")
    $(@).siblings().removeClass("selected")
    $(@).removeClass("mouseover")
    if categoryData.hasChild is true
      $.get Store.context + "/api/admin/backCategories/#{categoryData.id}/children", (data) ->
        categoryTemplate = popCategory = App.templates["_fixed_category"]({extras: {"level": parseInt(categoryData.level) + 1, "parentId": categoryData.id}, data: data})
        $(".fixed-category").append(categoryTemplate)
        if categoryData.level is (that.categoryType.maxLength - 1)
          $(".fixed-category .category-#{that.categoryType.maxLength}").addClass("category-last")


module.exports = fixedCategory
