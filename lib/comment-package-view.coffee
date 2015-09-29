module.exports =
class CommentPackageView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('comment-package')

    # Create message element
    message = document.createElement('div')
    editor=atom.workspace.getActivePaneItem()
    file=editor?.buffer?.file
    name=file?.getBaseName()
    if name
      extension=name.split(".")
      extension=extension[extension.length-1]
      message.textContent = "File extension is #{extension}"
      message.classList.add('message')
      @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
