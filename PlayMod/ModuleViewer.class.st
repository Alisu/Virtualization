"
(ModuleViewer on: MLModuleRegistry global) openWithSpec.
"
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
		'extensionList',
		'undeclaredList',
		'classList',
		'importList',
		'variableList'
	],
	#category : #'PlayMod-Modules-Imports-Classes'
}

{ #category : #specs }
ModuleViewer class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | row add: #menu ] height: self toolbarHeight;
		newRow: [ :row | 
			row
				add: #modules width: 200;
				add: #moduleContentsNotebook ];
		newRow: [ :row | row add: #definitionsNotebook ];
		yourself
]

{ #category : #example }
ModuleViewer class >> example [
	<sampleInstance>

	(ModuleViewer on: MLModuleRegistry global) openWithSpec.
]

{ #category : #class }
ModuleViewer >> acceptClassDefinition: aText [
	
	| aDefinition |
	aDefinition := CDClassDefinitionParser parse: aText asString.
	aDefinition isClassDefinition
	ifTrue:[self selectedModule declareClass: aDefinition.]
	ifFalse:[self selectedModule declareTrait: aDefinition.].
	
	self refreshClasses.
]

{ #category : #class }
ModuleViewer >> acceptImportDefinition: aText [
	|import|
	import := OpalCompiler new evaluate: aText.
	self selectedModule addImport: import.
	import module: self selectedModule.
	self refreshImports.
]

{ #category : #method }
ModuleViewer >> acceptMethodText: aText [
	
	self selectedClass compile: aText.
	self classList refreshMethods
]

{ #category : #actions }
ModuleViewer >> acceptModuleDefinition: aText [

	|module|
	module := OpalCompiler new evaluate: aText.
	moduleRegistry registerModule: module.
	self refreshModuleList.
]

{ #category : #initialization }
ModuleViewer >> buildClassContextMenu [
	^ self newMenu
				addItem: [ :item | 
					item
						name: 'Remove';
						action: [ self selectedClass environment removeClassNamed: self selectedClass name.
							self refreshClasses.] ];
				addItem: [ :item | 
					item
						name: 'Inspect';
						action: [ self selectedClass inspect] ].
]

{ #category : #'as yet unclassified' }
ModuleViewer >> buildDefinitionNotebook: aPage [.
	
	self flag: #BadCode. "Have the string Imports and Classes as variables somewhere pls"

	"remove all definition except module definition page"
	definitionsNotebook removeLastPages: definitionsNotebook pagesNumber - 1.
	
	"add the correct pages in definition panel according to the page selected"
	(aPage title = 'Imports')
		ifTrue:[  definitionsNotebook 
			addPage: self importDefinitionTab.
			].
	(aPage title = 'Classes')
		ifTrue:[definitionsNotebook 
			addPage: self classDefinitionTab;
			addPage: self methodDefinitionTab.
			].
		self needRebuild: false.
		self buildWithSpec.
	
]

{ #category : #initialization }
ModuleViewer >> buildImportContextMenu [
	^ self newMenu
				addItem: [ :item | 
					item
						name: 'Remove';
						action: [ self selectedModule removeImport: self selectedImport aliasName.
										self refreshImports.] ];
				addItem: [ :item | 
					item
						name: 'Inspect';
						action: [ self selectedImport inspect] ].
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
								name: 'Import package...';
								action: [ self importModule ] ];
						addItem: [ :subitem | 
							subitem
								name: 'Import module...';
								action: [ self importModule ] ]) ] ].
]

{ #category : #initialization }
ModuleViewer >> buildMethodContextMenu [
	^ self newMenu
				addItem: [ :item | 
					item
						name: 'Remove';
						action: [ self flag: #bug. "Next call is a method with bug flag"
							self  selectedMethod methodClass environment removeSelector: self selectedMethod selector fromClassNamed: self selectedMethod methodClass name.
							self refreshMethods.] ];
				addItem: [ :item | 
					item
						name: 'Inspect';
						action: [ self selectedMethod inspect] ].
]

{ #category : #initialization }
ModuleViewer >> buildModuleContextMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Remove';
				action: [ moduleRegistry removeKey: self selectedModule name.
					self refreshModuleList ] ];
		addItem: [ :item | 
			item
				name: 'Rename';
				action: [ self selectedModule name: self selectedModule name , '(copy)'.
					self refreshModuleList ] ];
		addItem: [ :item | 
			item
				name: 'Copy';
				action: [ | newModule |
					newModule := self selectedModule
						copyWithName: self selectedModule name , '-copy'.
					moduleRegistry registerModule: newModule.
					self refreshModuleList ] ];
		addItem: [ :item | 
			item
				name: 'Inspect';
				action: [ self selectedModule inspect ] ];
		addItem: [ :item | 
			item
				name: 'Bind imports to registry';
				action: [ self selectedModule bindTo: moduleRegistry ] ]
]

{ #category : #initialization }
ModuleViewer >> buildToolBarMenu [

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
								name: 'Import package...';
								action: [ self importModule ] ];
						addItem: [ :subitem | 
							subitem
								name: 'Import module...';
								action: [ self importModule ] ]) ] ].
]

{ #category : #initialization }
ModuleViewer >> buildUndeclaredContextMenu [
	^ self newMenu
				addItem: [ :item | 
					item
						name: 'Declare as import';
						action: [ self error: 'Feature not implemented'.
							self refreshClasses.] ].

]

{ #category : #class }
ModuleViewer >> classDefinitionTab [
	
	^ NotebookPage
		title: 'Class definition'
		provider: [ 
			self newText
				text: (self selectedClass ifNotNil: #definitionNew);
				acceptBlock: [ :someText | self acceptClassDefinition: someText ];
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
^ (module classesAndTraits).
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

{ #category : #tabs }
ModuleViewer >> extensionListTab [
		
		^ NotebookPage
		title: 'Extensions'
		provider: (extensionList := self instantiate: WidgetClassList)
]

{ #category : #initialize }
ModuleViewer >> importDefinitionTab [
	^ NotebookPage
		title: 'Import definition'
		provider: [ 
			self newText
				text: (self selectedImport ifNotNil: #printDeclaration);
				acceptBlock: [ :someText | self acceptImportDefinition: someText ];
				yourself ]
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
	self refreshDefinitionTabs.
	
	moduleContentsNotebook 
		whenSelectedPageChangedDo: [:page | self buildDefinitionNotebook: page].
	
	modules
		whenSelectionChangedDo: [ :selection | [ :module | self selectModule: module ] cull: selection selectedItem ].
	
	importList
		importContextMenu: self buildImportContextMenu;
		whenImportChanged: [ :import | import ifNotNil: [ importList resetSelection. self refreshDefinitionTabs ] ].
	
	classList
		classContextMenu: self buildClassContextMenu;
		methodContextMenu: self buildMethodContextMenu;
		whenSelectedClassChangedDo: [ :class | class ifNotNil: [ self refreshDefinitionTabs ] ];
		whenSelectedInstanceMethodChangedDo: [ :method | method ifNotNil: [ self refreshDefinitionTabs ] ];
		whenSelectedClassMethodChangedDo: [ :method | method ifNotNil: [ self refreshDefinitionTabs ] ].
	
	undeclaredList 
		classContextMenu: self buildUndeclaredContextMenu.
]

{ #category : #initialization }
ModuleViewer >> initializeWidgets [

	menu := self buildToolBarMenu.
	modules := self newList.
	modules contextMenu: self buildModuleContextMenu.
	
	moduleContentsNotebook := self newNotebook.
	moduleContentsNotebook
		addPage: self classListTab;
		addPage: self importListTab;
		addPage: self variableListTab;
		addPage: self undeclaredListTab;
		addPage: self extensionListTab.
	
	definitionsNotebook := self newNotebook.
	definitionsNotebook
		addPage: self moduleDefinitionTab.

	
	self focusOrder
		add: modules;
		add: importList;
		add: classList;
		add: undeclaredList;
		add: definitionsNotebook.

]

{ #category : #actions }
ModuleViewer >> initializeWindow: aWindow [

	aWindow initialExtent: 1000@800
]

{ #category : #method }
ModuleViewer >> instanceMethodDefinitionTab [
	^ NotebookPage
		title: 'Instance method definition'
		provider: [ 
			self newText
				"aboutToStyle: true;"
				text: (self selectedMethod ifNotNil: #sourceCode);
				acceptBlock: [ :someText | self acceptMethodText: someText ];
				yourself ]
]

{ #category : #method }
ModuleViewer >> methodDefinitionTab [
	^ NotebookPage
		title: 'method definition'
		provider: [ 
			self newText
				"aboutToStyle: true;"
				text: (self selectedMethod ifNotNil: #sourceCode);
				acceptBlock: [ :someText | self acceptMethodText: someText ];
				yourself ]
]

{ #category : #initialization }
ModuleViewer >> moduleDefinitionTab [
	
	^ NotebookPage
		title: 'Module definition'
		provider: [ 
			self newText
				"aboutToStyle: true;"
				text: (self selectedModule ifNotNil: #printDeclaration);
				acceptBlock: [ :someText | self acceptModuleDefinition: someText ];
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

	classList classes: (self classesIn: self selectedModule)
]

{ #category : #refreshing }
ModuleViewer >> refreshContentTabs [
	
	moduleContentsNotebook resetAllPageContents
]

{ #category : #refreshing }
ModuleViewer >> refreshDefinitionTabs [
	
	definitionsNotebook resetAllPageContents
]

{ #category : #initialization }
ModuleViewer >> refreshImports [

	importList imports: (self importsIn: self selectedModule)
]

{ #category : #initialization }
ModuleViewer >> refreshMethods [

	classList refreshMethods .
]

{ #category : #initialization }
ModuleViewer >> refreshModuleList [
	
	self modules items: (moduleRegistry moduleEnvironment values sorted: [:a :b | a name < b name ])
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
		variableList items: (self variableIn: aModule).
		self refreshDefinitionTabs. ]
]

{ #category : #initialization }
ModuleViewer >> selectedClass [

	^ classList selectedClass
]

{ #category : #'as yet unclassified' }
ModuleViewer >> selectedImport [
	^ importList selectedImport
]

{ #category : #method }
ModuleViewer >> selectedMethod [
	^ classList selectedMethod
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

{ #category : #accessing }
ModuleViewer >> variableIn: module [
^ (module variableNames).
]

{ #category : #accessing }
ModuleViewer >> variableList [
	^variableList 
]

{ #category : #'as yet unclassified' }
ModuleViewer >> variableListTab [
	^ NotebookPage
		title: 'Variables'
		provider: (variableList := self instantiate: WidgetClassList)
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
