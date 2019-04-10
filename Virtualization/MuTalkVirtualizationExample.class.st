Class {
	#name : #MuTalkVirtualizationExample,
	#superclass : #Object,
	#category : #'Virtualization-Scenarios'
}

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> buildModule [
	| repository versionInfo version module strategy virtualizer |
	repository := MCHttpRepository
		location: 'http://www.squeaksource.com/MutationTesting'
		user: ''
		password: ''.
	versionInfo := repository
		versionInfoFromVersionNamed: 'MutationTesting'.
	version := repository versionWithInfo: versionInfo.
	module := MLModule
		createFromSnapshot: version snapshot
		moduleName: 'SNAP'.
	strategy := VirtualizationKernelIndirectionClassStrategy new
		nextStrategy: VirtualizationDeclareVariableStrategy new.
	virtualizer := Virtualizer new.
	virtualizer virtualizedModule: module.
	virtualizer declareUndeclaredNamesAsImports.
	virtualizer createVirtualizationLayer: strategy.
	(module at: #MutationScoreTest) buildSuite
]
