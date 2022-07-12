@isTest
private class TestLyncResource {
    static testMethod void MttlLyncResource1(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com');
            insert u;

      
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn","action":"StatusChanged","lyncUser":"sip:test.test@salesforce.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn','StateChanged','sip:test.test@salesforce.com');
            List<LyncUserLoginMaster__c> lulm=[SELECT id FROM LyncUserLoginMaster__c];
            System.assertEquals(1,lulm.size());
            
         
         
      
    }
     static testMethod void MttlLyncResource2(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com');
            insert u;

        System.runAs(u){
      
            StreamingObject__c s=new StreamingObject__c ();
            s.name='test';
            s.SetupOwnerid =u.id;
            insert s;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn","action":"OnHold","lyncUser":"sip:test.test@salesforce.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn','OnHold','sip:test.test@salesforce.com');
            StreamingObject__c lulm=[SELECT id,Lync_Notifications__c  FROM StreamingObject__c];
            System.assertEquals('OnHold',lulm.Lync_Notifications__c );
           
         }
         
      
    }
    
     static testMethod void MttlLyncResource3(){
       
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com');
            insert u;

        System.runAs(u){
      
            StreamingObject__c s=new StreamingObject__c ();
            s.name='test';
            s.SetupOwnerid =u.id;
            insert s;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn","action":"Transferring","lyncUser":"sip:test.test@salesforce.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn','Transferring','sip:test.test@salesforce.com');
            StreamingObject__c lulm=[SELECT id,Lync_Notifications__c  FROM StreamingObject__c];
            System.assertEquals('Transferring',lulm.Lync_Notifications__c );
           
         }
         
      
    }
   static testMethod void MttlLyncResource4(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com');
            insert u;

        System.runAs(u){
      
            StreamingObject__c s=new StreamingObject__c ();
            s.name='test';
            s.SetupOwnerid =u.id;
            insert s;
            
            OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"Available","action":"StatusChanged","lyncUser":"sip:test.test@salesforce.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','Available','StatusChanged','sip:test.test@salesforce.com');
            LyncUserStatusMaster__c lulm=[SELECT id,Status__c FROM LyncUserStatusMaster__c];
            System.assertEquals('Available',lulm.Status__c);
           
         }
         
      
    }
    
     static testMethod void MttlLyncResource5(){
        
             Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com');
            insert u;

       
      
            StreamingObject__c s=new StreamingObject__c ();
            s.name='test';
            s.SetupOwnerid =userinfo.getUserId();
            insert s;
           
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"Available","action":"StatusChanged","lyncUser":"sip:test.test@salesforce.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','Available','StatusChanged','sip:test.test@salesforce.com');
            LyncUserStatusMaster__c lulm=[SELECT id,Status__c FROM LyncUserStatusMaster__c];
            System.assertEquals('Available',lulm.Status__c);
           
       
         
      
    }
    
    
      static testMethod void MttlLyncResource6(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callfrom');
            insert u;

        System.runAs(u){
      
            StreamingObject__c s=new StreamingObject__c ();
            s.name='test';
            s.SetupOwnerid =u.id;
            insert s;
            
            OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Notified1","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Notified1','sip:mtk2016@testorg.com');
            StreamingObject__c lulm=[SELECT id,Lync_Notifications__c  FROM StreamingObject__c];
            System.assertEquals('Notified1',lulm.Lync_Notifications__c );
           
         }
              
    }
    
     static testMethod void MttlLyncResource7(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callto');
            insert u;

        System.runAs(u){
      
            StreamingObject__c s=new StreamingObject__c ();
            s.name='test';
            s.SetupOwnerid =u.id;
            insert s;
            
            OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Notified1","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Notified1','sip:mtk2016@testorg.com');
            StreamingObject__c lulm=[SELECT id,Lync_Notifications__c  FROM StreamingObject__c];
            System.assertEquals('Notified1',lulm.Lync_Notifications__c );
           
         }
              
    }
           static testMethod void MttlLyncResource8(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callfrom');
            insert u;

        System.runAs(u){
      
           
            
            OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Notified1","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Notified1','sip:mtk2016@testorg.com');
            StreamingObject__c lulm=[SELECT id,Lync_Notifications__c,External_No__c  FROM StreamingObject__c];
            System.assertEquals('callto',lulm.External_No__c);
           
         }
              
    }
    
      static testMethod void MttlLyncResource9(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callto');
            insert u;

        System.runAs(u){
      
           
            
            OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Notified1","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Notified1','sip:mtk2016@testorg.com');
            StreamingObject__c lulm=[SELECT id,Lync_Notifications__c,External_No__c  FROM StreamingObject__c];
            System.assertEquals('callfrom',lulm.External_No__c);
           
         }
              
    }
    
     static testMethod void MttlLyncResource10(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callto');
            insert u;

        System.runAs(u){
      
           
             OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
           
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Notified","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Notified','sip:mtk2016@testorg.com');
            AllCallsInfo__c lulm=[SELECT id,Call_From__c  FROM AllCallsInfo__c];
            System.assertEquals('callfrom',lulm.Call_From__c);
           
         }
              
    }
    
     static testMethod void MttlLyncResource11(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callto');
            insert u;

        System.runAs(u){
      
           
             OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
           
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Connecting","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Connecting','sip:mtk2016@testorg.com');
            AllCallsInfo__c lulm=[SELECT id,Call_From__c  FROM AllCallsInfo__c];
            System.assertEquals('callfrom',lulm.Call_From__c);
           
         }
              
    }
    
    static testMethod void MttlLyncResource12(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callto');
            insert u;

        System.runAs(u){
      
           
             OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
           
            AllCallsInfo__c a=new AllCallsInfo__c();
            a.Call_From__c='callfrom';
            a.Call_To__c='callto';
            a.call_Type__c='Notified';
            a.User_Agent__c='mtk2016@testorg.com';
            insert a;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Connected","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Connected','sip:mtk2016@testorg.com');
            AllCallsInfo__c lulm=[SELECT id,Call_From__c  FROM AllCallsInfo__c];
            System.assertEquals('callfrom',lulm.Call_From__c);
           
         }
              
    }
    
     static testMethod void MttlLyncResource13(){
        
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='mtk2016@testorg.com',LyncId__c='callto');
            insert u;

        System.runAs(u){
      
           
             OutgoingStreamingObject__c s1=new OutgoingStreamingObject__c();
            s1.Call_Status__c='StatusChanged';
            s1.User_Status__c='Busy';
            s1.SetupOwnerId=u.id;
            insert s1;
           
            AllCallsInfo__c a=new AllCallsInfo__c();
            a.Call_From__c='callfrom';
            a.Call_To__c='callto';
            a.call_Type__c='Incoming';
            a.User_Agent__c='mtk2016@testorg.com';
            a.Start_of_the_call__c=System.now();
            insert a;
      
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/Lync';
            req.requestbody=Blob.valueOf('{"user":"test@test.com.test1","detail":"SignedIn:callfrom,test123:callto","action":"Disconnected","lyncUser":"sip:mtk2016@testorg.com"}');
            req.httpMethod = 'POST';
           
            RestContext.request = req;
            RestContext.response = res;
            LyncResource.doPost('mtk2016@testorg.com','SignedIn:callfrom,test123:callto,Incoming','Disconnected','sip:mtk2016@testorg.com');
            AllCallsInfo__c lulm=[SELECT id,Call_From__c  FROM AllCallsInfo__c];
            System.assertEquals('callfrom',lulm.Call_From__c);
           
         }
              
    }
    
    
        
   

}