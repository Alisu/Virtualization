"
I am the one in charge of creating a virtualization layer module for a given module
I use different strategies to achieve this purpose.

Warning:
We do not take into account method extension and Trait
"
Class {
	#name : #Virtualizer,
	#superclass : #Object,
	#instVars : [
		'virtualizedModule',
		'virtualizationLayer'
	],
	#category : #'Virtualization-Core'
}

{ #category : #virtuali }
Virtualizer >> createVirtualizationLayer: aVirtualizationStrategy [
	
	virtualizationLayer := MLModule newNamed: virtualizedModule name , 'VirtualizationLayer'.
	MLModuleRegistry global
		at: virtualizationLayer name
		put: virtualizationLayer.
		
	aVirtualizationStrategy initializeVirtualizationLayer: virtualizationLayer.
	virtualizedModule imports
		do: [ :import| aVirtualizationStrategy
						resolveName: import
						inVirtualizer: self ].
1halt.
	"Using bindToWithList can be a better idea"
	virtualizationLayer bindTo: MLModuleRegistry global.
	virtualizedModule bindTo: MLModuleRegistry global
]

{ #category : #declaration }
Virtualizer >> declareUndeclaredNamesAsImports [
	
	virtualizedModule undeclaredNames do: [ :anUName |
		anUName first isUppercase ifTrue: [ 
			virtualizedModule declareImport: anUName ] ].
]

{ #category : #'load and saving' }
Virtualizer >> loadClassesForVirtualizationLayer [

	"Checking virtualization layer exist"
	virtualizationLayer isNil
		ifTrue: [ virtualizationLayer := MLModule
				newNamed: virtualizedModule name , 'VirtualizationLayer' ].
 
ModuleLoader loadClassesFor: virtualizationLayer.
]

{ #category : #'load and saving' }
Virtualizer >> loadImportsForVirtualizationLayer [

	"Checking virtualization layer exist"
	virtualizationLayer isNil
		ifTrue: [ virtualizationLayer := MLModule
				newNamed: virtualizedModule name , 'VirtualizationLayer' ].
	ModuleLoader loadImportsFor: virtualizationLayer.
]

{ #category : #'load and saving' }
Virtualizer >> loadVirtualizationLayer [

	self loadClassesForVirtualizationLayer.
	self loadImportsForVirtualizationLayer.
]

{ #category : #'load and saving' }
Virtualizer >> retrieveClassesForVirtualizationLayer [

^ModuleLoader retrieveClassesFor: virtualizationLayer.

]

{ #category : #'load and saving' }
Virtualizer >> retrieveImportsForVirtualizationLayer [

^ModuleLoader retrieveImportsFor: virtualizationLayer.
]

{ #category : #'load and saving' }
Virtualizer >> saveClassesFromVirtualizationLayer [

	ModuleSaver saveClassesFrom: virtualizationLayer.
]

{ #category : #'load and saving' }
Virtualizer >> saveImportsFromVirtualizationLayer [

ModuleSaver saveImportsFrom: virtualizationLayer.
]

{ #category : #'load and saving' }
Virtualizer >> saveVirtualizationLayer [
	| path |
	path := FileSystem workingDirectory / virtualizationLayer name.
	path createDirectory.
	self saveClassesFromVirtualizationLayer.
	self saveImportsFromVirtualizationLayer
]

{ #category : #accessing }
Virtualizer >> virtualizationLayer [
	
	^ virtualizationLayer
]

{ #category : #accessing }
Virtualizer >> virtualizationLayer: anObject [

"should be used for test only"
	virtualizationLayer := anObject
]

{ #category : #accessing }
Virtualizer >> virtualizationLayerName [
 ^virtualizedModule name , 'VirtualizationLayer'.
]

{ #category : #accessing }
Virtualizer >> virtualizedModule [
	^ virtualizedModule
]

{ #category : #accessing }
Virtualizer >> virtualizedModule: aMLModule [ 
	
	virtualizedModule := aMLModule
]
