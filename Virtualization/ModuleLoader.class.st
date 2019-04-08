"
I am in charge of loading module parts from files.
"
Class {
	#name : #ModuleLoader,
	#superclass : #Object,
	#category : #'Virtualization-Save/Load'
}

{ #category : #'load and saving' }
ModuleLoader class >> loadClassesFor: aModule [

	| definitions |
	definitions := self retrieveClassesFor: aModule.

	"Doing 2 passes, 1st is for classes"
	definitions
		do: [ :aDefinition | 
			(aDefinition isClassDefinition
				and: [ (aModule definesClassNamed: aDefinition className) not ])
				ifTrue: [ aModule declareClass: aDefinition asRBClassDefinition ] ].
	"2nd passes is for method"
	definitions
		do: [ :aDefinition | 
			aDefinition isMethodDefinition
				ifTrue: [ aModule
						compileMethod: aDefinition source
						inClass:
							(aModule
								classNamed: aDefinition className
								ifAbsent: [ aModule declareClassNamed: aDefinition className ]) ] ].
]

{ #category : #'load and saving' }
ModuleLoader class >> loadImportsFor: aModule [

(self retrieveImportsFor: aModule) do: [:import| aModule declareImport: import importedName from: import moduleName as: import aliasName  ]
]

{ #category : #'load and saving' }
ModuleLoader class >> retrieveClassesFor: aModule [
	"i think we should at least save the imports too"
	|path|
	path := FileSystem workingDirectory / aModule name.
	^(TonelReader on: path fileName: 'Classes') loadDefinitions definitions.

]

{ #category : #'load and saving' }
ModuleLoader class >> retrieveImportsFor: aModule [

|path importsToAdd|

importsToAdd := Set new.
path:=(FileSystem workingDirectory / aModule name / 'Imports').
path createDirectory.
	FileSystem disk filesAt: path do:  [:file| file asFileReference readStreamDo: [ :s |
	importsToAdd add: (STON fromStream: s) ]].
^importsToAdd
]
