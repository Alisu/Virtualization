Class {
	#name : #ClassMethodModuleBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'classModel',
		'instanceMethodModel',
		'classMethodModel'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
ClassMethodModuleBrowser class >> defaultSpec [
<spec>
	^ SpecLayout composed
		newRow: [:row | row
			add: #classModel width: 300;
			add: #instanceMethodModel;
			add: #classMethodModel. ];
		yourself
]

{ #category : #example }
ClassMethodModuleBrowser class >> example [
	<sampleInstance>
	| example |
	example := ClassMethodModuleBrowser new.
	example
		classes: (MLModuleRegistry global at:#Kernel) environment values;
		openWithSpec.
		^example
]

{ #category : #specs }
ClassMethodModuleBrowser class >> title [

	^ 'Class Method Browser'
]

{ #category : #'as yet unclassified' }
ClassMethodModuleBrowser >> classContextMenu: aMenuPresenter [ 
	self classModel contextMenu: aMenuPresenter.
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classMethodModel [
	^ classMethodModel
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classModel [
	^ classModel
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classes [
	
	^ classModel items
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classes: aList [

	self classModel items: (aList sort: [ :a :b | a name < b name ])
]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializePresenter [

	classModel
		whenSelectionChangedDo:
			[ self selectedClass
				ifNotNil: [ 
					instanceMethodModel items: (self selectedClass  methods sort: [ :a :b | a selector < b selector ]).
					instanceMethodModel unselectAll.
					classMethodModel items: (self selectedClass classSide methods sort: [ :a :b | a selector < b selector ]).
					classMethodModel unselectAll.				
					 ] ]
				

]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializeWidgets [
	classModel := self instantiate:  ListPresenter.
	instanceMethodModel := self instantiate: ListPresenter.
	classMethodModel := self instantiate: ListPresenter.
	self focusOrder
		add: classModel;
		add: instanceMethodModel;
		add: classMethodModel.
	instanceMethodModel displayBlock: [ :method | method selector ].
	classMethodModel displayBlock: [ :method | method selector ]
]

{ #category : #accessing }
ClassMethodModuleBrowser >> instanceMethodModel [
	^ instanceMethodModel
]

{ #category : #'as yet unclassified' }
ClassMethodModuleBrowser >> methodContextMenu: aMenuPresenter [ 
	
	self classMethodModel contextMenu: aMenuPresenter.
	self instanceMethodModel contextMenu: aMenuPresenter.
]

{ #category : #accessing }
ClassMethodModuleBrowser >> refreshMethods [

	instanceMethodModel items:(self selectedClass methods sort: [ :a :b | a selector < b selector ]).
	classMethodModel items:(self selectedClass classSide methods sort: [ :a :b | a selector < b selector ]).
]

{ #category : #selection }
ClassMethodModuleBrowser >> selectClass: aClass [ 
	
	classModel selectItem: aClass
]

{ #category : #accessing }
ClassMethodModuleBrowser >> selectedClass [
	^ classModel selection selectedItem
]

{ #category : #accessing }
ClassMethodModuleBrowser >> selectedClassMethod [
	^ classMethodModel selection selectedItem
]

{ #category : #accessing }
ClassMethodModuleBrowser >> selectedInstanceMethod [
	^ instanceMethodModel selection selectedItem
]

{ #category : #selection }
ClassMethodModuleBrowser >> unselectAll [
	
	classModel unselectAll
]

{ #category : #events }
ClassMethodModuleBrowser >> whenSelectedClassChangedDo: aBlockClosure [ 
	
	classModel whenSelectionChangedDo: aBlockClosure
]

{ #category : #events }
ClassMethodModuleBrowser >> whenSelectedClassMethodChangedDo: aBlockClosure [ 
	
	classMethodModel whenSelectionChangedDo: aBlockClosure
]

{ #category : #events }
ClassMethodModuleBrowser >> whenSelectedInstanceMethodChangedDo: aBlockClosure [ 
	
	instanceMethodModel whenSelectionChangedDo: aBlockClosure
]
