Class {
	#name : #ModuleViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'modules',
		'imports',
		'classes',
		'undefined',
		'text',
		'moduleList'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
ModuleViewer class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #modules;
				add: #imports;
				add: #classes;
				add: #undefined ];
		newRow: [ :row | row add: #text ] yourself
]

{ #category : #example }
ModuleViewer class >> example [
	<sampleInstance>
	| example aCollection|
	example := ModuleViewer new.
	aCollection :=(OrderedCollection new).
	aCollection add: (MLModule newNamed: 'Pouet1').
	aCollection add: (MLModule newNamed: 'Pouet2').

	example
		moduleList: aCollection;
		openWithSpec.
		^example
]

{ #category : #accessing }
ModuleViewer >> classes [
	^ classes
]

{ #category : #'as yet unclassified' }
ModuleViewer >> classesIn: module [
^ (module classes).
]

{ #category : #accessing }
ModuleViewer >> imports [
	^ imports
]

{ #category : #'as yet unclassified' }
ModuleViewer >> importsIn: module [
^ module imports asArray.
]

{ #category : #initialization }
ModuleViewer >> initializePresenter [
|lastModuleSelected|

modules whenSelectedItemChanged: [ :module|
	imports resetSelection.
	classes resetSelection.
	module
	ifNil: [ imports items: #().
				classes items: #().
				undefined items: #().
				text text: ''.
				text behavior: nil. ]
	ifNotNil: [	lastModuleSelected := module.
					imports imports: (self importsIn: module).
					classes items: (self classesIn: module).
					undefined items: (self undefinedIn: module).
					text text: module printDeclaration.
					 ] ].

imports whenImportChanged: [ :import |
	import ifNotNil: [ imports resetSelection ] ].
classes whenSelectedItemChanged: [ :class |
	class ifNotNil: [ classes resetSelection.
							text text: '', lastModuleSelected printString, ' declareClassNamed: ', class name ] ]
]

{ #category : #initialization }
ModuleViewer >> initializeWidgets [
modules := self instantiate: WidgetModuleList.
imports := self instantiate: ImportViewer.
classes := self instantiate: WidgetClassList.
undefined := self instantiate: WidgetClassList. 
text := self instantiate: self newCode.
classes label: 'Class'.
undefined label:'Undefined'.
self focusOrder add: modules; add: imports; add: classes; add: undefined; add: text.
text aboutToStyle: true.
"text beForCode."
]

{ #category : #accessing }
ModuleViewer >> moduleList [
	^ moduleList
]

{ #category : #accessing }
ModuleViewer >> moduleList: aList [
	self modules items: aList.
]

{ #category : #accessing }
ModuleViewer >> modules [
	^ modules
]

{ #category : #accessing }
ModuleViewer >> text [
	^ text
]

{ #category : #initialization }
ModuleViewer >> title [
^ 'Module viewer'
]

{ #category : #accessing }
ModuleViewer >> undefined [
	^ undefined
]

{ #category : #accessing }
ModuleViewer >> undefinedIn: module [
^ (module undeclaredNames).
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenClassChanged: aBlock [
classes whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenImportChanged: aBlock [
imports whenSelectedItemChanged: aBlock

]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenModuleChanged: aBlock [
modules whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenUndefinedchanged: aBlock [
undefined whenSelectedItemChanged: aBlock
]
