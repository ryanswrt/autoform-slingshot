SlingshotAutoformFileCache = new Meteor.Collection(null);

AutoForm.addInputType 'slingshotFileUpload',
  template: 'afSlingshot'
  valueOut: ->
    field = $(@context).data('schema-key')
    images = SlingshotAutoformFileCache.find({field: field}).fetch()
    images
  valueConverters:
    string: (images)->
      images[0].src

    stringArray: (images)->
      imgs = _.map( images, (image)-> image.src )
      imgs

# clearFilesFromCache = ->
#   console.log(£)
#   _.each Session.keys, (value, key, index)->
#     if key.indexOf('fileUpload') > -1
#       Session.set key, ''

getCollection = (context) ->
  if typeof context.atts.collection == 'string'
    context.atts.collection = FS._collections[context.atts.collection] or window[context.atts.collection]
  return context.atts.collection

getTemplate = (filename, parentView) ->
  if filename
    filename = filename.toLowerCase()
    template = 'fileThumbIcon' + (if parentView.name.indexOf('_ionic') > -1 then '_ionic' else '')
    if filename.indexOf('.jpg') > -1 || filename.indexOf('.png') > -1 || filename.indexOf('.gif') > -1
      template = 'fileThumbImg'
    template

AutoForm.addHooks null,
  onSuccess: ->
    clearFilesFromCache()

destroyed = () ->
  name = @data.name

Template.afSlingshot.destroyed = destroyed
Template.afSlingshot_ionic.destroyed = destroyed

uploadWith = (directive, files, name, key) ->
  if typeof directive == 'string'
    directiveName = directive
  else if typeof directive == 'object'
    if !directive.directive
      console.error 'Missing directive in ' + key, directive
    directiveName = directive.directive
    if directive.onBeforeUpload
      onBeforeUpload = directive.onBeforeUpload

  uploader = new Slingshot.Upload(directiveName)

  uploadCallback = (file) ->
    src = ''
    if file.type.indexOf('image') == 0
      urlCreator = window.URL or window.webkitURL;
      src = urlCreator.createObjectURL( file );

    # Add a placeholder for the upload with a Blob data URI, aka Optimistic UI.
    SlingshotAutoformFileCache.upsert {field: name, directive: directiveName}, {
      field: name
      key: key or ''
      directive: directiveName
      filename: file.name,
      src: src
      uploaded: false
    }
    Meteor.defer =>
      uploader.send file, (err, src) ->
        if err
          console.error err
        else
          # Update the status and src of the placeholder for the upload.
          SlingshotAutoformFileCache.upsert {field: name, directive: directiveName}, {$set: {
            src: src
            filename: file.name
            uploaded: true
          }}

  async.map(
    files
    , (file, cb) ->
      if onBeforeUpload
        onBeforeUpload file, uploadCallback
      else
        uploadCallback file
    , (err, results) ->
      if err
        console.error err
      else
        console.log('all done', results)
  )

events =
  "change .file-upload": (e, t) ->
    files = e.target.files
    if typeof files is "undefined" || (files.length is 0) then return

    # Support single and multiple directives.
    directives = t.data.atts.slingshotdirective;
    name = $(e.target).attr('file-input')

    # If single directive upload.
    if typeof directives == 'string'
      uploadWith directives, files, name

    # If singe directive as object.
    else if typeof directives == 'object' and 'directive' of directives
      uploadWith directives, files, name

    # If multiple directive upload with keys.
    else if typeof directives == 'object'
      _.each directives, (directive, key) ->
        uploadWith directive, files, name, key

  'click .file-upload-clear': (e, t)->
    name = $(e.currentTarget).attr('file-input')
    SlingshotAutoformFileCache.remove({field: name});

Template.afSlingshot.events events
Template.afSlingshot_ionic.events events

helpers =
  # collection: ->
  #   #getCollection(@)
  label: ->
    @atts.label or 'Choose file'
  removeLabel: ->
    @atts['removeLabel'] or 'Remove'
  accept: ->
    @atts.accept or '*'
  schemaKey: ->
    @atts['data-schema-key']

  fileUpload: ->
    t = Template.instance()
    select =
      field: @atts.name
    # Allow selection of the directive for the thumbnail by key.
    if @atts.thumbnail
      select.key = @atts.thumbnail
    file = SlingshotAutoformFileCache.findOne(select)
    if file
      data: file
      template: getTemplate file.filename, t.view

Template.afSlingshot.helpers helpers
Template.afSlingshot_ionic.helpers helpers

Template.fileThumbIcon.helpers
  icon: ->
    if @filename
      file = @filename.toLowerCase()
      icon = 'document'
      if file.indexOf('youtube.com') > -1
        icon = 'youtube'
      else if file.indexOf('vimeo.com') > -1
        icon = 'vimeo-square'
      else if file.indexOf('.pdf') > -1
        icon = 'file-pdf-o'
      else if file.indexOf('.doc') > -1 || file.indexOf('.docx') > -1
        icon = 'file-word-o'
      else if file.indexOf('.ppt') > -1
        icon = 'file-powerpoint-o'
      else if file.indexOf('.avi') > -1 || file.indexOf('.mov') > -1 || file.indexOf('.mp4') > -1
        icon = 'file-movie-o'
      else if file.indexOf('.png') > -1 || file.indexOf('.jpg') > -1 || file.indexOf('.gif') > -1 || file.indexOf('.bmp') > -1
        icon = 'file-image-o'
      else if file.indexOf('http://') > -1 || file.indexOf('https://') > -1
        icon = 'link'
      icon

Template.fileThumbIcon_ionic.helpers
  filename: ->
    filename = @filename
    if filename.length > 25
      filename = filename.slice(0, 25) + '...'
    filename
  icon: ->
    if @filename
      file = @filename.toLowerCase()
      icon = 'file-o'
      if file.indexOf('youtube.com') > -1
        icon = 'social-youtube'
      else if file.indexOf('vimeo.com') > -1
        icon = 'social-vimeo'
      else if file.indexOf('.pdf') > -1
        icon = 'document-text'
      else if file.indexOf('.doc') > -1 || file.indexOf('.docx') > -1
        icon = 'document-text'
      else if file.indexOf('.ppt') > -1
        icon = 'document'
      else if file.indexOf('.avi') > -1 || file.indexOf('.mov') > -1 || file.indexOf('.mp4') > -1
        icon = 'ios-videocam-outline'
      else if file.indexOf('.png') > -1 || file.indexOf('.jpg') > -1 || file.indexOf('.gif') > -1 || file.indexOf('.bmp') > -1
        icon = 'image'
      else if file.indexOf('http://') > -1 || file.indexOf('https://') > -1
        icon = 'link'
      icon
