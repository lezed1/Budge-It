root = window ? @
root.Categories = new Mongo.Collection("Categories")
root.Projects = new Mongo.Collection("Projects")

Categories.deny(
  insert: (userId, doc) -> doc._id == '/'
  update: (userId, doc) -> doc._id == '/'
  remove: (userId, doc) -> doc._id == '/'
)
