@isTest
Public class TestMttlGlobalSearch
{
    // Positive scenario
    static testMethod void searchdetails()
    {
       // Declare string
       string searchStr;
       MttlGlobalSearchController gs = new MttlGlobalSearchController();
       // String length more than 2 characters condition staisfied here
       gs.searchStr='Ragava';
       System.assert(gs.searchStr.length() > 2);
       gs.soslSearchMethod();       
    }
    // Negative scenario
    static testMethod void negsearchdetails()
    {
       string searchStr;
       MttlGlobalSearchController gsn = new MttlGlobalSearchController();
       gsn.searchStr='R';
       System.assert(gsn.searchStr.length() < 2);
       gsn.soslSearchMethod();       
    }
}