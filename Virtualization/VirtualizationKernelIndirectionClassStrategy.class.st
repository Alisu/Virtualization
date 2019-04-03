"
I am a strategy for creating a virtualization layer module.
My strategy is to create all the import classes in the layer module and make them inherits from the one in the system.

"
Class {
	#name : #VirtualizationKernelIndirectionClassStrategy,
	#superclass : #VirtualizationStrategy,
	#category : #'Virtualization-Strategies'
}

{ #category : #'as yet unclassified' }
VirtualizationKernelIndirectionClassStrategy >> initializeVirtualizationLayer: aVirtualizationModule [
"We do nothing we don't need a prerequisites for this strategy"
]

{ #category : #'as yet unclassified' }
VirtualizationKernelIndirectionClassStrategy >> resolveName: import inVirtualizer: aVirtualizer [
	
	"Change Smalltalk at: to Kernel module at:"
	
	((MLModuleRegistry global
		definesName: import aliasName
		inModuleNamed: #Kernel) and: [ (Smalltalk at: import aliasName) isClass ])
		ifTrue: [ aVirtualizer virtualizationLayer
				declareClass:
					(CDClassDefinitionParser
						parse: import aliasName, 'Kernel subclass: ' , import aliasName).
				aVirtualizer virtualizationLayer
				declareImport: import aliasName
				from: #Kernel
				as: import aliasName , 'Kernel'.
			import bindingSourceName: aVirtualizer virtualizationLayer name]
		ifFalse: [ nextStrategy
				initializeVirtualizationLayer: aVirtualizer virtualizationLayer.
			nextStrategy resolveName: import inVirtualizer: aVirtualizer ]
]
