Class {
	#name : #ModuleBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'registry',
		'module',
		'browser'
	],
	#category : #'PlayMod-Tests'
}

{ #category : #tests }
ModuleBrowserTest >> setUp [
	super setUp.
	registry := MLModuleRegistry new.
	module := MLModule newNamed: 'fortest'.
	module declareImport: 'ImportedName'.
	module declareClassNamed: 'MyClass'.
	module declareUndeclaredBinding: 'anUndeclaredName'.
	
	registry registerModule: module.
	
	browser := ModuleViewer on: registry.

]

{ #category : #tests }
ModuleBrowserTest >> testSelectModuleUpdatesClasses [

	browser selectModule: module.
	
	self
		assert: browser classList items asSet
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
