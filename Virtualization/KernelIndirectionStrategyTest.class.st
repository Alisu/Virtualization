Class {
	#name : #KernelIndirectionStrategyTest,
	#superclass : #StrategyVirtualizationTest,
	#category : #'Virtualization-Test'
}

{ #category : #tests }
KernelIndirectionStrategyTest >> testNonSystemClassUseNextStrategyLogClass [

	virtualizer virtualizedModule declareImport: #DefinitivelyNotAClass.
	virtualizer createVirtualizationLayer: (self kernelIndirectionStrategy nextStrategy: self logStrategy).
	
	self assert: (virtualizer virtualizationLayer classNamed: #DefinitivelyNotAClass ifAbsent: [  ]) superclass equals: (Smalltalk at: self logclassName).
]

{ #category : #tests }
KernelIndirectionStrategyTest >> testVirtualizationModuleClassesInheritsFromSystem [

	virtualizer createVirtualizationLayer: self kernelIndirectionStrategy .
	
	self assert: (virtualizer virtualizationLayer classNamed: (self undefinedSuperclass) ifAbsent: [  ]) superclass equals: (Smalltalk at: (self undefinedSuperclass)).
]

{ #category : #tests }
KernelIndirectionStrategyTest >> testVirtualizationModuleIsNotEmpty [

	virtualizer createVirtualizationLayer: self kernelIndirectionStrategy.
	self assert: virtualizer virtualizationLayer environment size equals: 1
]
