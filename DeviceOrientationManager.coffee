"""
DeviceOrientationManager class

- heading         <number> readonly (degrees)
- elevation       <number> readonly (degrees)
- tilt            <number> readonly (degrees)
- compassHeading  <number> readonly (degrees)
- alpha           <number> readonly (degrees)
- beta            <number> readonly (degrees)
- gamma           <number> readonly (degrees)

class methods
- available() returns <bool>

events
- onOrientationChange (data {heading, elevation, tilt, compassHeading, alpha, beta, gamma})
"""

Events.OrientationChange = "orientationdidchange"
Events.OrientationDidChange = Events.OrientationChange

class exports.DeviceOrientationManager extends Framer.BaseClass

	constructor: ->
		window.addEventListener("deviceorientation", @_orientationUpdate)

	@define "heading",
		get: -> @_heading

	@define "elevation",
		get: -> @_elevation

	@define "tilt",
		get: -> @_tilt

	@define "compassHeading",
		get: -> @_compassHeading

	@define "alpha",
		get: -> @_alpha

	@define "beta",
		get: -> @_beta

	@define "gamma",
		get: -> @_gamma

	_orientationUpdate: (data) =>
		@_alpha = data.alpha
		@_beta = data.beta
		@_gamma = data.gamma
		@_compassHeading = data.compassHeading || data.webkitCompassHeading
		@_normalizeOrientation() if @_nonZeroOrientation()
		@_emitOrientationData()
	
	_emitOrientationData: =>
		data =
			alpha: @_alpha
			beta: @_beta
			gamma: @_gamma
			compassHeading: @_compassHeading
			heading: @_heading
			elevation: @_elevation
			tilt: @_tilt
		@emit(Events.OrientationDidChange, data)
	
	_nonZeroOrientation: =>
		a = @_alpha != 0
		b = @_beta != 0
		g = @_gamma != 0
		return a and b and g
	
	_normalizeOrientation: =>
		
		alphaRad = @degToRad(@_alpha)
		betaRad = @degToRad(@_beta)
		gammaRad = @degToRad(@_gamma)
		
		# Calculate equation components
		cA = Math.cos(alphaRad)
		sA = Math.sin(alphaRad)
		cB = Math.cos(betaRad)
		sB = Math.sin(betaRad)
		cG = Math.cos(gammaRad)
		sG = Math.sin(gammaRad)
		
		# x unitvector
		xrA = -sA * sB * sG + cA * cG
		xrB = cA * sB * sG + sA * cG
		xrC = cB * sG

		# y unitvector
		yrA = -sA * cB
		yrB = cA * cB
		yrC = -sB

		# -z unitvector
		zrA = -sA * sB * cG - cA * sG
		zrB = cA * sB * cG - sA * sG
		zrC = cB * cG
		
		# Calculate heading
		heading = Math.atan(zrA / zrB)
		# Convert from half unit circle to whole unit circle
		if zrB < 0
			heading += Math.PI
		else if zrA < 0
			heading += 2 * Math.PI
		
		# Calculate elevation
		elevation = Math.PI / 2 - Math.acos(-zrC)
		
		# Calculate tilt
		cH = Math.sqrt(1 - (zrC * zrC))
		tilt = Math.acos(-xrC / cH) * Math.sign(yrC)

		# Convert radians to degrees
		@_heading = @radToDeg(heading)
		@_elevation = @radToDeg(elevation)
		@_tilt = @radToDeg(tilt)
	
	degToRad: (deg) ->
		return deg * Math.PI / 180
	
	radToDeg: (rad) ->
		return rad * 180 / Math.PI
	
	round: (value, precision = 1000) ->
		return Math.round(value * precision) / precision

	toInspect: =>
		"<#{@constructor.name}>"

	# class methods

	@available: -> window.DeviceOrientationEvent?

	# event shortcuts

	onOrientationChange:(cb) -> @on(Events.OrientationChange, cb)
