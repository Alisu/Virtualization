Class {
	#name : #ModuleViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'modules',
		'imports',
		'classes',
		'undefined',
		'moduleList',
		'moduleRegistry',
		'menu',
		'definitionsNotebook',
		'moduleContentsNotebook'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
ModuleViewer class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #menu ] height: self toolbarHeight;
		newRow: [ :row | 
			row
				add: #modules;
				add: #moduleContentsNotebook ];
		newRow: [ :row | row add: #text ] yourself
]

{ #category : #example }
ModuleViewer class >> example [
	<sampleInstance>
	| example aCollection|
	example := ModuleViewer new.
	aCollection :=(OrderedCollection new).
	aCollection add: (MLModule newNamed: 'Pouet1').
	aCollection add: (MLModule newNamed: 'Pouet2').

	example
		moduleList: MLModuleRegistry global moduleEnvironment values;
		openWithSpec.
		^example
]

{ #category : #actions }
ModuleViewer >> acceptDefinition: aText [
	
	| classDefinition |
	classDefinition := CDClassDefinitionParser parse: aText asString.
	self selectedModule declareClass: classDefinition.
	
	self refreshClasses.
]

{ #category : #initialization }
ModuleViewer >> buildMenu [

	^ self newMenuBar addGroup: [ :group | 
			group addItem: [ :item | 
				item
					name: 'File';
					subMenu: (self newMenu
						addItem: [ :subitem | 
							subitem
								name: 'New...';
								action: [ self createModule ] ];
						addItem: [ :subitem | 
							subitem
								name: 'Import...';
								action: [ self importModule ] ]) ] ].
]

{ #category : #initialization }
ModuleViewer >> classDefinitionTab [
	
	^ NotebookPage
		title: 'Class definition'
		provider: [ 
			self newText
				text: (self selectedClass ifNotNil: #definitionNew);
				acceptBlock: [ :someText | self acceptDefinition: someText ];
				yourself ]
]

{ #category : #components }
ModuleViewer >> classList [
	
	^ classes
]

{ #category : #initialization }
ModuleViewer >> classListTab [
	
	^ NotebookPage
		title: 'Classes'
		provider: (classes := self instantiate: WidgetClassList)
]

{ #category : #accessing }
ModuleViewer >> classes [
	^ classes
]

{ #category : #'as yet unclassified' }
ModuleViewer >> classesIn: module [
^ (module classes).
]

{ #category : #actions }
ModuleViewer >> createModule [
	
	| name |
	name := UIManager default request: 'New Module Name' initialAnswer: 'MyModule'.
	
	moduleRegistry registerModule: (MLModule newNamed: name).
	self refreshModuleList.
]

{ #category : #components }
ModuleViewer >> importList [
	
	^ imports
]

{ #category : #initialization }
ModuleViewer >> importListTab [
	
	^ NotebookPage
		title: 'Imports'
		provider: (imports := self instantiate: ImportViewer)
]

{ #category : #actions }
ModuleViewer >> importModule [
	
	| selectedPackage collection selectedPackageIndex newModule |
	collection := (RPackageOrganizer default packages collect: #name) sort.
	
	selectedPackageIndex := (UIManager default
		chooseFrom: collection
		lines: #()
		title: 'Choose a package to import').
	
	selectedPackage := (collection at: selectedPackageIndex) asPackage.	
	
	newModule := MLModule loadRPackage: selectedPackage.
	moduleRegistry registerModule: newModule.

	self refreshModuleList.
]

{ #category : #accessing }
ModuleViewer >> imports [
	^ imports
]

{ #category : #'as yet unclassified' }
ModuleViewer >> importsIn: module [
^ module imports asArray.
]

{ #category : #initialization }
ModuleViewer >> initializePresenter [
	self modules displayBlock: [ :aModule | aModule name ].
	self refreshModuleList.
	self refreshTabs.
	
	modules
		whenSelectionChangedDo: [ :selection | [ :module | self selectModule: module ] cull: selection selectedItem ].
	imports 
		whenImportChanged: [ :import | import ifNotNil: [ imports resetSelection ] ].
	classes whenSelectedItemChanged: [ :class | 
		class ifNotNil: [ 
			classes resetSelection.
			self refreshTabs ] ]
]

{ #category : #initialization }
ModuleViewer >> initializeWidgets [

	menu := self buildMenu.
	modules := self newList.
	
	moduleContentsNotebook := self newNotebook.
	moduleContentsNotebook
		addPage: self classListTab;
		addPage: self importListTab;
		addPage: self undeclaredListTab.
	
	definitionsNotebook := self newNotebook.
	definitionsNotebook
		addPage: self moduleDefinitionTab;
		addPage: self classDefinitionTab.
	
	self focusOrder
		add: modules;
		add: imports;
		add: classes;
		add: undefined;
		add: definitionsNotebook.
"	text aboutToStyle: true"
	"text beForCode."
]

{ #category : #initialization }
ModuleViewer >> moduleDefinitionTab [
	
	^ NotebookPage
		title: 'Module definition'
		provider: [ 
			self newText
				text: (self selectedModule ifNotNil: #printDeclaration);
				yourself ]
]

{ #category : #accessing }
ModuleViewer >> moduleList [
	^ moduleList
]

{ #category : #accessing }
ModuleViewer >> moduleList: aList [
	self modules items: aList.
]

{ #category : #accessing }
ModuleViewer >> modules [
	^ modules
]

{ #category : #initialization }
ModuleViewer >> refreshClasses [

	classes items: (self classesIn: self selectedModule)
]

{ #category : #initialization }
ModuleViewer >> refreshModuleList [
	
	self modules
		items: (moduleRegistry moduleEnvironment values sorted: [:a :b | a name < b name ])
]

{ #category : #refreshing }
ModuleViewer >> refreshTabs [
	
	definitionsNotebook resetAllPageContents
]

{ #category : #initialization }
ModuleViewer >> selectModule: aModule [

	imports resetSelection.
	classes resetSelection.
	
	aModule ifNil: [
		imports items: #().
		classes items: #().
		undefined items: #().
		definitionsNotebook text: ''.
		definitionsNotebook behavior: nil. ]
			ifNotNil: [
		imports imports: (self importsIn: aModule).
		classes items: (self classesIn: aModule).
		undefined items: (self undefinedIn: aModule).
		self refreshTabs ]
]

{ #category : #initialization }
ModuleViewer >> selectedClass [

	^ classes selectedItem
]

{ #category : #initialization }
ModuleViewer >> selectedModule [
	^ self modules selection selectedItem
]

{ #category : #accessing }
ModuleViewer >> setModelBeforeInitialization: aModuleRegistry [

	moduleRegistry := aModuleRegistry
]

{ #category : #accessing }
ModuleViewer >> text [
	^ definitionsNotebook
]

{ #category : #initialization }
ModuleViewer >> title [
^ 'Module viewer'
]

{ #category : #components }
ModuleViewer >> undeclaredList [
	
	^ undefined
]

{ #category : #initialization }
ModuleViewer >> undeclaredListTab [
	
	^ NotebookPage
		title: 'Undeclareds'
		provider: (undefined := self instantiate: WidgetClassList)
]

{ #category : #accessing }
ModuleViewer >> undefined [
	^ undefined
]

{ #category : #accessing }
ModuleViewer >> undefinedIn: module [
^ (module undeclaredNames).
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenClassChanged: aBlock [
classes whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenImportChanged: aBlock [
imports whenSelectedItemChanged: aBlock

]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenModuleChanged: aBlock [
modules whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenUndefinedchanged: aBlock [
undefined whenSelectedItemChanged: aBlock
]
