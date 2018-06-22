# Trakpak 3 Developer Resources

## Legend

Curve Radii: R(Radius) Ex. R2048 -> 2048-Radius Curve

Grades: G(% Grade x 10) Ex. G32 -> 3.2% Grade (Sunset Gulch Standard)

Angles: Ang(Slope / 4) Ex. Ang2 -> Horizontal (Y/X) Slope of 2/4 = 1/2

## Master To-Do List:

_Italicized Items_ are Optional/Uncertain.

~~Struckthrough Items~~ are Done.

`Code-Blocked Items` are being worked on.

### Basic Track

All straight track lengths will be Powers of Two (or simple multiples of Powers of Two). For Angled track, this applies to both the X and Y distances. Curves are to be the three principle radii (2048, 3072, 4096) plus their double track radii (principle radii + 192) plus 1536 and 8192.

   * ~~Straights Ang0~~
   * ~~Straights Ang1~~
   * ~~Straights Ang2~~
   * ~~Straights Ang4~~
   * `Curves R1536`
   * `Curves R2048/2240`
   * `Curves R3072/3264`
   * `Curves R4096/4288`
   * ~~Curves R8192~~
   * Straight Grades G16
   * Straight Grades G32
   * Curved Grades R2048/2240
   * Curved Grades R3072/3264
   * Curved Grades R4096/4288
   
### Switches

All Switch Types, in order of priority:

   1. Basic Turnouts (Ang1x0, Ang2x0, Ang4x0)
   2. Siding Turnouts (Ang0x0)
   3. Angled Turnouts (Ang0x1, Ang0x2, Ang0x4)
   4. Double Track Crossovers (Ang0x0)
   5. Wyes (Ang1x1, Ang2x2, Ang4x4)
   6. Scissors Diamond Crossovers (Ang0x0)
   7. Double Slip Switches (Ang1x0)

1536 is the only radius with all the switches, all the rest have fewer.

   * `Switches R1536`
   * `Switches R2048`
   * _Switches R2240_
   * `Switches R3072`
   * _Switches R3264_
   * Switches R4096
   
### Bridges

   * ~~Half-Through Plate Girder Bridges Ang0~~
   * Half-Through Plate Girder Bridges Ang4
   * ~~Deck Plate Girder Bridges Ang0~~
   * `Pratt Truss Bridges Ang0`
   * Pratt Truss Bridges Ang4
   * Inverted Pratt Truss Bridges Ang0
   * Warren Truss Bridges Ang0
   * Warren Truss Bridges Ang4
   * Pennsylvania Petit Truss Bridges Ang0
   * Steel Trestle Pylons
   * Wooden Trestle Ang0
   * Wooden Trestle Ang4
   * Wooden Trestle R2048
   * Wooden Trestle R3072
   * Wooden Trestle Pylons
   * Strauss Bascule Bridges (Animated?)
   * Rolling Bascule Bridges (Animated?)
   * Swing Bridges
   * _Lift Bridges_
   * _Concrete Abutments_
   
### Tunnels

   All tunnels need Straight Ang0 and Ang4; Curved R2048/2248 and R3072/3264; G16 and G32 Straight Grades.
   
   _Curved Ramps?_
   
   * Standard (Rounded)
   * Notched
   * _Extra-Height (For Catenary)_
   * Double Track Standard
   * Double Track Notched
   * _Double Track Extra-Height_
   
### Special Track

   * `Banked Track R2048/2248`
   * Banked Track R3072/3264
   * `Diamonds (Each Angle X Itself, plus Each Angle X Zero)`
   * Turntable
   * Transfer Table (Animated?)
   * Roundhouse Bays
   
### Signals

   All Signals will be animated for the sake of consistency, and will consist of these varieties as applicable:
   
   1. R/G 
   2. R/Y
   3. R/L
   4. R/Y/G
   5. R/Y/G/L
   6. R/Y/G Dwarf
    
   * Colored Light CL
   * Searchlight SL
   * Position Light PL
   * Colored Position Light CPL
   * Darth Vader DV
   * Upper Quadrant Semaphore UQ
   * Lower Quadrant Semaphore LQ
   * Triangular Light TL
   * Doll Posts
   * Short Masts
   * Tall Masts
   * Bracket Masts
   * G/C Plates
   * 2-Track Signal Gantry
   * 3-Track Signal Gantry
   * 4-Track Signal Gantry
   
### Electrification

   * Single Metal Overhead Pole
   * Double Metal Overhead Pole
   * Single Wooden Overhead Pole
   * Double Metal Overhead Gantry
   * Triple Metal Overhead Gantry
   * Quadruple Metal Overhead Gantry
   * _Double Wooden Overhead Gantry_
   * Overhead Wires for all basic track pieces
   * _Straight Third Rail_
   * _Inner Radius Third Rail_
   * _Outer Radius Third Rail_
   
### Roads

Sidewalks will be a separate model overlaid onto basic roads.

   * Basic Roads
   * Single Track Streetrunning
   * Double Track Streetrunning
   * Basic Sidewalks
   * STS Sidewalks
   * DTS Sidewalks
   * Grade Crossings (Wood, Asphalt, Rubber, Concrete)
   * Crossing Gates (Animated)
   * Griswold Signals (Animated)
   * Wig-Wags (Animated)
   * _Street Signs_
   * _Traffic Lights_
