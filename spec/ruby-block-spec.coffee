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

  setupTest = (line, enabled) ->
    atom.config.set 'ruby-block.highlightLineNumber', enabled
    spyOn(_._, "now").andCallFake -> window.now
    editor.setCursorBufferPosition [line, 0]
    advanceClock(100)

  expectation = (line, gutter, visible, html) ->
    it 'highlights line', ->
      expect(getResultDecorations(editor, 'ruby-block-highlight', 'highlight')).toHaveLength line

    it 'highlights gutter', ->
      expect(getResultDecorations(editor, 'ruby-block-highlight', 'line-number')).toHaveLength gutter

    it 'shows view in bottom panel', ->
      expect(workspaceElement.querySelector('.ruby-block')).toBe atom.workspace.getBottomPanels()[0].item
      expect(atom.workspace.getBottomPanels()[0].visible).toBe visible
      expect(workspaceElement.querySelector('.ruby-block').innerHTML).toBe html

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
      atom.packages.activatePackage("ruby-block")

  describe "when cursor is on the 'end'", ->
    describe "when highlightLineNumber option is 'true'", ->
      beforeEach ->
        setupTest(3, true)

      expectation(1, 1, true, '<div class="message">Line: 2 [1,2,3].each do |n|</div>')

    describe "when highlightLineNumber option is 'false'", ->
      beforeEach ->
        setupTest(3, false)

      expectation(1, 0, true, '<div class="message">Line: 2 [1,2,3].each do |n|</div>')

  describe "when cursor is not on the 'end'", ->
    beforeEach ->
      setupTest(4, true)

    expectation(0, 0, false, '')

  describe "when cursor is on the 'end' of block containing one line if", ->
    beforeEach ->
      setupTest(43, true)

    expectation(1, 1, true, '<div class="message">Line: 39 if true</div>')
