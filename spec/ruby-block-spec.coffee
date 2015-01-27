RubyBlock = require '../lib/ruby-block'

describe "RubyBlock", ->
  [workspaceElement, editor, editorElement, markers, lineNumbers, rubyBlockElement, bottomPanels] =  []

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('language-ruby')
    waitsForPromise -> atom.workspace.open('test.rb')  
    waitsForPromise ->
      atom.packages.activatePackage('ruby-block').then (pkg) ->
        rubyBlock = pkg.mainModule
        atom.config.set 'ruby-block.highlightLineNumber', true
        
    runs ->
      workspaceElement = atom.views.getView(atom.workspace)
      jasmine.attachToDOM(workspaceElement)
      
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)

  describe "when cursor is on the 'end'", ->
    beforeEach ->
      editor.setCursorBufferPosition [2, 0]
      markers = editorElement.shadowRoot.querySelectorAll('.region')
      lineNumbers = editorElement.shadowRoot.querySelectorAll('.line-number.ruby-block-highlight')
      rubyBlockElement = workspaceElement.querySelector('.panel-bottom .ruby-block')
      bottomPanels = atom.workspace.getBottomPanels()
      
    it 'highlights line', ->
      expect(markers.length).toBe 1
      
    it 'highlights gutter', ->
      expect(lineNumbers.length).toBe 1
      
    it 'shows view in bottom panel', ->
      expect(rubyBlockElement).toExist
      expect(bottomPanels[0].isVisible()).toBe true
      
  describe "when cursor is not on the 'end'", ->
    beforeEach ->
      editor.setCursorBufferPosition [3, 0]
      markers = editorElement.shadowRoot.querySelectorAll('.region')
      lineNumbers = editorElement.shadowRoot.querySelectorAll('.line-number.ruby-block-highlight')
      rubyBlockElement = workspaceElement.querySelector('.panel-bottom .ruby-block')
      bottomPanels = atom.workspace.getBottomPanels()
    
    it "doesn't highlight line", ->
      expect(markers.length).toBe 0
  
    it "doesn't highlight gutter", ->
      expect(lineNumbers.length).toBe 0
    
    it 'shows view in bottom panel', ->
      expect(rubyBlockElement).toExist
      expect(bottomPanels[0].isVisible()).toBe false
    
