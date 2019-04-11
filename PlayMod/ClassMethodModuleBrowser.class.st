Class {
	#name : #ClassMethodModuleBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listModel',
		'methodModel'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
ClassMethodModuleBrowser class >> defaultSpec [
<spec>
	^ SpecLayout composed
		newRow: [:row | row
			add: #listModel width: 300;
			add: #methodModel ];
		yourself
]

{ #category : #example }
ClassMethodModuleBrowser class >> example [
	<sampleInstance>
	| example |
	example := ClassMethodModuleBrowser new.
	example
		classes: (MLModuleRegistry global at:#SNAP) environment values;
		openWithSpec.
		^example
]

{ #category : #specs }
ClassMethodModuleBrowser class >> title [

	^ 'Class Method Browser'
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classes [
	
	^ listModel items
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classes: aList [

	self listModel items: (aList sort: [ :a :b | a name < b name ])
]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializePresenter [

	listModel
		whenSelectionChangedDo:
			[ self selectedClass
				ifNotNil: [ 
					methodModel
						items: (self selectedClass  methods sort: [ :a :b | a selector < b selector ]).
					methodModel unselectAll ] ]
				

]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializeWidgets [
	listModel := self instantiate:  ListPresenter.
	methodModel := self instantiate: ListPresenter.
	self focusOrder
		add: listModel;
		add: methodModel.
	methodModel displayBlock: [ :method | method selector ]
]

{ #category : #accessing }
ClassMethodModuleBrowser >> listModel [

	^ listModel
]

{ #category : #accessing }
ClassMethodModuleBrowser >> methodModel [

	^ methodModel
]

{ #category : #accessing }
ClassMethodModuleBrowser >> methods [
	
	^ methodModel items
]

{ #category : #accessing }
ClassMethodModuleBrowser >> refreshMethods [

	methodModel
		items: (self selectedClass methods sort: [ :a :b | a selector < b selector ]).
]

{ #category : #selection }
ClassMethodModuleBrowser >> selectClass: aClass [ 
	
	listModel selectItem: aClass
]

{ #category : #accessing }
ClassMethodModuleBrowser >> selectedClass [
	^ listModel selection selectedItem
]

{ #category : #accessing }
ClassMethodModuleBrowser >> selectedMethod [
	^ methodModel selection selectedItem
]

{ #category : #selection }
ClassMethodModuleBrowser >> unselectAll [
	
	listModel unselectAll
]

{ #category : #events }
ClassMethodModuleBrowser >> whenSelectedClassChangedDo: aBlockClosure [ 
	
	listModel whenSelectionChangedDo: aBlockClosure
]
