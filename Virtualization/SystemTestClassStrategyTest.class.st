Class {
	#name : #SystemTestClassStrategyTest,
	#superclass : #StrategyVirtualizationTest,
	#category : #'Virtualization-Test'
}

{ #category : #setup }
SystemTestClassStrategyTest >> classtestName [
^#TestCase
]

{ #category : #tests }
SystemTestClassStrategyTest >> testNonTestClassApplyNextStrategyKernelIndirection [
	
	virtualizer virtualizedModule
	declareImport: #Class.
	"it's the default value but we make sure"
	virtualizer createVirtualizationLayer: (self systemTestClassStrategy nextStrategy: self kernelIndirectionStrategy).
	
	self	assert:(virtualizer virtualizationLayer classNamed:#Class ifAbsent: [  ]) superclass equals: (Smalltalk at: #Class)
]

{ #category : #tests }
SystemTestClassStrategyTest >> testNonTestClassApplyNextStrategyLogClass [

	virtualizer virtualizedModule declareImport: #Class.
	virtualizer createVirtualizationLayer: (self systemTestClassStrategy nextStrategy: self logStrategy).
	
	self	assert:(virtualizer virtualizationLayer classNamed:#Class ifAbsent: [  ]) superclass equals: (Smalltalk at: self logclassName)
]

{ #category : #tests }
SystemTestClassStrategyTest >> testTestClassIsTheSystemTestClass [
	
	(virtualizer virtualizedModule) declareImport: #TestCase from: #Kernel.
	virtualizer createVirtualizationLayer: self systemTestClassStrategy.
	
	self	assert: (virtualizer virtualizedModule at: (self classtestName)) equals: (Smalltalk at: self classtestName)
]

{ #category : #tests }
SystemTestClassStrategyTest >> testVirtualizationModuleDoNotContainTestClass [

	virtualizer createVirtualizationLayer: self systemTestClassStrategy.
	self assert: virtualizer virtualizationLayer environment size equals: 1
]
