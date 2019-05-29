Class {
	#name : #FuelVirtualizationExample,
	#superclass : #Object,
	#instVars : [
		'module',
		'virtualizer'
	],
	#category : #'Virtualization-Scenarios'
}

{ #category : #'as yet unclassified' }
FuelVirtualizationExample >> buildHypervisor [
	| strategy |
	strategy := VirtualizationKernelIndirectionClassStrategy new
		nextStrategy: VirtualizationDeclareVariableStrategy new.
	virtualizer := Virtualizer new.
	virtualizer virtualizedModule: module.
	virtualizer declareUndeclaredNamesAsImports.
	virtualizer createVirtualizationLayer: strategy
]

{ #category : #'as yet unclassified' }
FuelVirtualizationExample >> buildModule [
	| x y repo versions definitions |
	Gofer it
		squeaksource: 'MetacelloRepository';
		package: 'ConfigurationOfFuel';
		load.
	"the script is bugged because it uses includesSubString: instead of includesSubstring:"
	x := (Smalltalk at: #ConfigurationOfFuel) project version: '1.6'.
	y := x
		fetchRequiredFromArray: (x defaultPackageNamesToLoad: #('default')).
	repo := MCRepository fromUrl: 'http://www.squeaksource.com/Fuel'.
	versions := y spec packages values
		collect: [ :e | repo versionFromFileNamed: e getFile , '.mcz' ].
	definitions := versions flatCollect: [ :e | e snapshot definitions ].
	module := MLModule
		createFromDefinitions: definitions
		moduleName: 'Fuel'.
	^ module
]
