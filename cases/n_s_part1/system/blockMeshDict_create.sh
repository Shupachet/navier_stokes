#!/bin/sh
# Hole
HoleRadiusOuter=0.5
HoleRadiusOuterIpoint="0"`echo "scale=18; $HoleRadiusOuter / sqrt(2)" | bc`;
HoleRadiusInner=0.45
HoleRadiusInnerIpoint="0"`echo "scale=18; $HoleRadiusInner / sqrt(2)" | bc`;
HoleHeight=10
# Imposion cell
ICRadiusOuter=0.2
ICRadiusOuterIpoint="0"`echo "scale=18; $ICRadiusOuter / sqrt(2)" | bc`;
ICHeight=0.8
ICInitIndentZ=0.1

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
	//Hole Outer Bottom 0-3
	( $HoleRadiusOuter 0 0 )
	( 0 $HoleRadiusOuter 0 )
	( -$HoleRadiusOuter 0 0 )
	( 0 -$HoleRadiusOuter 0 )
	//Hole Outer Top 4-7
	( $HoleRadiusOuter 0 $HoleHeight )
	( 0 $HoleRadiusOuter $HoleHeight )
	( -$HoleRadiusOuter 0 $HoleHeight )
	( 0 -$HoleRadiusOuter $HoleHeight )
	//Hole Inner Bottom 8-11
	( $HoleRadiusInner 0 0 )
	( 0 $HoleRadiusInner 0 )
	( -$HoleRadiusInner 0 0 )
	( 0 -$HoleRadiusInner 0 )
	//Hole Inner Top 12-15
	( $HoleRadiusInner 0 $HoleHeight )
	( 0 $HoleRadiusInner $HoleHeight )
	( -$HoleRadiusInner 0 $HoleHeight )
	( 0 -$HoleRadiusInner $HoleHeight )
);

//Arcs to full cirle
edges
(
	//Hole Outer Bottom 0-3
	arc 0 1 ($HoleRadiusOuterIpoint $HoleRadiusOuterIpoint 0)
	arc 1 2 (-$HoleRadiusOuterIpoint $HoleRadiusOuterIpoint 0)
	arc 2 3 (-$HoleRadiusOuterIpoint -$HoleRadiusOuterIpoint 0)
	arc 3 0 ($HoleRadiusOuterIpoint -$HoleRadiusOuterIpoint 0)
	//Hole Outer Top 4-7
	arc 4 5 ($HoleRadiusOuterIpoint $HoleRadiusOuterIpoint $HoleHeight)
	arc 5 6 (-$HoleRadiusOuterIpoint $HoleRadiusOuterIpoint $HoleHeight)
	arc 6 7 (-$HoleRadiusOuterIpoint -$HoleRadiusOuterIpoint $HoleHeight)
	arc 7 4 ($HoleRadiusOuterIpoint -$HoleRadiusOuterIpoint $HoleHeight)
	//Hole Inner Bottom 8-11
	arc 8 9 ($HoleRadiusInnerIpoint $HoleRadiusInnerIpoint 0)
	arc 9 10 (-$HoleRadiusInnerIpoint $HoleRadiusInnerIpoint 0)
	arc 10 11 (-$HoleRadiusInnerIpoint -$HoleRadiusInnerIpoint 0)
	arc 11 8 ($HoleRadiusInnerIpoint -$HoleRadiusInnerIpoint 0)
	//Hole Inner Top 12-15
	arc 12 13 ($HoleRadiusInnerIpoint $HoleRadiusInnerIpoint $HoleHeight)
	arc 13 14 (-$HoleRadiusInnerIpoint $HoleRadiusInnerIpoint $HoleHeight)
	arc 14 15 (-$HoleRadiusInnerIpoint -$HoleRadiusInnerIpoint $HoleHeight)
	arc 15 12 ($HoleRadiusInnerIpoint -$HoleRadiusInnerIpoint $HoleHeight)
);

blocks
(
	//Hole Outer 0-7
//	hex (0 1 2 3 4 5 6 7) (30 30 30) simpleGrading (1 1 10)
	//Hole Inner 8-15
//	hex (8 9 10 11 12 13 14 15) (30 30 30) simpleGrading (1 1 10)
	//Sectors
	hex (0 1 9 8 4 5 13 12) (30 30 30) simpleGrading (1 1 10)
	hex (1 2 10 9 5 6 14 13) (30 30 30) simpleGrading (1 1 10)
	hex (2 3 11 10 6 7 15 14) (30 30 30) simpleGrading (1 1 10)
	hex (3 0 8 11 7 4 12 15) (30 30 30) simpleGrading (1 1 10)
);

patches
(
/*
	//REPAIR HERE! Hole Outer 0-7 INner 8-15
	patch holeinnerborder
	(
		(8 12 13 9)
		(9 13 14 10)
		(10 14 15 11)
		(11 15 12 8)
	)
	patch holeoutertop
	(
		(4 7 6 5)
	)
	patch holeouterbottom
	(
		(0 3 2 1)
	)
	patch holeinnertop
	(
		(8 11 10 9)
	)
	patch holeinnerbottom
	(
		(12 15 14 13)
	)
*/
);

mergePatchPairs
(
//( holeouterborder holeinnerborder )
//( holeoutertop holeinnertop )
);

// ************************************************************************* //
"


