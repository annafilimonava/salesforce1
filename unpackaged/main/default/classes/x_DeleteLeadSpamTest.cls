@isTest
public class x_DeleteLeadSpamTest {
	static void setup() {
  	}
    
  	@IsTest
  	static void testDeleteLeadSpam() {
      
		Lead newLead = new Lead();
      	newLead.LastName = 'Test';
      	newLead.Company = 'Test';
      	newLead.Lead_Type__c = 'Tax Free';
		newLead.Country = 'United Kingdom';
      	newLead.Status = 'Open';
      
		insert newLead;
        
        List<Lead> leads =[select id from Lead where id=: newLead.id];
    	System.assertEquals(1, leads.size()); 
      
        Test.startTest();
        
        delete leads;
        
        Test.stopTest();
        
        List<Lead> delLeads =[select id from Lead where id=:leads];
    	System.assertEquals(0, delLeads.size()); 
  	}    
}