CommentPackageView = require './comment-package-view'
{CompositeDisposable} = require 'atom'

module.exports = CommentPackage =
  commentPackageView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @commentPackageView = new CommentPackageView(state.commentPackageViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @commentPackageView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'comment-package:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @commentPackageView.destroy()

  serialize: ->
    commentPackageViewState: @commentPackageView.serialize()

  toggle: ->
    console.log 'CommentPackage was toggled!'
    editor=atom.workspace.getActivePaneItem()
    file=editor?.buffer?.file
    name=file?.getBaseName()
    if name
      extension=name.split(".")
      extension=extension[extension.length-1]
      if(extension=="c"||extension=="cpp"||extension=="js"||extension=="java"||extension=="php"||extension=="json")
        @commentC()
      else if(extension=="py"||extension=="coffee"||extension=="rb"||extension=="erb"||extension=="pl"||extension=="cson")
        @commentPython()

#Adds C style comments ie  // to every line. Can be called for all languages witht that syntax for languages
  commentC: ->
        editor=atom.workspace.getActiveTextEditor()
        selection=editor.getSelectedText()
        lines=selection.split("\n")
        newselection=""
        for x in lines
          if(x.indexOf("//")==-1)
            newselection+="//"+x
          else if(x.indexOf("//")>-1&& ///^\W*//\w*///.test(x))
            x=x.replace("//","")
            newselection+=x #+"comment found here"
          else if(x.indexOf("//")>-1)
            newselection+="//"+x
          newselection+="\n"
        editor.insertText(newselection.slice(0,newselection.length-1))

#Adds python style comments ie # , can be used for any languages that have a similar syntax
  commentPython: ->
    editor=atom.workspace.getActiveTextEditor()
    selection=editor.getSelectedText()
    lines=selection.split("\n")
    newselection=""
    for x in lines
      if(x.indexOf("#")==-1)
        newselection+="#"+x
      else if(x.indexOf("#")>-1&& ///^\W*\#\w*///.test(x))
        x=x.replace("#","")
        newselection+=x #+"comment found here"
      else if(x.indexOf("//")>-1)
        newselection+="//"+x
      newselection+="\n"
    editor.insertText(newselection.slice(0,newselection.length-1))
