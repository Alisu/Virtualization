Class {
	#name : #'Tabs_PlayMod',
	#superclass : #ComposablePresenter,
	#instVars : [
		'manager'
	],
	#category : #PlayMod
}

{ #category : #specs }
Tabs_PlayMod class >> defaultSpec [
	<spec>
	
	^ SpecLayout composed
		add: #manager;
		yourself
]

{ #category : #initialization }
Tabs_PlayMod >> graphTab [
	| tab |
	tab := self newTab.
	tab
		label: 'Graph';
		icon: (tab iconNamed: #nautilusIcon);
		presenter: DynamicWidgetChange new.
	^ tab
		
]

{ #category : #initialization }
Tabs_PlayMod >> initializeWidgets [

	manager := self newTabManager.
	manager whenTabSelected: [ self updateTitle ].
	self populateManager
]

{ #category : #initialization }
Tabs_PlayMod >> manager [

	^ manager
		
]

{ #category : #initialization }
Tabs_PlayMod >> moduleInspectorTab [
	|tab module|
	module := MLModuleExample new runExample .
	tab := self newTab.
	tab
		label: 'Module inspector';
		icon: (tab iconNamed: #nautilusIcon);
		retrievingBlock: [ (EyeInspector new
				inspect: module;
				buildWithSpec: #inspectorSpec) asWidget ].
			^tab
		
]

{ #category : #initialization }
Tabs_PlayMod >> moduleTab [
	| tab |
	tab := self newTab.
	tab
		label: 'Browser';
		icon: (tab iconNamed: #nautilusIcon);
		presenter:
			(ModuleViewer new).
	^ tab
		
]

{ #category : #initialization }
Tabs_PlayMod >> populateManager [

	manager		
		addTab: self moduleTab;
		addTab: self moduleInspectorTab;
		addTab: self graphTab.
		
]

{ #category : #initialization }
Tabs_PlayMod >> title [

	^ self manager selectedTab
		ifNil: [ 'TMAP' ]
		ifNotNil: [:tab | tab label ]
		
]
