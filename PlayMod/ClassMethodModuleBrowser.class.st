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
						add: #listModel;
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
ClassMethodModuleBrowser >> classes: aList [

	self listModel items: aList
]

{ #category : #accessing }
ClassMethodModuleBrowser >> initializePresenter [
	| classSelected |
	listModel
		whenSelectedItemChangedDo: [ :selection | 
			selection
				ifNotNil: [ :class | 
					classSelected := self listModel selectedItem.
					methodModel
						methods: (class methods sort: [ :a :b | a selector < b selector ]).
					methodModel listModel resetSelection ] ].
	methodModel
		acceptBlock: [ :t | 
			classSelected environment compileMethod: t inClass: classSelected.
			methodModel listModel resetSelection ]
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
