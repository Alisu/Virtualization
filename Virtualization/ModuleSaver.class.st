"
I am in charge of saving module parts in files.
"
Class {
	#name : #ModuleSaver,
	#superclass : #Object,
	#category : #'Virtualization-Save/Load'
}

{ #category : #'load and saving' }
ModuleSaver class >> saveClassesFrom: aModule [

	| path aFileRef |
	path := FileSystem workingDirectory / aModule name
		/ 'Classes'.
	path createDirectory.
	aModule environment
		valuesDo: [ :aClass | 
			aFileRef := path / aClass name , 'st'.
			TonelWriter
				exportClass: aClass
				on: (File named: aFileRef fullName) writeStream ]
]

{ #category : #'load and saving' }
ModuleSaver class >> saveImportsFrom: aModule [

|path|
path:=(FileSystem workingDirectory / aModule name / 'Imports').
path createDirectory.
	aModule imports
		do: [:import| (path / import aliasName) writeStreamDo: [ :s |
	STON put: import onStreamPretty: s ]]
]
