Class {
	#name : #VirtualizationTest,
	#superclass : #TestCase,
	#instVars : [
		'virtualizer'
	],
	#category : #'Virtualization-Test'
}

{ #category : #running }
VirtualizationTest >> createModule [
	
	| module |
	module:=MLModule newNamed: #VirtualizationModuleTest.
	module declareClass: (CDClassDefinitionParser parse: self undefinedSuperclass,' subclass: #Pouet').
	^module.
	
	
	


]

{ #category : #running }
VirtualizationTest >> setUp [
	virtualizer := Virtualizer new.
	virtualizer virtualizedModule: self createModule.
	
]

{ #category : #tests }
VirtualizationTest >> testUndeclaredBecomeImportAtInitialization [
	
	virtualizer declareUndeclaredNamesAsImports.
	
	self assert: virtualizer virtualizedModule undeclaredBindings isEmpty.
	self assert: virtualizer virtualizedModule imports isNotEmpty.

]

{ #category : #running }
VirtualizationTest >> undefinedSuperclass [
	^#Object.
	
	
	


]
