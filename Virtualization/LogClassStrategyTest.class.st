Class {
	#name : #LogClassStrategyTest,
	#superclass : #StrategyVirtualizationTest,
	#category : #'Virtualization-Test'
}

{ #category : #tests }
LogClassStrategyTest >> testVirtualizationModuleClassesInheritsFromLogClass [
	
	virtualizer createVirtualizationLayer: self logStrategy.
	self assert:(virtualizer virtualizationLayer classNamed: (self undefinedSuperclass) ifAbsent: [  ]) superclass equals: (Smalltalk at: (self logclassName ))
]

{ #category : #tests }
LogClassStrategyTest >> testVirtualizationModuleIsNotEmpty [
 	
	virtualizer createVirtualizationLayer: self logStrategy.
	
self assert: virtualizer virtualizationLayer environment isNotEmpty.
]

{ #category : #tests }
LogClassStrategyTest >> testVirtualizedModuleClassesInheritsFromLayer [	
	
	virtualizer createVirtualizationLayer: self logStrategy.
	self assert:(virtualizer virtualizedModule classNamed: #Pouet ifAbsent: [  ]) superclass equals: (virtualizer virtualizationLayer  classNamed: (self undefinedSuperclass ) ifAbsent:[]).
]
