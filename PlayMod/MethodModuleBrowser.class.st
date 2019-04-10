Class {
	#name : #MethodModuleBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listModel',
		'textModel',
		'toolbarModel'
	],
	#category : #'PlayMod-Classes-Methods'
}

{ #category : #specs }
MethodModuleBrowser class >> defaultSpec [
	<spec>
	| delta |
	delta := 15.
	^ SpecLayout composed 
			add: #listModel origin: 0@0 corner: 1@0.5 offsetOrigin: 0@0 offsetCorner: 0@(delta negated);
			add: #toolbarModel origin: 0@0.5 corner: 1@0.5 offsetOrigin: 0@(delta negated) offsetCorner: 0@delta;
			add: #textModel origin: 0@0.5 corner: 1@1 offsetOrigin: 0@delta offsetCorner: 0@0;
			yourself
]

{ #category : #specs }
MethodModuleBrowser class >> defaultSpec2 [
^{ #Panel.
		#changeTableLayout.
		#listDirection:. 	#bottomToTop.
		#addMorph:. 		{#model. #listModel.}.
		#addMorph:. 		{#model. #textModel.}.
		#vResizing:.		 #spaceFill.
		#hResizing:.		 #spaceFill.}
]

{ #category : #example }
MethodModuleBrowser class >> example [
	<sampleInstance>
	| example |
	example := MethodModuleBrowser new.
	example methods: Object methods;
	 openWithSpec.
	^example
]

{ #category : #specs }
MethodModuleBrowser class >> title [

	^ 'Method Browser'
]

{ #category : #accessing }
MethodModuleBrowser >> acceptBlock: aBlock [

	textModel acceptBlock: aBlock
]

{ #category : #accessing }
MethodModuleBrowser >> action [

	^ textModel actionToPerformHolder content
]

{ #category : #api }
MethodModuleBrowser >> displayBlock: aBlock [

	listModel displayBlock: aBlock
]

{ #category : #initialization }
MethodModuleBrowser >> initializePresenter [

	listModel whenSelectedItemChanged: [:selection |
		selection
			ifNil: [
				textModel text: ''.
				textModel behavior: nil.
				toolbarModel method: nil ]
			ifNotNil: [:m | 
				textModel text: m sourceCode.
				textModel behavior: m methodClass.
				toolbarModel method: m ]].
	
	"self acceptBlock: [:t | self listModel selectedItem inspect]."
	self wrapWith: [:item | item methodClass name,'>>#', item selector ].
]

{ #category : #initialization }
MethodModuleBrowser >> initializeWidgets [
	listModel := self instantiate: ListPresenter .
	textModel := self newCode.
	toolbarModel := self instantiate: MethodToolbar.
	self focusOrder
		add: listModel;
		add: toolbarModel;
		add: textModel.
	textModel aboutToStyle: true.
	textModel beForCode.
]

{ #category : #accessing }
MethodModuleBrowser >> listModel [

	^ listModel
]

{ #category : #api }
MethodModuleBrowser >> methods: aList [

	"Here I reroute my entry point to the list model's entry point"
	self listModel items: aList
]

{ #category : #api }
MethodModuleBrowser >> sortingBlock: aBlock [ 

	listModel sortingBlock: aBlock 
]

{ #category : #focus }
MethodModuleBrowser >> takeKeyboardFocus [

	^ self listModel takeKeyboardFocus
]

{ #category : #accessing }
MethodModuleBrowser >> textModel [

	^ textModel
]

{ #category : #accessing }
MethodModuleBrowser >> toolbarModel [

	^ toolbarModel
]

{ #category : #api }
MethodModuleBrowser >> wrapWith: aBlock [

	listModel displayBlock: aBlock
]
