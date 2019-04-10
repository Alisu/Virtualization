Class {
	#name : #ModuleViewer,
	#superclass : #ComposablePresenter,
	#instVars : [
		'modules',
		'moduleList',
		'moduleRegistry',
		'menu',
		'definitionsNotebook',
		'moduleContentsNotebook',
		'undeclaredList',
		'classList',
		'importList'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
ModuleViewer class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #menu ] height: self toolbarHeight;
		newRow: [ :row | 
			row
				add: #modules width: 100;
				add: #moduleContentsNotebook ];
		newRow: [ :row | row add: #definitionsNotebook ];
		yourself
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
	
	^ classList
]

{ #category : #initialization }
ModuleViewer >> classListTab [
	
	^ NotebookPage
		title: 'Classes'
		provider: (classList := self instantiate: ClassMethodModuleBrowser)
]

{ #category : #accessing }
ModuleViewer >> classes [
	^ classList
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

{ #category : #accessing }
ModuleViewer >> definitionsNotebook [
	^ definitionsNotebook
]

{ #category : #components }
ModuleViewer >> importList [
	
	^ importList
]

{ #category : #initialization }
ModuleViewer >> importListTab [
	
	^ NotebookPage
		title: 'Imports'
		provider: (importList := self instantiate: ImportViewer)
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
	^ importList
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
	importList 
		whenImportChanged: [ :import | import ifNotNil: [ importList resetSelection ] ].
	classList whenSelectedClassChangedDo: [ :class | 
		class ifNotNil: [ self refreshTabs ] ]
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
		add: importList;
		add: classList;
		add: undeclaredList;
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

	classList items: (self classesIn: self selectedModule)
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

{ #category : #selection }
ModuleViewer >> selectClass: aClass [ 
	
	classList selectClass: aClass
]

{ #category : #initialization }
ModuleViewer >> selectModule: aModule [

	importList unselectAll.
	classList unselectAll.
	
	aModule ifNil: [
		importList items: #().
		classList items: #().
		undeclaredList items: #().
		definitionsNotebook text: ''.
		definitionsNotebook behavior: nil. ]
			ifNotNil: [
		importList imports: (self importsIn: aModule).
		classList classes: (self classesIn: aModule).
		undeclaredList items: (self undefinedIn: aModule).
		self refreshTabs ]
]

{ #category : #initialization }
ModuleViewer >> selectedClass [

	^ classList selectedItem
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
ModuleViewer >> shownClasses [
	
	^ classList classes
]

{ #category : #accessing }
ModuleViewer >> shownMethods [

	^ classList methods
]

{ #category : #initialization }
ModuleViewer >> title [
^ 'Module viewer'
]

{ #category : #components }
ModuleViewer >> undeclaredList [
	
	^ undeclaredList
]

{ #category : #initialization }
ModuleViewer >> undeclaredListTab [
	
	^ NotebookPage
		title: 'Undeclareds'
		provider: (undeclaredList := self instantiate: WidgetClassList)
]

{ #category : #accessing }
ModuleViewer >> undefined [
	^ undeclaredList
]

{ #category : #accessing }
ModuleViewer >> undefinedIn: module [
^ (module undeclaredNames).
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenClassChanged: aBlock [
classList whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenImportChanged: aBlock [
importList whenSelectedItemChanged: aBlock

]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenModuleChanged: aBlock [
modules whenSelectedItemChanged: aBlock
]

{ #category : #'as yet unclassified' }
ModuleViewer >> whenUndefinedchanged: aBlock [
undeclaredList whenSelectedItemChanged: aBlock
]
