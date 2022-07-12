@IsTest
public class x_SubscriptionFeesLookupTest {
	static void setup() {
  	}
    
    @IsTest
  	static void setClickAndCollect() {

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
    
          //insert test Subscription_Fees__c
          Subscription_Fees__c sFee = new Subscription_Fees__c();
          sFee.Click_Collect__c = TRUE;
          sFee.Opportunity__c = opp.Id;
          insert sFee;
              
          //insert test Add_On__c
          Add_On__c addOn = new Add_On__c();
          addOn.Subscription_Fees__c = sFee.Id;
          insert addOn;
    
          List<Id> lstSFeesIds = new List<Id>();
          lstSFeesIds.add(sFee.Id);
              
          Test.startTest();
              
          //call class
          x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
              
          //get Add_On__c record to check update
          Add_On__c addOnTest = [SELECT Id, Click_Collect_Total_Price__c  //other fields
                                    FROM Add_On__c 
                                    LIMIT 1];
    
          //check amount
          System.assertEquals(12000.00, addOnTest.Click_Collect_Total_Price__c);
    
          Test.stopTest();     

  	}

    @IsTest
  	static void setOMS() {

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

		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.OMS__c = TRUE;
      sFee.Opportunity__c = opp.Id;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      insert addOn;

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Add_On__c record to check update
      Add_On__c addOnTest = [SELECT Id, OMS_Total_Price__c  //other fields
                           		FROM Add_On__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(12000.00, addOnTest.OMS_Total_Price__c);

      Test.stopTest();     

  	}

    @IsTest
  	static void setSMARTPosWithinBand() {

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

		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Smart_POS__c = TRUE;
      sFee.Opportunity__c = opp.Id;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      addOn.Number_Of_Associates__c = 30.00;
      insert addOn;

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Add_On__c record to check update
      Add_On__c addOnTest = [SELECT Id, Smart_POS_Total_Price__c  //other fields
                           		FROM Add_On__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(18000.00, addOnTest.Smart_POS_Total_Price__c);

      Test.stopTest();     

  	}

    @IsTest
  	static void setSMARTPosOutsideBand() {

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

		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Smart_POS__c = TRUE;
      sFee.Opportunity__c = opp.Id;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      addOn.Number_Of_Associates__c = 850.00;
      addOn.SPOS_Price__c = 99999;
      insert addOn;

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Add_On__c record to check update
      Add_On__c addOnTest = [SELECT Id, Smart_POS_Total_Price__c  //other fields
                           		FROM Add_On__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(99999.00, addOnTest.Smart_POS_Total_Price__c);

      Test.stopTest();     

  	}
    
    @IsTest
  	static void setgmvWithinBand() {

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

		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Opportunity__c = opp.Id;
      sFee.Predicted_GMV_Value__c = 500000;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      insert addOn;

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Subscription_Fees__c record to check update
      Subscription_Fees__c subFeesTest = [SELECT Id, Predicted_GMV_Price__c  //other fields
                           		FROM Subscription_Fees__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(3000.00, subFeesTest.Predicted_GMV_Price__c);

      Test.stopTest();     

  	}
    
    @IsTest
  	static void setgmvOutsideBand() {

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

		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Opportunity__c = opp.Id;
      sFee.Predicted_GMV_Value__c = 200000000;
      sfee.Predicted_GMV__c = 250000000;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      insert addOn;

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Subscription_Fees__c record to check update
      Subscription_Fees__c subFeesTest = [SELECT Id, Predicted_GMV_Price__c  //other fields
                           		FROM Subscription_Fees__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(250000000.00, subFeesTest.Predicted_GMV_Price__c);

      Test.stopTest();     

  	}
    
    @IsTest
  	static void setSupportBronze() {

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
        
	  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Smart_POS__c = TRUE;
      sFee.Support_Level__c = 'Bronze';
      sFee.Opportunity__c = opp.Id;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      addOn.Number_Of_Associates__c = 30.00;
      insert addOn;        

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Subscription_Fees__c record to check update
      Subscription_Fees__c subFeeTest = [SELECT Id, Support_Level_Price__c //other fields
                           		FROM Subscription_Fees__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(0.00, subFeeTest.Support_Level_Price__c);

      Test.stopTest();     

  	}

    @IsTest
  	static void setSupportSilver() {
        
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
        
		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Smart_POS__c = TRUE;
      sFee.Support_Level__c = 'Silver';
      sFee.Opportunity__c = opp.Id;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      addOn.Number_Of_Associates__c = 30.00;
      insert addOn;        

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Subscription_Fees__c record to check update
      Subscription_Fees__c subFeeTest = [SELECT Id, Support_Level_Price__c //other fields
                           		FROM Subscription_Fees__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(9540.00, subFeeTest.Support_Level_Price__c);

      Test.stopTest();     
        
    }    

    @IsTest
  	static void setSupportGold() {
        
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
        
		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Smart_POS__c = TRUE;
      sFee.Support_Level__c = 'Gold';
      sFee.Opportunity__c = opp.Id;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      addOn.Number_Of_Associates__c = 30.00;
      insert addOn;        

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Subscription_Fees__c record to check update
      Subscription_Fees__c subFeeTest = [SELECT Id, Support_Level_Price__c //other fields
                           		FROM Subscription_Fees__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(19080.00, subFeeTest.Support_Level_Price__c);

      Test.stopTest();     
        
    }    
    
    @IsTest
  	static void setDigitalCommerce_DigitalCommerce() {

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

		  //insert test Subscription_Fees__c
      Subscription_Fees__c sFee = new Subscription_Fees__c();
      sFee.Opportunity__c = opp.Id;
      sFee.Digital_Commerce__c = TRUE;
      insert sFee;
        
      //insert test Add_On__c
      Add_On__c addOn = new Add_On__c();
      addOn.Subscription_Fees__c = sFee.Id;
      addOn.Per_Independently_Managed_Brand__c = 3.00;
      insert addOn;

      List<Id> lstSFeesIds = new List<Id>();
      lstSFeesIds.add(sFee.Id);
        
      Test.startTest();
        
          //call class
      x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      //get Subscription_Fees__c record to check update
      Add_On__c addOnsTest = [SELECT Id, Digital_Commerce_Option_Price__c  //other fields
                           		FROM Add_On__c 
                           		LIMIT 1];

      //check amount
      System.assertEquals(26000.00, addOnsTest.Digital_Commerce_Option_Price__c);

      Test.stopTest();     

  	}  
    
    @IsTest
  	static void setDigitalCommerce_Webfront() {

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

		//insert test Subscription_Fees__c
      	Subscription_Fees__c sFee = new Subscription_Fees__c();
      	sFee.Opportunity__c = opp.Id;
      	sFee.Digital_Commerce__c = TRUE;
      	insert sFee;
        
      	//insert test Add_On__c
      	Add_On__c addOn = new Add_On__c();
      	addOn.Subscription_Fees__c = sFee.Id;
        addOn.Webfront__c = TRUE;
        addOn.Per_Independently_Managed_Brand__c = 3.00;
      	addOn.Per_DC_Implementation__c = 2.00;
      	addOn.Per_Website__c = 2.00;
      	insert addOn;

      	List<Id> lstSFeesIds = new List<Id>();
      	lstSFeesIds.add(sFee.Id);
        
      	Test.startTest();
        
        //call class
      	x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      	//get Subscription_Fees__c record to check update
      	Add_On__c addOnsTest = [SELECT Id, Digital_Commerce_Option_Price__c  //other fields
                           		FROM Add_On__c 
                           		LIMIT 1];

      	//check amount
      	System.assertEquals(42000.00, addOnsTest.Digital_Commerce_Option_Price__c);

      	Test.stopTest();     

  	}    

    @IsTest
  	static void setDigitalCommerce_DistanceSellingCheckout() {

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

		//insert test Subscription_Fees__c
      	Subscription_Fees__c sFee = new Subscription_Fees__c();
      	sFee.Opportunity__c = opp.Id;
      	sFee.Digital_Commerce__c = TRUE;
      	insert sFee;
        
      	//insert test Add_On__c
      	Add_On__c addOn = new Add_On__c();
      	addOn.Subscription_Fees__c = sFee.Id;
      	addOn.Per_Independently_Managed_Brand__c = 3.00;
        addOn.Distance_Selling_Checkout__c = TRUE;
      	addOn.Per_DC_Implementation__c = 2;
      	insert addOn;

      	List<Id> lstSFeesIds = new List<Id>();
      	lstSFeesIds.add(sFee.Id);
        
      	Test.startTest();
        
        //call class
      	x_SubscriptionFeesLookup.setTotals(lstSFeesIds);
        
      	//get Subscription_Fees__c record to check update
      	Add_On__c addOnsTest = [SELECT Id, Digital_Commerce_Option_Price__c  //other fields
                           		FROM Add_On__c 
                           		LIMIT 1];

      	//check amount
      	System.assertEquals(38000.00, addOnsTest.Digital_Commerce_Option_Price__c);

      	Test.stopTest();     

  	}    
        
}