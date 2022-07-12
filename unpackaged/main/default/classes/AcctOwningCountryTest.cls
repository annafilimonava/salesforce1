@isTest
private class AcctOwningCountryTest {
    
    @isTest static void insertAccount() {
     		Account myAccount = new Account ();
        	myAccount.Name = 'Test Company';
            insert myAccount;     
    	        
    } 
}