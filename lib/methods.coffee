Meteor.methods(
  addCategory: (name, parent) ->
    if not @userId
      throw new Meteor.Error('logged-out', 'You must be logged in to create a category')

    Categories.insert(
      name: name
      parent: parent
      creator: @
    )

  addProject: (name, parent) ->
    if not @userId
      throw new Meteor.Error('logged-out', 'You must be logged in to create a project')

    Projects.insert(
      name: name
      parent: parent
      creator: @
      cost: 0.00
      sponsored: 0.00
      finalCost: 0.00
    )

  updateProjectCost: (_id, cost, sponsored) ->
    if not @userId
      throw new Meteor.Error('logged-out', 'You must be logged in to update a project')

    Projects.update(_id,
      $set:
        cost: roundToCents(cost)
        sponsored: roundToCents(sponsored)
        finalCost: roundToCents(roundToCents(cost) - roundToCents(sponsored))
    )
    return roundToCents(cost) - roundToCents(sponsored)
)
