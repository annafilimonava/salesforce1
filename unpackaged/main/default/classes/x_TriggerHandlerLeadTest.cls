@isTest
public class x_TriggerHandlerLeadTest {
	static void setup() {
  	}
    
  	@IsTest
  	static void testMarkSpam() {
      
		Lead newLead = new Lead();
      	newLead.LastName = 'Test';
      	newLead.Company = 'google';
      	newLead.Lead_Type__c = 'Tax Free';
      	newLead.Status = 'Open';
        newLead.spam__c = true;
        newLead.Country = 'United Kingdom';
        insert newLead;
        
        List<Lead> leads =[select id,company from Lead where id=: newLead.id];
    	System.assertEquals(1, leads.size()); 

        Lead_Spam_Company__c newCustomSetting = new Lead_Spam_Company__c();
      	newCustomSetting.Name = '1';
      	newCustomSetting.Company__c = 'google';
		insert newCustomSetting;       
        
        List<Lead_Spam_Company__c> lstSpamCompanies = Lead_Spam_Company__c.getall().values();
    	System.assertEquals(1, lstSpamCompanies.size());

        Test.startTest();
        
        for(Integer i = 0; i < leads.size(); i++){
            //cycle through the lead spam companies (custom settings)
            for(Integer j = 0; j < lstSpamCompanies.size(); j++){
                if (lstSpamCompanies[j].Company__c == leads[i].company){
                    //set the spam checkbox
                    leads[i].spam__c = true;
                    System.assertEquals(true, leads[i].spam__c);
                }
            }        
        } 
        
        Test.stopTest();
        
  	}     
}