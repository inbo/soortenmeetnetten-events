USE [S0008_00_Meetnetten]
GO

/****** Object:  View [ipt].[vwGBIF_INBO_meetnetten_15_vlinders_egg_count_Event]    Script Date: 29/10/2020 9:10:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
























ALTER VIEW [ipt].[vwGBIF_INBO_meetnetten_15_vlinders_egg_count_Event]
AS

SELECT --fa.*   --unieke kolomnamen 
	
	---RECORD ---
	 
--	  [occurrenceID] = N'INBO:MEETNETTEN:OCC:' + Right( N'0000' + CONVERT(nvarchar(20) ,fa.FieldworkObservationID),7)

      [type] = N'Event'
   	, [language] = N'en'
	, [license] = N'http://creativecommons.org/publicdomain/zero/1.0/'
	, [rightsHolder] = N'INBO'
	, [accessRights] = N'https://www.inbo.be/en/norms-data-use'
	, [datasetID] = N'https://doi.org/10.15468/hsfq2u'
	, [datasetName] = N'Meetnetten.be - Egg counts for butterflies in Flanders, Belgium'
	, [institutionCode] = N'INBO'
	, [parentEventID] = N'INBO:MEETNET:VISITID:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkVisitID),6)
	, [informationWithheld] = N'original locations available upon request'
	, [dataGeneralizations] = N'coordinates are generalized from a ' + dL.GeoType + N' to a ' + dbl.BlurHokType + N' grid'
	
	 ---EVENT---	
	
	, [eventID] = N'INBO:MEETNET:EVENT:' + Right( N'000000000' + CONVERT(nvarchar(20) , fA.FieldworkSampleID),6)  
--	, [basisOfRecord] = N'HumanObservation'
	, [samplingProtocol] =  CASE Protocolname
							WHEN 'Vlinders - Transecten' THEN 'butterfly transects'
							WHEN 'Vlinders - Eitellingen' THEN 'butterfly egg counts'
							WHEN 'Vlinders - Transecten (algemene monitoring)' THEN 'butterfly transect monitoring'
							WHEN 'Vlinders - Gebiedstelling (v1)' THEN 'butterfly site counts'
							ELSE ProtocolName
							END
--	, fa.Protocol
	, [eventDate] =     CONVERT(VARCHAR(10), fwp.VisitStartDate, 20)
	, [eventRemarks] = 'data collected in the '  + dbl.ProjectName + ' project'


	---LOCATION
	, [locationID] = N'INBO:MEETNET:LOCATION:' + Right( N'00' + CONVERT(nvarchar(20) ,dL.LocationID),6) 
	, [continent] = N'Europe'
	, [countryCode] = N'BE'
	, [locality] = locationName
--	, [parentLocality0] = parentLocationName
--	, [locality1] = CONCAT (ParentLocationName,'_ ',locationName)
	, [georeferenceRemarks] = 'coordinates are centroid of used grid square'
	
	-- USE FOR UNBLURRED DATA
	--, [decimalLatitude_unblur] = CASE dL.GeoType
	--					WHEN 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
	--					WHEN 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
	--					WHEN 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)
	--					WHEN 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)
	--					ELSE NULL
	--					END
	--, [decimalLongitude_unblur] =  CASE dL.GeoType
	--						WHEN 'LINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
	--						WHEN 'MULTILINESTRING' THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
	--						WHEN 'POINT'  THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)
	--						WHEN 'POLYGON'THEN CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)
	--						ELSE NULL
	--						END
	-- USE FOR BLURRED DATA IN GBIF
	, [decimalLatitude] =  CASE      --is blurred
							
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN utm.Centroid_5_Lat
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN utm.Centroid_1_Lat
							WHEN dbl.BlurHokType = 'UTM 5Km' THEN utm.Centroid_5_Lat
							WHEN dbl.BlurHokType = 'UTM 10Km' THEN utm.Centroid_10_Lat
							ELSE 'checkthis'
							END
	, [decimalLongitude] =  CASE ---is blurred
							
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN utm.Centroid_5_Long
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN utm.Centroid_1_Long
							WHEN dbl.BlurHokType = 'UTM 5Km' THEN utm.Centroid_5_Long
							WHEN dbl.BlurHokType = 'UTM 10Km' THEN utm.Centroid_10_Long
							ELSE 'checkthis'
							END
	, [coordinateUncertaintyInMeters] =  CASE      --is blurred
							
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN '3536'
							WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN '707'
							WHEN dbl.BlurHokType = 'UTM 5Km' THEN '3536'
							WHEN dbl.BlurHokType = 'UTM 10Km' THEN '7071'
							ELSE 'checkthis'
							END
	
--	, SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) as pointinfo   /***text uit kolom selecteren V3 beste optie***/
--	, (dL.LocationGeom.MakeValid().STAsText()) as footprintWKT
	, [geodeticDatum] = N'WGS84'
--	, dl.LocationGeom
--	, dl.parentLocationGeom
	
	
---- OCCURRENCE ---
		
--	, [recordedBy] = 'https://meetnetten.be'
--	, [individualCount] = Aantal
--	, [sex] = Geslacht
	--, [occurrenceStatus] = CASE Aantal
	--						When '0' then 'absent'
	--						Else 'present'
	--						End
	--, [lifeStage] = SpeciesLifestageName

/**----Taxon

	, [scientificName] = SpeciesScientificName
	, [vernacularName] = SpeciesName
	, [kingdom] = N'Animalia'
	, [phylum] = N'Arthropoda'
	, [class] = N'Insecta'
	, [order] = N'Lepidoptera'
	, [nomenclaturalCode] = N'ICZN' **/
	
	
	

	--			END
	--, [Project] = Dbl.ProjectName 
	--, [BlurToUse] = dbl.BlurHokType
	--, [parentLocality2] = parentLocationName
	--, [usedBlur] =  CASE      --is blurred
	--						WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone = '1' THEN 'utm 5km'
	--						WHEN dbl.BlurHokType = 'UTM 1Km' AND utm.IsInMilZone <> '1' THEN 'utm 1km'

	--						WHEN dbl.BlurHokType = 'UTM 5Km' THEN 'utm 5Km'
	--						WHEN dbl.BlurHokType = 'UTM 10Km' THEN 'utm 10Km'
	--						ELSE 'checkthis'
	--						END


FROM (SELECT DISTINCT(FieldworkSampleID),FieldworkVisitID,ProjectKey, LocationKey, ProtocolKey, LocationID, ProtocolID, SpeciesActivityID, SpeciesActivityKey, SpeciesLifestageID, SpeciesLifestageKey FROM dbo.FactAantal WHERE FieldworkSampleID > 0) fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN ( SELECT *
					, CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' THEN 'LINESTRING'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' THEN 'MULTILINESTRING'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  THEN 'POINT'  
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON' THEN 'POLYGON'
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTIPOLYGON' THEN 'MULTIPOLYGON'
						ELSE 'Something else'
						END as GeoType
					, geometry::STGeomFromText ( CASE 
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'LINESTRING' 
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)) + ')' 
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTILINESTRING' 
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)) + ')'
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POINT'  
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STStartPoint().STY)) + ')'
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'POLYGON'  
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)) + ')'
							--, 0 )
						WHEN SUBSTRING (dL.LocationGeom.MakeValid().STAsText(),0,CHARINDEX('(',(dL.LocationGeom.MakeValid().STAsText()))) = 'MULTIPOLYGON'  
							THEN --geometry::STGeomFromText(
							'POINT(' + CONVERT(nvarchar(500), CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STX)) + ' ' + CONVERT(nvarchar(500),CONVERT(decimal(10,5), dL.LocationGeom.MakeValid().STCentroid().STY)) + ')'
							--, 0 )
						END, 4326) as PointData
						
				FROM dbo.DimLocation dL) dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
--	INNER JOIN dbo.DimSpecies dSP ON dsp.SpeciesKey = fa.SpeciesKey
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID
--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN dbo.DimBlur Dbl ON Dbl.ProjectKey = fa.projectKey
	INNER JOIN [shp].[utm_vl_WGS84] utm WITH (INDEX(SI_utm_vl_WGS84__geom_1)) ON utm.geom_1.STIntersects(dL.PointData) = 1
	
	
	--INNER JOIN [shp].[utm10_vl_WGS84] utm10 ON dL.PointData.STWithin(utm10.geom) = 1
	
WHERE 1=1
--AND ProjectName = '***'
--AND fa.ProjectKey = '16'
AND fa.ProtocolID IN ('15')  ---Vlinders transecten * ,'15','28' removed other protocols
--AND Aantal > '0'
AND fwp.VisitStartDate > CONVERT(datetime, '2016-01-01', 120)
AND fwp.VisitStartDate < CONVERT(datetime, '2018-12-31', 120)
--AND projectName = 'Argusvlinder'
--AND fa.FieldworkObservationID =  491520
--ORDER BY speciesName Asc
--ORDER BY fa.FieldworkObservationID
--AND ParentLocationName in ('Groot Schietveld 2','Klein Schietveld')
--AND projectname = 'kommavlinder'
--AND ProjectName = 'heivlinder'
--AND fA.FieldworkSampleID = '190441'
--AND SpeciesLifestageName = 'imago'





--SELECT fa.FieldworkSampleID, count(*) as tel


/***FROM (SELECT DISTINCT(FieldworkSampleID),FieldworkVisitID,ProjectKey, LocationKey, ProtocolKey, LocationID, ProtocolID, SpeciesActivityID, SpeciesActivityKey, SpeciesLifestageID, SpeciesLifestageKey FROM dbo.FactAantal WHERE FieldworkSampleID > 0) fA
	INNER JOIN dbo.dimProject dP ON dP.ProjectKey = fA.ProjectKey
	INNER JOIN dbo.DimLocation dL ON dL.LocationKey = fA.LocationKey
	INNER JOIN dbo.DimProtocol dProt ON dProt.ProtocolKey = fA.ProtocolKey
	INNER JOIN dbo.DimSpeciesActivity dSA ON dSA.SpeciesActivityKey = fA.SpeciesActivityKey
	INNER JOIN dbo.DimSpeciesLifestage dSL ON dSL.SpeciesLifestageKey = fA.SpeciesLifestageKey
	--	INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
	INNER JOIN (SELECT DISTINCT(FieldworkSampleID), VisitStartDate FROM dbo.FactWerkpakket ) FWp ON FWp.FieldworkSampleID = fa.FieldworkSampleID

	--INNER JOIN FactCovariabele FCo ON FCo.FieldworkSampleID = fA.FieldworkSampleID
WHERE 1=1
--AND ProjectName = 'Vuursalamander'
--AND ProtocolName = 'Vlinders - Transecten'
--AND fa.ProjectKey = '16'
  AND fa.ProtocolID =  '1'
--  AND fa.FieldworkSampleID in ('196717','196456','197026','54759','194584')
  --AND ParentLocationGeom IS NULL
--ORDER BY FA.FieldworkSampleID DesC

--- Verification by counts ---
--  GROUP BY fa.FieldworkSampleID
--  ORDER BY tel DESC  **/













































GO


