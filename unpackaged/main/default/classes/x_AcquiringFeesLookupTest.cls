@IsTest
public class x_AcquiringFeesLookupTest {
  
	static void setup() {
  	}

    @IsTest
  	static void setFeesIfICPlusPlusFound() {

		//insert test account
        Account acc = new Account(name='Test');
      	acc.Owning_Country__c = 'United Kingdom';
        acc.Company_Sector__c = 'Retail';
        insert acc;
        
		//insert test opportunity
        Opportunity opp = new Opportunity(name='Test');
        opp.AccountId = acc.Id;
        opp.StageName = 'Opportunity Recorded';
        opp.CloseDate = Date.newInstance(2030, 12, 12);
        insert opp;

		//insert test Acquiring_Fees__c
        Acquiring_Fees__c aFee = new Acquiring_Fees__c();
        aFee.Vertical__c = 'Hospitality';
        aFee.Setup__c = 'Stand Alone';
        aFee.Platform__c = 'POS/Online PBL';
        aFee.Scheme__c = 'Visa/Mastercard';
        aFee.Acquiring_Volume__c = 6;
        aFee.Fees__c = '';
        aFee.Actual_Fees__c = 26.00;
        aFee.Opportunity__c = opp.Id;
        insert aFee;

        //lookup acquiring fees from the custom metadata type 'Acquiring Fees'
        List<Acquiring_Fees_Lookup__mdt> lstFees = new List<Acquiring_Fees_Lookup__mdt>();    
        lstFees = [SELECT Id, Platform__c, Scheme__c, Setup__c, Vertical__c, Scheme_Fees__c, Min_Vol__c, Max_Vol__c, Minumum_Fees__c, Min_Fees__c
                                        FROM Acquiring_Fees_Lookup__mdt
                                        WHERE Platform__c = :aFee.Platform__c
                                        AND Scheme__c = :aFee.Scheme__c
                                        AND Setup__c = :aFee.Setup__c
                                        AND Vertical__c = :aFee.Vertical__c
                           				AND Min_Vol__c <= :afee.Acquiring_Volume__c
                           				AND Max_Vol__c >= :afee.Acquiring_Volume__c
                                        LIMIT 1];        
        
        System.assertEquals('IC++: AF OF 25bps', lstFees[0].Minumum_Fees__c);
        
        List<Id> lstAFeesIds = new List<Id>();
        lstAFeesIds.add(aFee.Id);
        
        Test.startTest();
        
        //call method to set the Acquiring_Fees__c fees
        x_AcquiringFeesLookup.setFees(lstAFeesIds);
        
        //get Acquiring_Fees__c record to check update
        Acquiring_Fees__c aFeeTest = [SELECT Id, Fees__c
                           		FROM Acquiring_Fees__c 
                           		LIMIT 1];

        System.assertEquals('IC++: AF OF 25bps', aFeeTest.Fees__c);

        Test.stopTest();     

  	}

    @IsTest
  	static void setFeesIfICPlusPlusFoundBelowMinFees() {

		//insert test account
        Account acc = new Account(name='Test');
      	acc.Owning_Country__c = 'United Kingdom';
        acc.Company_Sector__c = 'Retail';
        insert acc;
        
		//insert test opportunity
        Opportunity opp = new Opportunity(name='Test');
        opp.AccountId = acc.Id;
        opp.StageName = 'Opportunity Recorded';
        opp.CloseDate = Date.newInstance(2030, 12, 12);
        insert opp;

		//insert test Acquiring_Fees__c
        Acquiring_Fees__c aFee = new Acquiring_Fees__c();
        aFee.Vertical__c = 'Hospitality';
        aFee.Setup__c = 'Stand Alone';
        aFee.Platform__c = 'POS/Online PBL';
        aFee.Scheme__c = 'Visa/Mastercard';
        aFee.Acquiring_Volume__c = 6;
        aFee.Fees__c = '';
        aFee.Actual_Fees__c = 24.00;
        aFee.Opportunity__c = opp.Id;
        insert aFee;

        //lookup acquiring fees from the custom metadata type 'Acquiring Fees'
        List<Acquiring_Fees_Lookup__mdt> lstFees = new List<Acquiring_Fees_Lookup__mdt>();    
        lstFees = [SELECT Id, Platform__c, Scheme__c, Setup__c, Vertical__c, Scheme_Fees__c, Min_Vol__c, Max_Vol__c, Minumum_Fees__c, Min_Fees__c
                                        FROM Acquiring_Fees_Lookup__mdt
                                        WHERE Platform__c = :aFee.Platform__c
                                        AND Scheme__c = :aFee.Scheme__c
                                        AND Setup__c = :aFee.Setup__c
                                        AND Vertical__c = :aFee.Vertical__c
                           				AND Min_Vol__c <= :afee.Acquiring_Volume__c
                           				AND Max_Vol__c >= :afee.Acquiring_Volume__c
                                        LIMIT 1];        
        
        System.assertEquals('IC++: AF OF 25bps', lstFees[0].Minumum_Fees__c);
        
        List<Id> lstAFeesIds = new List<Id>();
        lstAFeesIds.add(aFee.Id);
        
        Test.startTest();
        
        //call method to set the Acquiring_Fees__c fees
        x_AcquiringFeesLookup.setFees(lstAFeesIds);
        
        //get Acquiring_Fees__c record to check update
        Acquiring_Fees__c aFeeTest = [SELECT Id, Fees__c
                           		FROM Acquiring_Fees__c 
                           		LIMIT 1];

        System.assertEquals('IC++: AF OF 25bps', aFeeTest.Fees__c);

        Test.stopTest();     

  	}
    
    
    @IsTest
  	static void setFeesIfBlendedFound() {

		//insert test account
        Account acc = new Account(name='Test');
      	acc.Owning_Country__c = 'United Kingdom';
        acc.Company_Sector__c = 'Retail';
        insert acc;
        
		//insert test opportunity
        Opportunity opp = new Opportunity(name='Test');
        opp.AccountId = acc.Id;
        opp.StageName = 'Opportunity Recorded';
        opp.CloseDate = Date.newInstance(2030, 12, 12);
        insert opp;

		//insert test Acquiring_Fees__c
        Acquiring_Fees__c aFee = new Acquiring_Fees__c();
        aFee.Vertical__c = 'Hospitality';
        aFee.Setup__c = 'All';
        aFee.Platform__c = 'POS';
        aFee.Scheme__c = 'Union Pay';
        aFee.Acquiring_Volume__c = 11;
        aFee.Fees__c = '';
        aFee.Actual_Fees__c = 17.00;
        aFee.Opportunity__c = opp.Id;
        insert aFee;

        //lookup acquiring fees from the custom metadata type 'Acquiring Fees'
        List<Acquiring_Fees_Lookup__mdt> lstFees = new List<Acquiring_Fees_Lookup__mdt>();    
        lstFees = [SELECT Id, Platform__c, Scheme__c, Setup__c, Vertical__c, Scheme_Fees__c, Min_Vol__c, Max_Vol__c, Minumum_Fees__c, Min_Fees__c
                                        FROM Acquiring_Fees_Lookup__mdt
                                        WHERE Platform__c = :aFee.Platform__c
                                        AND Scheme__c = :aFee.Scheme__c
                                        AND Setup__c = :aFee.Setup__c
                                        AND Vertical__c = :aFee.Vertical__c
                           				AND Min_Vol__c <= :afee.Acquiring_Volume__c
                           				AND Max_Vol__c >= :afee.Acquiring_Volume__c
                                        LIMIT 1];        
        
        System.assertEquals('Blended: 1.60%', lstFees[0].Minumum_Fees__c);
        
        List<Id> lstAFeesIds = new List<Id>();
        lstAFeesIds.add(aFee.Id);
        
        Test.startTest();
        
        //call method to set the Acquiring_Fees__c fees
        x_AcquiringFeesLookup.setFees(lstAFeesIds);
        
        //get Acquiring_Fees__c record to check update
        Acquiring_Fees__c aFeeTest = [SELECT Id, Fees__c
                           		FROM Acquiring_Fees__c 
                           		LIMIT 1];

        System.assertEquals('Blended: 1.60%', aFeeTest.Fees__c);

        Test.stopTest();     

  	}
    
    
  

}