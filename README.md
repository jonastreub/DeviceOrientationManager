# DeviceOrientationManager

Useful device orientation data for [Framer](http://framerjs.com) prototypes. Find out what direction the user is facing and point them in the right direction. If you are interested in Virtual Reality you should check out the [VRComponent](https://github.com/jonastreub/VRComponent).

## Example

- [Compass](http://share.framerjs.com/h5r07gzwatsj/) (uses `compassHeading`, only works on mobile)
- [WaveReader](http://share.framerjs.com/dfqoti70fulk/) (uses `heading`, only works on mobile)

## Properties

- **`heading`** *\<number>* readonly (0 to 360 degrees)
- **`elevation`** *\<number>* readonly (90 to -90 degrees)
- **`tilt`** *\<number or null>* readonly (180 to -180 degrees)
- **`compassHeading`** *\<number or null>* readonly (0 to 360 degrees)
- **`alpha`** *\<number or null>* readonly (0 to 360 degrees)
- **`beta`** *\<number or null>* readonly (180 to -180 degrees)
- **`gamma`** *\<number or null>* readonly (90 to -90 degrees)

```coffee
# Include the DeviceOrientationManager
{DeviceOrientationManager} = require "DeviceOrientationManager"

orientationManager = new DeviceOrientationManager
```

## Functions

- DeviceOrientationManager.**`available()`** returns *\<bool>*

## Events

- **`onOrientationChange`** (data *\{heading, elevation, tilt, compassHeading, alpha, beta, gamma}*)

```coffee
orientationManager.onOrientationChange (data) ->
	heading = data.heading
	elevation = data.elevation
	tilt = data.tilt
```
