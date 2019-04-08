Class {
	#name : #ManagingVirtualizationLayerTest,
	#superclass : #VirtualizationTest,
	#category : #'Virtualization-Test'
}

{ #category : #running }
ManagingVirtualizationLayerTest >> setUp [
	super setUp.
	virtualizer virtualizedModule  declareClass: (CDClassDefinitionParser parse: 'PoPouet subclass: #PouetTest').
	virtualizer declareUndeclaredNamesAsImports.
	virtualizer createVirtualizationLayer: VirtualizationLogClassStrategy new.
	
]

{ #category : #'as yet unclassified' }
ManagingVirtualizationLayerTest >> testClassAreSaveInPackage [

self flag: #TODO. "Make a real assert test"
virtualizer saveClassesFromVirtualizationLayer.
]

{ #category : #'as yet unclassified' }
ManagingVirtualizationLayerTest >> testImportsAreSaveInPackage [

self flag: #TODO. "Make a real assert test"
virtualizer saveImportsFromVirtualizationLayer.
]

{ #category : #'as yet unclassified' }
ManagingVirtualizationLayerTest >> testSaveLayerInPackage [

self flag: #TODO. "Make a real assert test"
	virtualizer saveVirtualizationLayer
]

{ #category : #'as yet unclassified' }
ManagingVirtualizationLayerTest >> testloadClassesFromPackage [

virtualizer virtualizationLayer: nil.

self assert: virtualizer virtualizationLayer isNil.

virtualizer loadClassesForVirtualizationLayer.

self assert: virtualizer virtualizationLayer environment isNotEmpty.

]

{ #category : #'as yet unclassified' }
ManagingVirtualizationLayerTest >> testloadImportsFromPackage [

virtualizer virtualizationLayer: nil.

self assert: virtualizer virtualizationLayer isNil.

virtualizer loadImportsForVirtualizationLayer.

self assert: virtualizer virtualizationLayer imports isNotEmpty.



]

{ #category : #'as yet unclassified' }
ManagingVirtualizationLayerTest >> testloadLayer [

	virtualizer virtualizationLayer: nil.
	self assert: virtualizer virtualizationLayer isNil.
	virtualizer loadVirtualizationLayer.
	self assert: virtualizer virtualizationLayer environment isNotEmpty.
	self assert: virtualizer virtualizationLayer imports isNotEmpty.

]
