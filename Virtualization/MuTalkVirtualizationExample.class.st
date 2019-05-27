"
All the methods to recreate the mutalk scenario

All the methods install* are not tested

You also need to add methods required in testCoverage yourself
"
Class {
	#name : #MuTalkVirtualizationExample,
	#superclass : #Object,
	#instVars : [
		'module',
		'virtualizer'
	],
	#category : #'Virtualization-Scenarios'
}

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> buildHypervisor [
	| strategy |
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

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> configureHypervisor [

| example classes ts suites |
example := MuTalkVirtualizationExample new buildModule; buildHypervisor.
example do: #sourceCode insteadOf: #getSource.
example do: #failureCount insteadOf: #failuresSize.
example do: #errorCount insteadOf: #errorsSize.
example installMethodclassselector.
example installMetalinkOninstallsourcefrom .
classes := (module classes select: [:class | (class allSuperclasses includes: TestCase)]) .

ts := TestSuite named: 'Super suite'.
suites := classes do: [:class | ts addTest: class buildSuite ].
ts run

]

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> do: aSelector insteadOf: anotherSelector [
	| nodes |
	nodes := self getAllMessageNodes: anotherSelector.
	nodes
		do: [ :aNode | 
			| metalink |
			metalink := MetaLink new
				metaObject: #receiver;
				selector: aSelector;
				control: #instead.
			aNode link: metalink ].
		^ true
]

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> getAllMessageNodes: aSelector [
	| allMethods allMessagesNodes nodesToAddML |
	allMethods := module classes
		flatCollect: [ :each | each instanceSide methods , each classSide methods ].
	allMessagesNodes:= allMethods flatCollect: [:method | method sendNodes ].
	nodesToAddML:=allMessagesNodes select: [:aNode| aNode selector = aSelector ].
	^nodesToAddML 
]

{ #category : #'instance creation' }
MuTalkVirtualizationExample >> installMetalinkOninstallsourcefrom [
	| ml node |
	ml := MetaLink new.
	ml
		metaObject: [ :context | 
			[ (context tempNamed: 'aClass')
				compile: (context tempNamed: 'aSourceCode') ]
				on: Exception
				do: [ (context receiver class environment at: #MethodInstallerException)
						signal ] ].
	ml selector: #value:.
	ml arguments: #(context).
	ml control: #instead.
	node := (module at: #MethodInstaller)
		methodNamed: #installFromSource:in: ast.
	node link: ml
]

{ #category : #'instance creation' }
MuTalkVirtualizationExample >> installMethodclassselector [
	(virtualizer virtualizationLayer at: #MethodReference)
		compile:
			'class: aClass selector: aString 
	 
		^aClass methods detect:[:each | each selector = aString]'
]

{ #category : #accessing }
MuTalkVirtualizationExample >> module [
	^ module
]

{ #category : #'as yet unclassified' }
MuTalkVirtualizationExample >> transformGetSource [
	| nodes |
	nodes := self getAllMessageNodes: #getSource.
	nodes
		do: [ :aNode | 
			| metalink |
			metalink := MetaLink new
				metaObject: #receiver;
				selector: #sourceCode;
				control: #instead.
			aNode link: metalink ].
		^ true
]
