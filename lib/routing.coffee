Router.configure(
  layoutTemplate: 'ApplicationLayout'
)

Router.onAfterAction(-> Tracker.afterFlush(->
    Foundation.init(document)
    $(document).foundation('topbar', 'reflow')
))

Router.plugin('ensureSignedIn', except: ['home'])

# Actual Routes
Router.route('/',
  name: 'home'
  fastRender: true
)

Router.route('/category',
  name: 'category-home'
  template: 'category'
  data: -> Categories.findOne('/')
  fastRender: true
)

Router.route('/category/:_id',
  name: 'category'
  data: -> Categories.findOne(@params._id)
  fastRender: true
)

Router.route('/project/:_id',
  name: 'project'
  data: -> Projects.findOne(@params._id)
  fastRender: true
)
