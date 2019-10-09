Class {
	#name : #ImportList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'label',
		'imports'
	],
	#category : #'PlayMod-Import'
}

{ #category : #specs }
ImportList class >> defaultSpec [
^ SpecColumnLayout composed
	add: #label height: self toolbarHeight;
	add: #imports;
	yourself
]

{ #category : #'as yet unclassified' }
ImportList >> importContextMenu: aMenuPresenter [ 
	self imports contextMenu: aMenuPresenter.
]

{ #category : #accessing }
ImportList >> imports [
	^ imports
]

{ #category : #initialization }
ImportList >> initializeWidgets [
imports:= self newList.
imports displayBlock: [ :m | m   ].
label := self newLabel.
label label: 'Imports'.
self focusOrder add: imports.
]

{ #category : #accessing }
ImportList >> items [
	^ imports items
]

{ #category : #accessing }
ImportList >> items: aCollection [
	imports items: aCollection
]

{ #category : #accessing }
ImportList >> label [
	^ label
]

{ #category : #accessing }
ImportList >> label: aText [
label label: aText
]

{ #category : #accessing }
ImportList >> resetSelection [
	imports unselectAll
]

{ #category : #'as yet unclassified' }
ImportList >> selectedImport [
	^ imports selection selectedItem
]

{ #category : #initialization }
ImportList >> title [
^ 'Imports widget'
]

{ #category : #selection }
ImportList >> unselectAll [
	
	imports unselectAll
]

{ #category : #accessing }
ImportList >> whenSelectedItemChanged: aBlock [
	imports
		whenSelectionChangedDo: [ :selection | aBlock cull: selection selectedItem ]
]
