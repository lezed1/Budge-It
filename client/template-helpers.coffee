crumbs = ->
  category = Categories.findOne({_id: @parent})
  categories = [@]
  while (category?)
    categories.unshift(category)
    category = Categories.findOne({_id: category.parent})

  return categories

categoryFinalCost = (doc) ->
  catSum = Categories.find(parent: doc._id).fetch().map(categoryFinalCost).reduce(((x, y) -> x + y), 0)
  proSum = Projects.find(parent: doc._id).fetch().reduce(((x, y) -> x + y.finalCost), 0)
  return catSum + proSum

Template.category.helpers(
  categories: -> Categories.find({parent: @_id})
  projects: -> Projects.find({parent: @_id})
  nothingShown: -> !(Categories.findOne({parent: @_id}) or Projects.findOne({parent: @_id}))
  crumbs: crumbs
  categoryFinalCost: -> categoryFinalCost(@)
)

Template.project.helpers(crumbs: -> _.initial(crumbs.apply(@)))

# Focus input on modal open and clear input on modal close
Template.category.onRendered(->
  $categoryModal = @$('#addCategoryModal')
  $categoryName = @$('#category-name')
  $projectModal = @$('#addProjectModal')
  $projectName = @$('#project-name')

  $categoryModal.on('closed.fndtn.reveal', -> $categoryName.val(''))
  $categoryModal.on('opened.fndtn.reveal', -> $categoryName.focus())
  $projectModal.on('closed.fndtn.reveal', -> $projectName.val(''))
  $projectModal.on('opened.fndtn.reveal', -> $projectName.focus())
)

Template.addCategory.events(
  'submit form': (e) ->
    name = $(e.target).find('#category-name').val()
    Meteor.call('addCategory', name, @_id)

    $('#addCategoryModal').foundation('reveal', 'close')
    return false
)

Template.addProject.events(
  'submit form': (e) ->
    name = $(e.target).find('#project-name').val()
    Meteor.call('addProject', name, @_id)

    $('#addProjectModal').foundation('reveal', 'close')
    return false
)

Template.updateProject.events(
  'change form': (e) ->
    cost = roundToCents($('#cost').val())
    sponsored = roundToCents($('#sponsored').val())
    $('#cost').val(cost)
    $('#sponsored').val(sponsored)
    $('#finalCost').text(roundToCents(cost - sponsored))

  'submit form': (e) ->
    cost = roundToCents($('#cost').val())
    sponsored = roundToCents($('#sponsored').val())
    Meteor.call('updateProjectCost', @_id, cost, sponsored)

    $('#updateProjectModal').foundation('reveal', 'close')
    return false
)
