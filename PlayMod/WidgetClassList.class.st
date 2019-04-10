Class {
	#name : #WidgetClassList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'label',
		'classes'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
WidgetClassList class >> defaultSpec [
^ SpecColumnLayout composed
	add: #label height: self toolbarHeight;
	add: #classes;
	yourself
]

{ #category : #accessing }
WidgetClassList >> classes [
	^ classes
]

{ #category : #initialization }
WidgetClassList >> initializeWidgets [
classes:= self newList.
classes displayBlock: [ :m | m printString].
label := self newLabel.
label label: 'Classes'.
self focusOrder add: classes.
]

{ #category : #accessing }
WidgetClassList >> items: aCollection [
classes items: aCollection
]

{ #category : #accessing }
WidgetClassList >> label [
	^ label
]

{ #category : #accessing }
WidgetClassList >> label: aText [
label label: aText
]

{ #category : #accessing }
WidgetClassList >> resetSelection [
	classes unselectAll
]

{ #category : #accessing }
WidgetClassList >> selectedItem [
	^ classes selection selectedItem
]

{ #category : #initialization }
WidgetClassList >> title [
^ 'Class widget'
]

{ #category : #accessing }
WidgetClassList >> whenSelectedItemChanged: aBlock [
	classes
		whenSelectionChangedDo: [ :selection | aBlock cull: selection selectedItem ]
]
