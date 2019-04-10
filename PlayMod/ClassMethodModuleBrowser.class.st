Class {
	#name : #ClassMethodModuleBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listModel',
		'methodModel'
	],
	#category : #'PlayMod-Classes-Methods'
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
ClassMethodModuleBrowser >> acceptMethodText: aText [

	self selectedClass environment
		compileMethod: aText
		inClass: self selectedClass.
	
	self refreshMethods.
	methodModel listModel unselectAll
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classes [
	
	^ listModel items
]

{ #category : #accessing }
ClassMethodModuleBrowser >> classes: aList [

	self listModel items: aList
]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializePresenter [

	listModel
		whenSelectionChangedDo: [ :selection | 
			selection selectedItem
				ifNotNil: [ :class |
					self refreshMethods.
					methodModel listModel unselectAll ] ].
	methodModel acceptBlock: [ :t | self acceptMethodText: t ]
]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializeWidgets [
	listModel := self instantiate:  ListPresenter .
	methodModel := self instantiate: MethodModuleBrowser.
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
	
	^ methodModel methods
]

{ #category : #accessing }
ClassMethodModuleBrowser >> refreshMethods [

	methodModel
		methods: (self selectedClass methods sort: [ :a :b | a selector < b selector ]).
]

{ #category : #selection }
ClassMethodModuleBrowser >> selectClass: aClass [ 
	
	listModel selectItem: aClass
]

{ #category : #accessing }
ClassMethodModuleBrowser >> selectedClass [
	^ listModel selection selectedItem
]

{ #category : #selection }
ClassMethodModuleBrowser >> unselectAll [
	
	listModel unselectAll
]

{ #category : #events }
ClassMethodModuleBrowser >> whenSelectedClassChangedDo: aBlockClosure [ 
	
	listModel whenSelectionChangedDo: aBlockClosure
]
