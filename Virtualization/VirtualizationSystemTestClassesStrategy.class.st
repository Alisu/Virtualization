"
I am a strategy for creating a virtualization layer module.
My strategy is to bind some classes directly to the system.

"
Class {
	#name : #VirtualizationSystemTestClassesStrategy,
	#superclass : #VirtualizationStrategy,
	#instVars : [
		'classes'
	],
	#category : #'Virtualization-Strategies'
}

{ #category : #accessing }
VirtualizationSystemTestClassesStrategy >> classes [
	^ classes
]

{ #category : #accessing }
VirtualizationSystemTestClassesStrategy >> classes: anObject [
	classes := anObject
]

{ #category : #initialization }
VirtualizationSystemTestClassesStrategy >> initialize [ 
self nextStrategy: VirtualizationLogClassStrategy new.
classes:= OrderedCollection new.
classes add: #TestCase; add:#BabyMockTestCase.
]

{ #category : #initialization }
VirtualizationSystemTestClassesStrategy >> initializeVirtualizationLayer: aVirtualizationModule [
"We do nothing, the classes are going to be bind to the system so no need to touch the virtualization module"
]

{ #category : #initialization }
VirtualizationSystemTestClassesStrategy >> resolveName: import inVirtualizer: virtualizer [

(classes includes: import aliasName)
		ifTrue: [ 	
			import bindingSourceName: #Kernel.
			import resolveUsing: virtualizer virtualizedModule defaultNameResolver ]
		ifFalse: [ 
			nextStrategy initializeVirtualizationLayer: virtualizer virtualizationLayer.
			nextStrategy resolveName: import inVirtualizer: virtualizer ].
]
