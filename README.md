jscience-as
===========

This is a partial implementation of JScience for ActionScript.

Supported
---------

* Exact or arbitrary precision measurements.

### TODO

* MeasureFormat and UnitFormat (parse numbers with units).
* Economics
* Geography
* Mathematics
* Physics

Installation
------------

    mvn clean install

Usage
-----

    import measure.Measure;
    import measure.unit.NonSI;
    import measure.unit.SI;

    var input:Measure = Measure.valueOf(1, NonSI.MILE);
    var output:Measure = input.to(SI.METRE);

    trace(output.getValue()); // 1609.34
