"
I am a strategy for creating a virtualization layer module.
My strategy is to declare variable and take the one from the system from the one in the system.

"
Class {
	#name : #VirtualizationDeclareVariableStrategy,
	#superclass : #VirtualizationStrategy,
	#category : #'Virtualization-Strategies'
}

{ #category : #initialization }
VirtualizationDeclareVariableStrategy >> initializeVirtualizationLayer: aVirtualizationModule [
"nothing"
]

{ #category : #initialization }
VirtualizationDeclareVariableStrategy >> resolveName: import inVirtualizer: aVirtualizer [
	
	"Warning: It could be an object or a Trait"
	
	(Smalltalk globals includesKey: import aliasName)
		ifTrue: [ aVirtualizer virtualizationLayer
				declareVariableNamed: import aliasName
				withValue: (Smalltalk at: import aliasName).
				import bindingSourceName: aVirtualizer virtualizationLayer name.
				]
		ifFalse: [ nextStrategy
				initializeVirtualizationLayer: aVirtualizer virtualizationLayer.
			nextStrategy resolveName: import inVirtualizer: aVirtualizer ]
]
