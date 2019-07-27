# GraceGroundTrack_TLE

<div align="center">
	<img src="/images/grace.png"  width="900"/>
</div>

**Abtract**

In this task, aim is visualizing the ground track of two altimeter satellites (Grace 1 and 2),
where the basic information is obtained from Two-line Elements (TLE) file. TLE file, contains a bundle
of numbers mostly related to the orbital motion parameters of satellite.
By, extracting specific numbers from TLE file and execution certain calculations, the ground track of a
satellite could be generated for a precise period of time. Visualizing orbital motion of a satellite could 
be an expensive procedure and requires an optimized environment and code implementation to could be more 
well-organized, also, some assumptions could be made to simplify the calculations. 

here, I will try to to my best to explain in details all necessary steps and theoretical relations.


### The definition of important parameters:

* **a**: semi-major axis of ellipse.
* **b**: semi-minor axis of ellipse.
* **Perigee**: The closes point to the earth on the ellipse.
* **Apogee**: The most far point in the ellipse with respect to earth.
* **Mean Motion (n)**: The number of revolutions of satellite around Earth per day.
* **Mean anomaly (M)**: an angular distance defined by the position of the satellite on its orbit with respect to perigee on a circular orbit [1].
* **Eccentric anomaly (E)**: an angular parameter that defines the position of a body that is moving along an elliptic Kepler orbit [1].
* **True anomaly (v)**: Position of satellite on its elliptic orbit respect to center of the earth.
* **Inclination (i)**: Angle between equatorial plane and satellite orbital plane.
* **Right ascension of ascending node (RAAN,OMEGA)**: the angle from origin of longitude, of point which satellite will pass the equatorial plane from down side to up, measured in a reference plane [1].
* **Argument of perigee (w)**: Is defined as the angle within the satellite orbit plane from the Ascending Node to the perigee point (p) along the satellite's direction of travel [1].


## Extracting information from TLE file 
All parameters extracted from TLE file

<div align="center">
	<img src="/images/TLE.png"  width="700"/>
</div>

The orbital period of the satellite could be calculated based on satellite’s mean velocity n which is extracted in unit of revolution per day.

<div align="center">
	<img src="/images/1.png"  width="70"/>
</div>

semi—major axis:

<div align="center">
	<img src="/images/2.png"  width="100"/>
</div>

where G is the universal gravitational constant and M is the mass of the earth, also, n is the mean velocity of satellite in unit of revolution per seconds.


* altitude of Perigee:	

<div align="center">
	<img src="/images/3.png"  width="300"/>
</div>

The altitude of Perigee could be computed based on distance of Perigee from focus point which earth is placed minus radius of Erath.


* altitude of Apogee:			

<div align="center">
	<img src="/images/4.png"  width="300"/>
</div>

The altitude of Apogee same as Perigee could be obtained through distance of Apogee from the focal point, which, earth is situated on, minus Erath radius.


* The transit time of perigee has to be calculated based on epoch, mean motion and Mean
anomaly to obtain position at epoch of satellite.

<div align="center">
	<img src="/images/5.png"  width="200"/>
</div>

where tau is transit time of perigee, n mean velocity of satellite per second and M mean anomaly
of satellite.

--- 
 by: Alireza Ahmadi                                     
 University of Bonn- Robotics & Geodetic Engineering
 Alireza.Ahmadi@uni-bonn.de                             
 AlirezaAhmadi.xyz 


