public class x_TriggerHandlerLead {
	static public void onLeadBeforeInsert(List<Lead> insertLeads) {
    	markSpamLeads(insertLeads);
    }

	static public void onLeadAfterInsert(List<Lead> insertLeads) {
    	deleteSpamLeads(insertLeads);
    }
    
	private static void markSpamLeads(List<Lead> leads) {
        
        //get the custom settings
        List<Lead_Spam_Company__c> lstSpamCompanies = Lead_Spam_Company__c.getall().values();
        
        for(Integer i = 0; i < leads.size(); i++){
            //cycle through the lead spam companies (custom settings)
            for(Integer j = 0; j < lstSpamCompanies.size(); j++){
                if (lstSpamCompanies[j].Company__c == leads[i].company){
                    //set the spam checkbox
                    leads[i].spam__c = true;
                }
            }
            // to turn the Lead Assignment Rules on - Fetching the assignment rules on case
            //AssignmentRule AR = new AssignmentRule();
            //AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
 
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            //Database.DMLOptions dmlOpts = new Database.DMLOptions();
            //dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            //leads[i].setOptions(dmlOpts);  
        }  
    }   
    
	private static void deleteSpamLeads(List<Lead> leads) {
        
        Set<Id> LeadIds = new Set<Id>();
        
		//create list of spam leads to delete
        for(Integer i = 0; i < leads.size(); i++){
            If (leads[i].spam__c == true){
                LeadIds.add(leads[i].Id);
            }
    	}
        
        //delete on a future
        x_DeleteLeadSpam.deleteLeadSpam(LeadIds);
        
    }    
}