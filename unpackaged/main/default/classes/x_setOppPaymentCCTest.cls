@IsTest
public class x_setOppPaymentCCTest {
	static void setup() {
  	}
    
  	@IsTest
  	static void setPayCardChargeExists() {

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
        
		//insert test payment card charge
        Payment_Card_Charge__c pcc = new Payment_Card_Charge__c();
        pcc.Owning_Country__c = 'United Kingdom';
        pcc.Visa_MC_Intl__c = 1;
        pcc.Visa_MC_Domestic_EEA__c = 1;
        pcc.UnionPay__c = 1;
        pcc.JCB__c = 1;
        pcc.CurrencyIsoCode = 'GBP';
        pcc.Chinese_Wallets_e_Comm__c = 1;
        pcc.Chinese_Wallets__c = 1;
        pcc.Amex__c = 1;
        insert pcc;
        
        List<Id> lstOppIds = new List<Id>();
        lstOppIds.add(opp.Id);
        
        Test.startTest();
        
        String paymentCardChargeId = [SELECT Id, Owning_Country__c
                                      FROM Payment_Card_Charge__c
                                     ].Id;
        
        System.assert(paymentCardChargeId != null);  

        //call methis to set the opportunity payment card charge
        x_setOppPaymentCC.setPayCardCharge(lstOppIds);
        
        //get Opportunity record to check update
        Opportunity oppTest = [SELECT Id, Owning_Country__c, Payment_Card_Charge__c
                           		FROM Opportunity 
                           		LIMIT 1];
        
        //check the payment card charges match
        System.assertEquals(paymentCardChargeId, oppTest.Payment_Card_Charge__c);

        Test.stopTest();     
    
  }
    
  	@IsTest
  	static void setPayCardChargeMissing() {

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
        
		//insert test payment card charge
        Payment_Card_Charge__c pcc = new Payment_Card_Charge__c();
        pcc.Owning_Country__c = 'France';
        pcc.Visa_MC_Intl__c = 1;
        pcc.Visa_MC_Domestic_EEA__c = 1;
        pcc.UnionPay__c = 1;
        pcc.JCB__c = 1;
        pcc.CurrencyIsoCode = 'GBP';
        pcc.Chinese_Wallets_e_Comm__c = 1;
        pcc.Chinese_Wallets__c = 1;
        pcc.Amex__c = 1;
        insert pcc;
        
        List<Id> lstOppIds = new List<Id>();
        lstOppIds.add(opp.Id);
        
        Test.startTest();
        
        String paymentCardChargeId = [SELECT Id, Owning_Country__c
                                      FROM Payment_Card_Charge__c
                                     ].Id;
        
        System.assert(paymentCardChargeId != null);  

        //call methis to set the opportunity payment card charge
        x_setOppPaymentCC.setPayCardCharge(lstOppIds);
        
        //get Opportunity record to check update
        Opportunity oppTest = [SELECT Id, Owning_Country__c, Payment_Card_Charge__c
                           		FROM Opportunity 
                           		LIMIT 1];
        
        //check the payment card charges on Opp is null as there is no payment card charge existing
        System.assertEquals(null, oppTest.Payment_Card_Charge__c);

        Test.stopTest();     
    
  }
    
    
}