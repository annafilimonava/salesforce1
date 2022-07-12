@isTest
private class TestMttloutgoingcallstd
{
    static testMethod void Mttloutgoingcallstd()
    {    
       pageReference pg = page.MttlOutgoingCallStd;
       Test.setCurrentPage(pg);
       ApexPages.currentPage().getParameters().put('outgoingId','919705901806');
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
       MttlOutgoingCallStdcontroller oc = new MttlOutgoingCallStdcontroller();
       list<list<sobject>> temp =  oc.soslResults; 
       MttlOutgoingCallStdcontroller.searchResultRow wc = new MttlOutgoingCallStdcontroller.searchResultRow(con);
       wc.sObjectTypeName='Testc';
       wc.record=con;
       list<MttlOutgoingCallStdcontroller.searchResultRow> temp1 = oc.searchResults;
       oc.incomingcallerId='Testcon'; 
       oc.CreateOutgoingRecord();
       oc.lyncInboundCall('','','');
    }
    
}