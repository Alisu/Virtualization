Class {
	#name : #NesTalkVirtualizationExample,
	#superclass : #Object,
	#instVars : [
		'module',
		'virtualizer'
	],
	#category : #'Virtualization-Scenarios'
}

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> SoureCodeMethodForOrdered [
	^'= anotherCollection

		^self includesAll: anotherCollection'
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> SoureCodeMethodForString1 [
	^'new: sizeRequested 
		self isString
		ifTrue:[^ByteString new: sizeRequested]
		ifFalse:[^self basicNew: sizeRequested]'
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> SoureCodeMethodForString2 [
	^'isString ^true'
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> buildHypervisor [

	| strategy |
	strategy := VirtualizationKernelIndirectionClassStrategy new
		nextStrategy: VirtualizationDeclareVariableStrategy new.
	virtualizer := Virtualizer new.
	virtualizer virtualizedModule: module.
	virtualizer declareUndeclaredNamesAsImports.
	virtualizer createVirtualizationLayer: strategy.
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> buildModule [

| repository versionInfo version |
repository := MCHttpRepository
	location: 'http://smalltalkhub.com/mc/zeroflag/NesTalk/main'
	user: ''
	password: ''.
	
versionInfo := repository versionInfoFromVersionNamed: 'NesTalk'.
version := repository versionWithInfo: versionInfo.

module := MLModule createFromSnapshot: version snapshot moduleName: #NesTalk.
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> configureHypervisor [
| virtualizationLayer |
virtualizationLayer := virtualizer virtualizationLayer.

	virtualizationLayer compileMethod: self SoureCodeMethodForOrdered inClass: (virtualizationLayer classNamed: #OrderedCollection).
	virtualizationLayer declareImport: #ByteString from: #Kernel.
	virtualizationLayer bindTo: virtualizationLayer defaultNameResolver.
	virtualizationLayer compileMethod: self SoureCodeMethodForString1 inClass: (virtualizationLayer classNamed: #String) class.
	virtualizationLayer compileMethod: self SoureCodeMethodForString2 inClass: (virtualizationLayer classNamed: #String) class.
	self flag: #Bad. "We need only to do this in one place not all of them"
	"self do: #binaryReadStreamDo: insteadOf: #readStreamDo:.
	self do: #nothing insteadOf: #binary."
	
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> do: aSelector insteadOf: anotherSelector [
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
NesTalkVirtualizationExample >> forcePerformASTReplacement [

| allMethods allMessagesNodes nodesToAddML |
allMethods := module classes
		flatCollect: [ :each | each instanceSide methods , each classSide methods ].
allMessagesNodes:= allMethods flatCollect: [:method | method sendNodes ].
nodesToAddML:=allMessagesNodes select: [:aNode| ((module extensionClassNamed: #Integer) methodDictionary keys) includes: aNode selector ].

allMessagesNodes do: [:each | | newMessageSend |
            newMessageSend := RBMessageNode new.
            newMessageSend selector: #perform:withArguments:.
            newMessageSend receiver: each receiver.
            newMessageSend arguments: { RBLiteralValueNode value: each selector . RBArrayNode statements: each arguments }.
            each replaceWith: newMessageSend ].
allMethods do:[:each | each recompile].
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> forcePerformMetalink [

| allMethods allMessagesNodes nodesToAddML ml |
allMethods := module classes
		flatCollect: [ :each | each instanceSide methods , each classSide methods ].
allMessagesNodes:= allMethods flatCollect: [:method | method sendNodes ].
nodesToAddML:=allMessagesNodes select: [:aNode| ((module extensionClassNamed: #Integer) methodDictionary keys) includes: aNode selector ].

ml := MetaLink new
		metaObject: #receiver;
		selector: #perform:withArguments:;
		control: #instead;
		arguments: #(selector arguments).

nodesToAddML do: [:each | each link: ml].
]

{ #category : #'as yet unclassified' }
NesTalkVirtualizationExample >> getAllMessageNodes: aSelector [
	| allMethods allMessagesNodes nodesToAddML |
	allMethods := module classes
		flatCollect: [ :each | each instanceSide methods , each classSide methods ].
	allMessagesNodes:= allMethods flatCollect: [:method | method sendNodes ].
	nodesToAddML:=allMessagesNodes select: [:aNode| aNode selector = aSelector ].
	^nodesToAddML 
]

{ #category : #accessing }
NesTalkVirtualizationExample >> module [
	^ module
]

{ #category : #accessing }
NesTalkVirtualizationExample >> module: anObject [
	module := anObject
]

{ #category : #accessing }
NesTalkVirtualizationExample >> virtualizer [
	^ virtualizer
]

{ #category : #accessing }
NesTalkVirtualizationExample >> virtualizer: anObject [
	virtualizer := anObject
]
