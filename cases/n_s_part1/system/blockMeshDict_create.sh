#!/bin/sh
# Params
# Hole
HoleRadius=0.5
HoleRadiusIpoint="0"`echo "scale=18; $HoleRadius / sqrt(2)" | bc`;
HoleHeight=10
# Imposion cell
ICRadius=0.2
ICRadiusIpoint="0"`echo "scale=18; $ICRadius / sqrt(2)" | bc`;
ICHeight=0.8
ICInitIndentZ=0.1
# Layer
LayerRadius=7
LayerHeight=2
# Additional values
ICBottomZ=$ICInitIndentZ
ICTopZ="0"`echo $ICInitIndentZ + $ICHeight | bc`;

echo >blockMeshDict "

/*--------------------------------*- C++ -*----------------------------------*\\\

| =========                 |                                                 |
| \\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |
|  \\\    /   O peration     | Version:  1.6.06                                 |
|   \\\  /    A nd           | Web:      www.OpenFOAM.com                      |
|    \\\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      blockMeshDict;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

//Main points list
vertices
(
	//Hole TOP : 0-3
	( $HoleRadius 0 $HoleHeight )
	( 0 $HoleRadius $HoleHeight )
	( -$HoleRadius 0 $HoleHeight )
	( 0 -$HoleRadius $HoleHeight )
	//ICell TOP : 4-7
	( $ICRadius 0 $ICTopZ )
	( 0 $ICRadius $ICTopZ )
	( -$ICRadius 0 $ICTopZ )
	( 0 -$ICRadius $ICTopZ )
	//ICell BOTTOM : 8-11
	( $ICRadius 0 $ICBottomZ )
	( 0 $ICRadius $ICBottomZ )
	( -$ICRadius 0 $ICBottomZ )
	( 0 -$ICRadius $ICBottomZ )
	//Hole BOTTOM : 12-15
	( $HoleRadius 0 0 )
	( 0 $HoleRadius 0 )
	( -$HoleRadius 0 0 )
	( 0 -$HoleRadius 0 )
	//Layer TOP : 16-19
	( $LayerRadius 0 0 )
	( 0 $LayerRadius 0 )
	( -$LayerRadius 0 0 )
	( 0 -$LayerRadius 0 )
	//Layer BOTTOM : 20-23
	( $LayerRadius 0 -$LayerHeight )
	( 0 $LayerRadius -$LayerHeight )
	( -$LayerRadius 0 -$LayerHeight )
	( 0 -$LayerRadius -$LayerHeight )
);

//Arcs to full cirle
edges
(
	//Hole TOP : 0-3
	arc 0 1 ($HoleRadiusIpoint $HoleRadiusIpoint $HoleHeight)
	arc 1 2 (-$HoleRadiusIpoint $HoleRadiusIpoint $HoleHeight)
	arc 2 3 (-$HoleRadiusIpoint -$HoleRadiusIpoint $HoleHeight)
	arc 3 0 ($HoleRadiusIpoint -$HoleRadiusIpoint $HoleHeight)
	//ICell TOP : 4-7
	arc 4 5 ($ICRadiusIpoint $ICRadiusIpoint $ICTopZ)
	arc 5 6 (-$ICRadiusIpoint $ICRadiusIpoint $ICTopZ)
	arc 6 7 (-$ICRadiusIpoint -$ICRadiusIpoint $ICTopZ)
	arc 7 4 ($ICRadiusIpoint -$ICRadiusIpoint $ICTopZ)
	//ICell BOTTOM : 8-11
	arc 8 9 ($ICRadiusIpoint $ICRadiusIpoint $ICBottomZ)
	arc 9 10 (-$ICRadiusIpoint $ICRadiusIpoint $ICBottomZ)
	arc 10 11 (-$ICRadiusIpoint -$ICRadiusIpoint $ICBottomZ)
	arc 11 8 ($ICRadiusIpoint -$ICRadiusIpoint $ICBottomZ)
	//Hole BOTTOM : 12-15
	arc 12 13 ($HoleRadiusIpoint $HoleRadiusIpoint 0)
	arc 13 14 (-$HoleRadiusIpoint $HoleRadiusIpoint 0)
	arc 14 15 (-$HoleRadiusIpoint -$HoleRadiusIpoint 0)
	arc 15 12 ($HoleRadiusIpoint -$HoleRadiusIpoint 0)
);

blocks
(

	//Hole
	hex (12 15 14 13 0 3 2 1) (30 30 30) simpleGrading (1 1 10) 
	//Implosion Cell
	hex (4 7 6 5 8 11 10 9) (30 30 30) simpleGrading (1 1 10)
	//Layer
	hex (16 19 18 17 20 23 22 21) (30 30 30) simpleGrading (1 1 10)
);

patches
(
	//Hole TOP / Hole AREA1 TOP : 0-3
	patch holetop
	(
		(0 3 2 1)
	)
	//Hole INNER BODY : 0-3 + 12-15
	patch holeinnerbody
	(
		(12 0 1 13)
		(13 1 2 14)
		(14 2 3 15)
		(15 3 0 12)
	)
	//Hole BOTTOM : 12-15
	patch holebottom
	(
		(12 15 14 13)
	)
	//ICell OUTER BODY
	patch icouterbody
	(
		(8 4 5 9)
		(9 5 6 10)
		(10 6 7 11)
		(11 7 4 8)
		(4 5 6 7)
		(8 9 10 11)
	)
);

mergePatchPairs
(
);

// ************************************************************************* //
"


