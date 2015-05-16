Meteor.startup(->
  Categories.upsert('/',
    $set:
      name: 'CUAUV'
  )
)
