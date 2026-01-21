USE Kolejnictwo_Hurtownia

INSERT INTO [dbo].[Junk_DT] 
SELECT I, D, L, F 
FROM 
	(VALUES ('0'), ('1')) 
	AS IsDelay(I)
	
	,(VALUES ('Zero'), ('One'), ('More')) 
	AS DelayRange(D)

	,(VALUES ('Bad'), ('Medium'), ('Good'), ('Great')) 
	AS LocomotiveUsageRange(L)

	,(VALUES ('Bad'), ('Medium'), ('Good'), ('Great')) 
	AS FreightCarsUsageRange(F);