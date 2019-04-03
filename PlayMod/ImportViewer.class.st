Class {
	#name : #ImportViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'imports',
		'importClasses',
		'fromModules'
	],
	#category : #PlayMod
}

{ #category : #specs }
ImportViewer class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #imports;
			yourself
]

{ #category : #'as yet unclassified' }
ImportViewer >> classesIn: import [
^ (import importedName).
]

{ #category : #accessing }
ImportViewer >> fromModules [
	^ fromModules
]

{ #category : #accessing }
ImportViewer >> importClasses [
	^ importClasses
]

{ #category : #accessing }
ImportViewer >> imports [
	^ imports
]

{ #category : #accessing }
ImportViewer >> imports: aCollection [
imports items: aCollection
]

{ #category : #'as yet unclassified' }
ImportViewer >> importsIn: import [
^ import moduleName.
]

{ #category : #initialization }
ImportViewer >> initializePresenter [
imports whenSelectedItemChanged: [ :import|
	fromModules  resetSelection.
	importClasses  resetSelection.
	import
	ifNil: [ fromModules items: #().
		 importClasses  items: #() ]
	ifNotNil: [fromModules  items: (self importsIn: import).
		importClasses  items: (self classesIn: import) ] ].

fromModules  whenSelectedItemChanged: [ :module |
	module ifNotNil: [ fromModules  resetSelection ] ].
importClasses whenSelectedItemChanged: [ :class |
	class ifNotNil: [ importClasses resetSelection ] ]
]

{ #category : #initialization }
ImportViewer >> initializeWidgets [
imports  := self instantiate: WidgetImportList.
fromModules  := self instantiate: WidgetImportList.
importClasses  := self instantiate: WidgetImportList.
fromModules  label: 'From'.
importClasses  label: 'Class'.
self focusOrder add: imports; add: fromModules ; add: importClasses .
]

{ #category : #accessing }
ImportViewer >> resetSelection [ 
imports resetSelection
]

{ #category : #initialization }
ImportViewer >> title [
^ 'Module viewer'
]

{ #category : #'as yet unclassified' }
ImportViewer >> whenFromModuleChanged: aBlock [
fromModules whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ImportViewer >> whenImportChanged: aBlock [
imports whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ImportViewer >> whenImportClassChanged: aBlock [
importClasses whenSelectedItemChanged: aBlock
]
