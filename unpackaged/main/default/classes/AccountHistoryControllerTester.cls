@isTest  (SeeAllData=true)
public class AccountHistoryControllerTester {

  static testMethod void myTestAccountHistoryComponentController() {
        
        AccountHistoryComponentController controller = new AccountHistoryComponentController();
		
		system.assert(controller.getObjectHistory().size() == 0);

        system.assert([select Accountid from accounthistory where isdeleted=false limit 1].size() == 1);
        string accid = [select Accountid from accounthistory where isdeleted=false limit 1].accountid;
        
		controller.Account = [select id from Account where id=:accid];				
        system.assert(controller.getObjectHistory().size() > 0);        
  }

}