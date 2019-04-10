Class {
	#name : #WidgetModuleList,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listModule'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
WidgetModuleList class >> defaultSpec [
^ SpecLayout composed
	add: #listModule;
	yourself
]

{ #category : #initialization }
WidgetModuleList >> initializeWidgets [

listModule := self newList.
self focusOrder add: listModule.
]

{ #category : #accessing }
WidgetModuleList >> items: aCollection [
listModule  items: aCollection
]

{ #category : #accessing }
WidgetModuleList >> listModule [
	^ listModule
]

{ #category : #initialization }
WidgetModuleList >> title [
	^'Liste module'
]

{ #category : #'events-shortcuts' }
WidgetModuleList >> whenSelectedItemChanged: aBlock [
listModule whenSelectedItemChanged: aBlock
]
