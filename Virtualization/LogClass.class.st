"
I am a class that create the selector expected by doesNotUnderstand:
I am used for virtualisation layer skeleton.
"
Class {
	#name : #LogClass,
	#superclass : #Object,
	#category : #'Virtualization-Core'
}

{ #category : #'reflective operations' }
LogClass class >> doesNotUnderstand: aMessage [

	self class compile: (self methodAsStringNamedFrom: aMessage) classified: 'ShouldImplement'.
	^self perform: aMessage selector.
]

{ #category : #'reflective operations' }
LogClass class >> methodAsStringNamedFrom: aMessage [

	aMessage selector isUnary ifFalse: [ self halt ].
	^aMessage selector, String cr,' self shouldBeImplemented'
]

{ #category : #'reflective operations' }
LogClass >> doesNotUnderstand: aMessage [
	"self class compile: (self methodAsStringNamedFrom: aMessage) classified: 'ShouldImplement'.
	^self perform: aMessage selector."
	aMessage logCr.
	
]

{ #category : #Accessing }
LogClass >> methodAsStringNamedFrom: aMessage [

	aMessage selector isUnary ifFalse: [ self halt ].
	^aMessage selector, String cr,' self shouldBeImplemented'
]
