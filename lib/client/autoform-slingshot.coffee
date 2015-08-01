SlingshotImages = new Meteor.Collection(null);

AutoForm.addInputType 'slingshotFileUpload',
  template: 'afSlingshot'
  valueOut: ->
		input = $('[file-input]')
    console.log($(@context))
    name = input.attr('file-input');
    console.log(name, input);
    images = SlingshotImages.find({field: name}).fetch()
    console.log(images)
    images
	valueConverters:
		string: (images)->
			images[0].downloadUrl
		stringArray: (images)->
      console.log images

      _.map images, (image)->
        image.downloadUrl
    objectArray: (images)->
      images
    object: (images)->
      imgs = {}
      for image in images
        structure[image.key || image.directive] = image
      imgs

refreshFileInput = (name)->
  callback = ->
    # id = $('.nav-pills[file-input="'+name+'"] > .active > a').attr('href')
    # value = $('.tab-content[file-input="'+name+'"] >' + id + '>div>input').val()
    # $('input[name="' + name + '"]').val(value)
    # console.log name
    value = $('input[name="' + name + '"]').val()
    Session.set 'fileUpload['+name+']', value
  setTimeout callback, 10

getIcon = (file)->
  if file
    file = file.toLowerCase()
    icon = 'file-o'
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

getTemplate = (file)->
  file = file.toLowerCase()
  template = 'fileThumbIcon'
  if file.indexOf('.jpg') > -1 || file.indexOf('.png') > -1 || file.indexOf('.gif') > -1
    template = 'fileThumbImg'
  template

clearFilesFromSession = ->
  _.each Session.keys, (value, key, index)->
    if key.indexOf('fileUpload') > -1
      Session.set key, ''

getCollection = (context) ->
  if typeof context.atts.collection == 'string'
    context.atts.collection = FS._collections[context.atts.collection] or window[context.atts.collection]
  return context.atts.collection

AutoForm.addHooks null,
  onSuccess: ->
    clearFilesFromSession()

destroyed = () ->
  name = @data.name
  Session.set 'fileUpload['+name+']', null

Template.afSlingshot.destroyed = destroyed
Template.afSlingshot_ionic.destroyed = destroyed

events =
  "change .file-upload": (e, t) ->
    files = e.target.files
    if typeof files is "undefined" || (files.length is 0) then return

    directive = t.data.atts.slingshotdirective
    uploader = new Slingshot.Upload(directive)

    uploadCallback = (file, slingshotdirective, key) ->
      if slingshotdirective
        uploader = new Slingshot.Upload(directive)
      else
        slingshotdirective = directive

      uploader.send file, (err, downloadUrl)->
        if err
          console.log err
        else
          name = $(e.target).attr('file-input')
          # t.$('input[name="' + name + '"]').val(downloadUrl)
          Session.set 'fileUploadSelected[' + name + ']', file.name
          SlingshotImages.upsert {field: name, directive: slingshotdirective}, {
            field: name
            key: key || '',
            directive: slingshotdirective
            filename: file.name
            downloadUrl: downloadUrl
          }
          refreshFileInput name

    if t.data.atts.onBeforeUpload
      for onBeforeUpload in t.data.atts.onBeforeUpload
        onBeforeUpload files, uploadCallback
    else
      _.each( files, (file)->
        uploadCallback file
      )


  'click .file-upload-clear': (e, t)->
    name = $(e.currentTarget).attr('file-input')
    # t.$('input[name="' + name + '"]').val('')
    Session.set 'fileUpload[' + name + ']', 'delete-file'
    SlingshotImages.remove({field: name});

Template.afSlingshot.events events
Template.afSlingshot_ionic.events events

helpers =
  images: ->
    _.map SlingshotImages.find({field: @atts.name}).fetch(), (image, i) ->
      downloadUrl: image.downloadUrl
      name: image.field + '.' + i
  collection: ->
    #getCollection(@)
  label: ->
    @atts.label or 'Choose file'
  removeLabel: ->
    @atts['removeLabel'] or 'Remove'
  accept: ->
    @atts.accept or '*'
  schemaKey: ->
    @atts['data-schema-key']
  fileUploadAtts: () ->
    t = Template.instance()
    atts = _.clone(t.data.atts)
    delete atts.collection
    delete atts.onBeforeUpload
    atts
  fileUpload: ->
    af = Template.parentData(1)._af

    name = @atts.name
    uploader = new Slingshot.Upload(@)

    if af &&  af.submitType == 'insert'
      doc = af.doc

    parentData = Template.parentData(0).value or Template.parentData(4).value
    if Session.equals('fileUpload['+name+']', 'delete-file')
      return null
    else if !!Session.get('fileUpload['+name+']')
      file = Session.get('fileUpload['+name+']')
    else if parentData
      file = parentData
    else
      return null

    if file != '' && file
      if file.length == 17
          # No subscription
          filename = Session.get 'fileUploadSelected[' + name + ']'
          obj =
            template: 'fileThumbIcon'
            data:
              filename: filename
              icon: getIcon filename
          return obj
      else
        filename = file
        src = filename
    if filename
      obj =
        template: getTemplate(filename)
        data:
          src: src
          filename: filename
          icon: getIcon(filename)
      obj
  fileUploadSelected: (name)->
    Session.get 'fileUploadSelected['+name+']'
  isUploaded: (name,collection) ->
    file = Session.get 'fileUpload['+name+']'
    isUploaded = false
    if file && file.length == 17
      #doc = window[collection].findOne({_id:file})
      isUploaded = doc.isUploaded()
    else
      isUploaded = true
    isUploaded

  getFileByName: (name,collection)->
    file = Session.get 'fileUpload['+name+']'
    if file && file.length == 17
      #doc = window[collection].findOne({_id:file})
      console.log doc
      doc
    else
      null

Template.afSlingshot.helpers helpers
Template.afSlingshot_ionic.helpers helpers
