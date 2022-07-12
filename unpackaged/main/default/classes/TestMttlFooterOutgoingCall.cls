@isTest
private class TestMttlFooterOutgoingCall{
    static testMethod void MttlFooterOutgoingCall()
    {
        // Insert Contacts data
        String conId;
        Contact con = new contact();
        
        con.lastname='TestRag';
        con.MailingCountry = 'United Kingdom';
        Insert con;
        // Insert custom settings data(Outgoing Call)
        OutgoingStreamingObject__c os = new OutgoingStreamingObject__c();
        os.name = 'OutgoingCall';
        os.SetupOwnerId=userinfo.getuserid();
        os.Call_Status__c='Connected';
        os.User_Status__c='Available';
        insert os; 
        
        apexpages.currentpage().getparameters().put('conId',con.id);
        Apexpages.currentPage().getParameters().Put('Name','Ragava');
       
       test.startTest(); 
       MttlFooterOutgoingCallController foc = new MttlFooterOutgoingCallController();
       List<String> conliIds=new List<String>();
       conliIds.add(con.Id);
       foc.recentviewedcontacts=conliIds;
       foc.cancelOnGoingcall();
       foc.externalcontact();
       foc.externalcontactend();
       foc.contactend();
       foc.displayBlock();
       foc.displayContact();
       foc.ConnectingBlock();
       foc.ConnectedBlock();
       foc.addNotes();
       foc.toggleSort();
       foc.runQuery();
       foc.runSearch();
       //foc.outgoingCalls('xyz','abx','ghy');
       foc.updateUserStatus();
       foc.Externalnumsearch();
        foc.addNotesexternalnumber();
        foc.contkey='TestRag';
        foc.filterContacts();
       test.stopTest();
    }
    
}