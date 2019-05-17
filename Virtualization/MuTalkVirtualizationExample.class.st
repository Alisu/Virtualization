Class {
	#name : #MuTalkVirtualizationExample,
	#superclass : #Object,
	#instVars : [
		'module'
	],
	#category : #'Virtualization-Scenarios'
}

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> buildHypervisor [
	| strategy virtualizer |
	strategy := VirtualizationKernelIndirectionClassStrategy new
		nextStrategy: VirtualizationDeclareVariableStrategy new.
	virtualizer := Virtualizer new.
	virtualizer virtualizedModule: module.
	virtualizer declareUndeclaredNamesAsImports.
	virtualizer createVirtualizationLayer: strategy
]

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> buildModule [
	| repository versionInfo version |
	repository := MCHttpRepository
		location: 'http://www.squeaksource.com/MutationTesting'
		user: ''
		password: ''.
	versionInfo := repository
		versionInfoFromVersionNamed: 'MutationTesting'.
	version := repository versionWithInfo: versionInfo.
	module := MLModule
		createFromSnapshot: version snapshot
		moduleName: 'Mutalk'.
	^ module
]

{ #category : #accessing }
MuTalkVirtualizationExample >> module [
	^ module
]
