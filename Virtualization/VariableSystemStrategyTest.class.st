Class {
	#name : #VariableSystemStrategyTest,
	#superclass : #StrategyVirtualizationTest,
	#category : #'Virtualization-Test'
}

{ #category : #tests }
VariableSystemStrategyTest >> testTestClassIsTheSystemTestClass [

	virtualizer createVirtualizationLayer: self declareVariableStrategy.
	
	self	assert: (virtualizer virtualizationLayer variableNames includes: self undefinedSuperclass).
]

{ #category : #tests }
VariableSystemStrategyTest >> testVirtualizationModuleVariableIsEmpty [

	virtualizer createVirtualizationLayer: self systemTestClassStrategy.
	self assert: virtualizer virtualizationLayer variableNames isEmpty.
]
