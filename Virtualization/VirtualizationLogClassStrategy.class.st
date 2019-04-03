"
I am a strategy for creating a virtualization layer module.

I am the default nextStrategy to others strategies (since i catch all the remainnings unbound import)

My strategy is to create all the import classes in the layer module and make them inherits from a LogClass.

"
Class {
	#name : #VirtualizationLogClassStrategy,
	#superclass : #VirtualizationStrategy,
	#category : #'Virtualization-Strategies'
}

{ #category : #initialization }
VirtualizationLogClassStrategy >> initialize [
	"Subclasses should redefine this method to perform initializations on instance creation" 
]

{ #category : #accessing }
VirtualizationLogClassStrategy >> initializeVirtualizationLayer: aVirtualizationModule [
	
	(aVirtualizationModule hasImportAliasNamed: #LogClass)
		ifTrue: [ ^ self ].
	aVirtualizationModule declareImport: #LogClass from: #Kernel.
	aVirtualizationModule bindTo: aVirtualizationModule defaultNameResolver
]

{ #category : #'as yet unclassified' }
VirtualizationLogClassStrategy >> resolveName: import inVirtualizer: aVirtualizer [

	aVirtualizer virtualizationLayer declareClass: (CDClassDefinitionParser parse: 'LogClass subclass: ' , import aliasName).
	import bindingSourceName: (aVirtualizer virtualizationLayer name).
]
