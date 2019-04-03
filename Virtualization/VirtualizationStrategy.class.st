"
I am an abstract class for virtualization strategy
"
Class {
	#name : #VirtualizationStrategy,
	#superclass : #Object,
	#instVars : [
		'nextStrategy'
	],
	#category : #'Virtualization-Strategies'
}

{ #category : #'as yet unclassified' }
VirtualizationStrategy >> initialize [ 
self nextStrategy: VirtualizationLogClassStrategy new.
]

{ #category : #initialization }
VirtualizationStrategy >> initializeVirtualizationLayer: aVirtualizationModule [

	self subclassResponsibility 
]

{ #category : #accessing }
VirtualizationStrategy >> nextStrategy [
	^ nextStrategy
]

{ #category : #accessing }
VirtualizationStrategy >> nextStrategy: anObject [
	nextStrategy := anObject
]

{ #category : #initialization }
VirtualizationStrategy >> resolveName: aName inVirtualizer: aModule [
	self subclassResponsibility 
]
