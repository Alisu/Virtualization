Class {
	#name : #ModuleViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'modules',
		'imports',
		'classes',
		'undefined',
		'text'
	],
	#category : #PlayMod
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
|myModules lastModuleSelected|
myModules:= OrderedCollection new.
MLModuleRegistry global moduleEnvironment valuesDo:[:value|myModules add: value].
modules items: myModules.
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
text beForCode.
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
