jscience-as
===========

This is a partial implementation of JScience for ActionScript.

Supported
---------

* Exact or arbitrary precision measurements.
* Parse and format strings with units.<br>
  Examples of valid entries (all for meters per second squared):

        m*s-2
        m/s²
        m·s-²
        m*s**-2
        m^+1 s^-2

### TODO

* Amount
 * Economics
 * Geography
 * Mathematics
 * Physics

Installation
------------

```sh
$ mvn clean install
```

Usage
-----

```actionscript
import measure.Measure;
import measure.unit.NonSI;
import measure.unit.SI;

var input:Measure = Measure.valueOf(1, NonSI.MILE);
var output:Measure = input.to(SI.METRE);

trace(output.getValue()); // 1609.34
```
