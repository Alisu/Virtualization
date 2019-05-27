Extension { #name : #NotebookPresenter }

{ #category : #'*PlayMod' }
NotebookPresenter >> pagesNumber [
	^pagesHolder size
]

{ #category : #'*PlayMod' }
NotebookPresenter >> removeLastPages: aNumber [
	pagesHolder removeLast: aNumber
]
