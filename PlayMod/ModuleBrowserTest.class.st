Class {
	#name : #ModuleBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'registry',
		'module',
		'browser',
		'class'
	],
	#category : #'PlayMod-Tests'
}

{ #category : #tests }
ModuleBrowserTest >> setUp [
	super setUp.
	registry := MLModuleRegistry new.
	module := MLModule newNamed: 'fortest'.
	module declareImport: 'ImportedName'.
	module declareUndeclaredBinding: 'anUndeclaredName'.

	class := module declareClassNamed: 'MyClass'.
	module compileMethod: 'method ^42' inClass: class.
	
	registry registerModule: module.
	
	browser := ModuleViewer on: registry.

]

{ #category : #tests }
ModuleBrowserTest >> testSelectClassShowsMethods [

	browser selectModule: module.
	browser selectClass: class.
	
	self
		assert: browser shownMethods asSet
		equals: class methods asSet
]

{ #category : #tests }
ModuleBrowserTest >> testSelectModuleUpdatesClasses [

	browser selectModule: module.
	
	self
		assert: browser shownClasses asSet
		equals: module classes asSet
]

{ #category : #tests }
ModuleBrowserTest >> testSelectModuleUpdatesImports [

	browser selectModule: module.
	
	self
		assert: browser importList items asSet
		equals: module imports asSet
]

{ #category : #tests }
ModuleBrowserTest >> testSelectModuleUpdatesUndeclareds [

	browser selectModule: module.
	
	self
		assert: browser undeclaredList items asSet
		equals: module undeclaredNames asSet
]
