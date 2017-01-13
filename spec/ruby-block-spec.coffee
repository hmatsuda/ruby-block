_ = require 'underscore-plus'
{$} = require 'atom-space-pen-views'

path = require 'path'

describe "RubyBlock", ->
  [workspaceElement, editor, editorView, editorElement, markers, lineNumbers, rubyBlockElement, bottomPanels] =  []

  getResultDecorations = (editor, clazz, type) ->
    if editor.decorationsStateForScreenRowRange?
      resultDecorations = []
      for id, decoration of editor.decorationsStateForScreenRowRange(0, editor.getLineCount())
        if decoration.properties.class is clazz and decoration.properties.type is type
          resultDecorations.push(decoration)
    else
      markerIdForDecorations = editor.decorationsForScreenRowRange(0, editor.getLineCount())
      resultDecorations = []
      for markerId, decorations of markerIdForDecorations
        for decoration in decorations
          resultDecorations.push decoration if decoration.getProperties().class is clazz and decoration.getProperties.type is type
    resultDecorations
    
  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    atom.project.setPaths([path.join(__dirname, 'fixtures')])

    waitsForPromise -> 
      atom.workspace.open('test.rb')
      
    waitsForPromise -> 
      atom.packages.activatePackage('language-ruby')

    runs ->
      jasmine.attachToDOM(workspaceElement)
      editor = atom.workspace.getActiveTextEditor()
      editorView = editor.getElement()

      activationPromise = atom.packages.activatePackage("ruby-block").then ({mainModule}) ->
        mainModule.createViews()
        {findView} = mainModule

  describe "when cursor is on the 'end'", ->
    describe "when highlightLineNumber option is 'true'", ->
      beforeEach ->
        atom.config.set 'ruby-block.highlightLineNumber', true
        spyOn(_._, "now").andCallFake -> window.now
        editor.setCursorBufferPosition [3, 0]
        advanceClock(100)
        bottomPanels = atom.workspace.getBottomPanels()
        
      it 'highlights line', ->
        expect(getResultDecorations(editor, 'ruby-block-highlight', 'highlight')).toHaveLength 1
        
      it 'highlights gutter', ->
        expect(getResultDecorations(editor, 'ruby-block-highlight', 'line-number')).toHaveLength 1
        
      it 'shows view in bottom panel', ->
        expect(workspaceElement.querySelector('.ruby-block')).toBe bottomPanels[0].item

    describe "when highlightLineNumber option is 'false'", ->
      beforeEach ->
        atom.config.set 'ruby-block.highlightLineNumber', false
        spyOn(_._, "now").andCallFake -> window.now
        editor.setCursorBufferPosition [3, 0]
        advanceClock(100)
        bottomPanels = atom.workspace.getBottomPanels()
        
      it 'highlights line', ->
        expect(getResultDecorations(editor, 'ruby-block-highlight', 'highlight')).toHaveLength 1

      it 'highlights gutter', ->
        expect(getResultDecorations(editor, 'ruby-block-highlight', 'line-number')).toHaveLength 0

      it 'shows view in bottom panel', ->
        expect(workspaceElement.querySelector('.ruby-block')).toBe bottomPanels[0].item


  describe "when cursor is not on the 'end'", ->
    beforeEach ->
      editor.setCursorBufferPosition [4, 0]
      advanceClock(100)

    it 'highlights line', ->
      expect(getResultDecorations(editor, 'ruby-block-highlight', 'highlight')).toHaveLength 0

    it 'highlights gutter', ->
      expect(getResultDecorations(editor, 'ruby-block-highlight', 'line-number')).toHaveLength 0

    it 'shows view in bottom panel', ->
      expect(bottomPanels).toHaveLength 0
      
