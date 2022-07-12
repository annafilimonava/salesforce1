@isTest
private class TestMttlIncomingcall
{
    static testMethod void mttlincomingcalldetails()
    {
       StreamingObject__c so = new StreamingObject__c();
       so.name = 'Incoming Call';
       so.SetupOwnerId=userinfo.getuserid();
       so.Calling_From__c ='+919246419006';
       so.CurrencyIsoCode='EUR';
       insert so; 
       
       string incmingId;
       contact con = new contact();
       con.lastname ='Mark Bin';
       con.mobilephone='+919705901806';
       con.MailingCountry = 'United Kingdom';
       insert con;
       con.id=incmingId;
       if(so.Calling_From__c != null || so.Calling_From__c != ''){
            
       }
       MttlIncomingcallcontroller ic = new MttlIncomingcallcontroller();
       list<list<sobject>> temp =  ic.soslResults; 
      MttlIncomingcallcontroller.searchResultRow wc = new MttlIncomingcallcontroller.searchResultRow(con);
      wc.sObjectTypeName='Testc';
      wc.record=con;
      list<MttlIncomingcallcontroller.searchResultRow> temp1 = ic.searchResults;
       ic.incomingcallerId='Testcon';
    }
    
}