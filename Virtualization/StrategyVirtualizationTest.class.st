Class {
	#name : #StrategyVirtualizationTest,
	#superclass : #VirtualizationTest,
	#category : #'Virtualization-Test'
}

{ #category : #setup }
StrategyVirtualizationTest >> declareVariableStrategy [

	^ VirtualizationDeclareVariableStrategy new.
]

{ #category : #setup }
StrategyVirtualizationTest >> kernelIndirectionStrategy [

	^ VirtualizationKernelIndirectionClassStrategy new.
]

{ #category : #tests }
StrategyVirtualizationTest >> logStrategy [

	^ VirtualizationLogClassStrategy new.

]

{ #category : #tests }
StrategyVirtualizationTest >> logclassName [
^#LogClass
]

{ #category : #running }
StrategyVirtualizationTest >> setUp [
	super setUp.
	virtualizer declareUndeclaredNamesAsImports.
	
	
]

{ #category : #setup }
StrategyVirtualizationTest >> systemTestClassStrategy [

	^ VirtualizationSystemTestClassesStrategy new.
]
