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

{ #category : #virtuali }
Virtualizer >> loadClassesForVirtualizationLayer [

	| definitions |
	definitions := self retrieveClassesForVirtualizationLayer.
	"Checking virtualization layer exist"
	virtualizationLayer isNil
		ifTrue: [ virtualizationLayer := MLModule
				newNamed: virtualizedModule name , 'VirtualizationLayer' ].
	"Doing 2 passes, 1st is for classes"
	definitions
		do: [ :aDefinition | 
			(aDefinition isClassDefinition
				and: [ (virtualizationLayer definesClassNamed: aDefinition className) not ])
				ifTrue: [ virtualizationLayer declareClass: aDefinition asRBClassDefinition ] ].
	"2nd passes is for method"
	definitions
		do: [ :aDefinition | 
			aDefinition isMethodDefinition
				ifTrue: [ virtualizationLayer
						compileMethod: aDefinition source
						inClass:
							(virtualizationLayer
								classNamed: aDefinition className
								ifAbsent: [ virtualizationLayer declareClassNamed: aDefinition className ]) ] ].
]

{ #category : #virtuali }
Virtualizer >> loadImportsForVirtualizationLayer [

	"Checking virtualization layer exist"
	virtualizationLayer isNil
		ifTrue: [ virtualizationLayer := MLModule
				newNamed: virtualizedModule name , 'VirtualizationLayer' ].
self retrieveImportsForVirtualizationLayer do: [:import| virtualizationLayer declareImport: import importedName from: import moduleName as: import aliasName  ]
]

{ #category : #'as yet unclassified' }
Virtualizer >> loadVirtualizationLayer [

	self loadClassesForVirtualizationLayer.
	self loadImportsForVirtualizationLayer.
]

{ #category : #virtuali }
Virtualizer >> retrieveClassesForVirtualizationLayer [
	"i think we should at least save the imports too"
	|path|
	path := FileSystem workingDirectory / self virtualizationLayerName.
	^(TonelReader on: path fileName: 'Classes') loadDefinitions definitions.

]

{ #category : #virtuali }
Virtualizer >> retrieveImportsForVirtualizationLayer [

|path importsToAdd|

importsToAdd := Set new.
path:=(FileSystem workingDirectory / virtualizationLayer name / 'Imports').
path createDirectory.
	FileSystem disk filesAt: path do:  [:file| file asFileReference readStreamDo: [ :s |
	importsToAdd add: (STON fromStream: s) ]].
^importsToAdd
]

{ #category : #virtuali }
Virtualizer >> saveClassesFromVirtualizationLayer [
	"i think we should at least save the imports too"

	| path aFileRef |
	path := FileSystem workingDirectory / virtualizationLayer name
		/ 'Classes'.
	path createDirectory.
	virtualizationLayer environment
		valuesDo: [ :aClass | 
			aFileRef := path / aClass name , 'st'.
			TonelWriter
				exportClass: aClass
				on: (File named: aFileRef fullName) writeStream ]
]

{ #category : #virtuali }
Virtualizer >> saveImportsFromVirtualizationLayer [
	"i think we should at least save the imports too"
|path|
path:=(FileSystem workingDirectory / virtualizationLayer name / 'Imports').
path createDirectory.
	virtualizationLayer imports
		do: [:import| (path / import aliasName) writeStreamDo: [ :s |
	STON put: import onStreamPretty: s ]]
]

{ #category : #'as yet unclassified' }
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
