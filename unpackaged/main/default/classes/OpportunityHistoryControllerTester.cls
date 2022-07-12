/**
 * @description       : 
 * @author            : Planet
 * @group             : 
 * @last modified on  : 09-03-2021
 * @last modified by  : Florin Galea
**/
@isTest  (SeeAllData=true)
public class OpportunityHistoryControllerTester {

  static testMethod void myTestOpportunityHistoryComponentController() {
        
        OpportunityHistoryComponentController controller = new OpportunityHistoryComponentController();
        
        system.assert(controller.getObjectHistory().size() == 0);

        system.assert([select Opportunityid from opportunityhistory where isdeleted=false limit 1].size() == 1);
        string oppid = [select Opportunityid from opportunityhistory where isdeleted=false limit 1].opportunityid;
        
        controller.Opportunity = [select id from Opportunity where id=:oppid];              
        system.assert(controller.getObjectHistory().size() >= 0);        
  }

}