public class x_DeleteLeadSpam {
	@future
    public static void deleteLeadSpam(Set<Id> leadIdsToDelete)
    {
		List<Lead> leadList = [select id from Lead where Id=:leadIdsToDelete];
        if( leadIdsToDelete.size() > 0 ) 
        { 
            delete leadList; 
        }  
    }    
}