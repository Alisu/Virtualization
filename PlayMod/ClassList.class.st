Class {
	#name : #ClassList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'label',
		'classes'
	],
	#category : #'PlayMod-Class'
}

{ #category : #specs }
ClassList class >> defaultSpec [
^ SpecColumnLayout composed
	add: #label height: self toolbarHeight;
	add: #classes;
	yourself
]

{ #category : #'as yet unclassified' }
ClassList >> classContextMenu: aMenuPresenter [ 
	self classes contextMenu: aMenuPresenter.
]

{ #category : #accessing }
ClassList >> classes [
	^ classes
]

{ #category : #initialization }
ClassList >> initializeWidgets [
classes:= self newList.
classes displayBlock: [ :m | m printString].
label := self newLabel.
label label: 'Classes'.
self focusOrder add: classes.
]

{ #category : #accessing }
ClassList >> items [

	^ classes items
]

{ #category : #accessing }
ClassList >> items: aCollection [
classes items: aCollection
]

{ #category : #accessing }
ClassList >> label [
	^ label
]

{ #category : #accessing }
ClassList >> label: aText [
label label: aText
]

{ #category : #accessing }
ClassList >> resetSelection [
	classes unselectAll
]

{ #category : #accessing }
ClassList >> selectedItem [
	^ classes selection selectedItem
]

{ #category : #initialization }
ClassList >> title [
^ 'Class widget'
]

{ #category : #accessing }
ClassList >> whenSelectedItemChanged: aBlock [
	classes
		whenSelectionChangedDo: [ :selection | aBlock cull: selection selectedItem ]
]
