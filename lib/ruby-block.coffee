RubyBlockView = require './ruby-block-view'
{CompositeDisposable} = require 'atom'

module.exports = RubyBlock =
  rubyBlockView: null
  modalPanel: null
  rubyRootScope: 'source.ruby'
  rubyStartBlockScopes: [
     'keyword.control.ruby'
     'keyword.control.start-block.ruby' 
     'keyword.control.class.ruby' 
     'keyword.control.module.ruby' 
     'keyword.control.def.ruby' 
  ]
  rubyEndBlockScope: 'keyword.control.ruby'
  rubyEndBlockName: 'end'
  rubyNotStartBlockNames: [
    'then'
    'when'
    'rescue'
    'ensure'
    'else'
  ]
  endBlockStacks: 0

  activate: (state) ->
    @rubyBlockView = new RubyBlockView(state.rubyBlockViewState)
    @modalPanel = atom.workspace.addBottomPanel(item: @rubyBlockView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem (activeItem) =>
      @modalPanel.hide() if @modalPanel.isVisible()
      @subscribeToActiveTextEditor()

    @subscribeToActiveTextEditor()              
        
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor', 'ruby-block:go-to-block-starting-line': => 
      @goToBlockStartingLine()

  deactivate: ->
    @modalPanel.destroy()
    # @subscriptions.dispose()
    # @subscriptions.forEach (subscription) -> subscription.dispose()
    @activeItemSubscription.dispose()
    @cursorSubscription?.dispose()
    @rubyBlockView.destroy()

  serialize: ->
    rubyBlockViewState: @rubyBlockView.serialize()
    
  goToBlockStartingLine: ->
    return atom.boot() unless @blockStartedRowNumber?
    atom.workspace.getActiveTextEditor().setCursorBufferPosition([@blockStartedRowNumber, 0])
    
  subscribeToActiveTextEditor: ->
    @cursorSubscription?.dispose()
    
    return unless @getActiveTextEditor()?
    for scope in @getActiveTextEditor().getRootScopeDescriptor().scopes
      if scope.indexOf(@rubyRootScope) >= 0
        @cursorSubscription = @getActiveTextEditor()?.onDidChangeCursorPosition =>
          @blockStartedRowNumber = null
          @modalPanel.hide() if @modalPanel.isVisible()
          @maker?.destroy()
          @maker = @hasBlockKeyword()
        @maker = @hasBlockKeyword()
      

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()
    
  hasBlockKeyword: ->
    editor = @getActiveTextEditor()
    grammar = editor.getGrammar()
    cursor = editor.getCursor()
    if cursor.getScopeDescriptor().scopes.indexOf(@rubyEndBlockScope) >= 0 and 
       editor.getWordUnderCursor() is @rubyEndBlockName
       
      for rowNumber in [cursor.getBufferRow()..0]
        tokens = grammar.tokenizeLine(editor.lineTextForBufferRow(rowNumber)).tokens
        for token in tokens
          for scope in token.scopes
            if @rubyStartBlockScopes.indexOf(scope) >= 0
              if token.value is @rubyEndBlockName
                ++@endBlockStacks
              else if @rubyNotStartBlockNames.indexOf(token.value) is -1
                if --@endBlockStacks is 0
                  @marker = editor.markBufferPosition([rowNumber, 0])
                  for type in ['gutter', 'line']
                    @blockStartedRowNumber = rowNumber
                    editor.decorateMarker(@marker, {type: type, class: 'ruby-block-highlight'})
                    @rubyBlockView.updateMessage(rowNumber)
                    @modalPanel.show()
                  
                  return @marker
          
