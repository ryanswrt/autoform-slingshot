AutoForm.addInputType 'slingshotFileUpload', {
  template: 'afSlingshot'
}

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

Template.afSlingshot.destroyed = () ->
  name = @data.name
  Session.set 'fileUpload['+name+']', null

Template.afSlingshot.events
  "change .file-upload": (e, t) ->
    files = e.target.files
    console.log(t.data)
    uploader = new Slingshot.Upload(t.data.atts.slingshotdirective)
    uploader.send event.target.files[0], (err, downloadUrl)->
      if err
        console.log err
      else
        name = $(e.target).attr('file-input')
        # console.log $(e.target)
        # console.log fileObj
        $('input[name="' + name + '"]').val(downloadUrl)
        Session.set 'fileUploadSelected[' + name + ']', files[0].name
        # console.log fileObj
        refreshFileInput name
  'click .file-upload-clear': (e, t)->
    name = $(e.currentTarget).attr('file-input')
    $('input[name="' + name + '"]').val('')
    Session.set 'fileUpload[' + name + ']', 'delete-file'

Template.afSlingshot.helpers
  collection: ->
    #getCollection(@)
  label: ->
    @atts.label or 'Choose file'
  removeLabel: ->
    @atts['remove-label'] or 'Remove'
  accept: ->
    @atts.accept or '*'
  fileUploadAtts: ->
    atts = _.clone(this.atts)
    delete atts.collection
    atts
  fileUpload: ->
    af = Template.parentData(1)._af
    # Template.parentData(4).value

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
    console.log(file)
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
