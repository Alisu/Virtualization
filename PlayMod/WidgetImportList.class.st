Class {
	#name : #WidgetImportList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'label',
		'imports'
	],
	#category : #PlayMod
}

{ #category : #specs }
WidgetImportList class >> defaultSpec [
^ SpecColumnLayout composed
	add: #label height: self toolbarHeight;
	add: #imports;
	yourself
]

{ #category : #accessing }
WidgetImportList >> imports [
	^ imports
]

{ #category : #initialization }
WidgetImportList >> initializeWidgets [
imports:= self newList.
imports displayBlock: [ :m | m   ].
label := self newLabel.
label label: 'Imports'.
self focusOrder add: imports.
]

{ #category : #accessing }
WidgetImportList >> items: aCollection [
imports items: aCollection
]

{ #category : #accessing }
WidgetImportList >> label [
	^ label
]

{ #category : #accessing }
WidgetImportList >> label: aText [
label label: aText
]

{ #category : #accessing }
WidgetImportList >> resetSelection [ 
imports resetSelection
]

{ #category : #initialization }
WidgetImportList >> title [
^ 'Imports widget'
]

{ #category : #accessing }
WidgetImportList >> whenSelectedItemChanged: aBlock [
imports whenSelectedItemChanged: aBlock
]