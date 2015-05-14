Template.category.helpers(
  categories: -> Categories.find({parent: @_id})
  crumbs: ->
    category = Categories.findOne({_id: @parent})
    categories = []
    while (category?)
      categories.unshift(category)
      category = Categories.findOne({_id: category.parent})

    return categories
)

# Clear category name on modal close
Template.category.onRendered(->
  $modal = @$('#addCategoryModal')
  $categoryName = @$('#category-name')
  $modal.on('closed.fndtn.reveal', -> $categoryName.val(''))
  $modal.on('opened.fndtn.reveal', -> $categoryName.focus())
)

Template.addCategory.events(
  'submit form': (e) ->
    name = $(e.target).find('#category-name').val()
    Categories.insert(
      name: name
      parent: @_id
    )

    $('#addCategoryModal').foundation('reveal', 'close')
    return false
)
