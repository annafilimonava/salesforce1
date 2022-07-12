public with sharing class MttlOutgoingCallStdcontroller{ 
 Public list<user> lstusr{get;set;}
 //Public list<order> lstordr{get;set;}
 Public boolean globalsearchblock{get;set;}
 Public boolean mainformblock{get;set;}
 //public boolean contactblock {get;set;}
 public String incomingcallerId{set;get;}
 public String popupcontactName{get;set;}
 Public list < contact > lstcon {get;set;}
 //Public boolean accountblock{get;set;}
 public List < Account > accountList {get;set;}
 public StreamingObject__c callingInformation {get;set;}
 Public string getConMobile;
 public MttlOutgoingCallStdcontroller() {
      String getConMobileno=Apexpages.currentpage().getparameters().get('outgoingId');
      system.debug('@@@@@getConMobileno@@@@'+getConMobile);
      getConMobile='+'+getConMobileno.trim();
      system.debug('@@@@@'+getConMobile);
      lstusr=[Select Name,LyncId__c FROM User];
      
      callingInformation = [Select Id, createdbyId,Name,Calling_From__c,SetupOwner.name,SetupOwnerid FROM StreamingObject__c where SetupOwnerid=:userinfo.getUserId()];
  
      accountList = [Select id, Name, Phone, Account_Phone_Number__c, (Select Name, Email, MobilePhone, title, Phone, AccountId, Account.Name, Mobile__c, Contact_Mobile__c From Contacts) From Account where Account_Phone_Number__c=:getConMobile];
      mainformblock=true;
      globalsearchblock=false;
      if (accountList.size() == 0) {        
           try{
               lstcon = [Select Id,Name, Email, MobilePhone, title, Phone, AccountId, Account.Name, Mobile__c,(SELECT id,casenumber, subject, priority, description FROM cases) Contact_Mobile__c From Contact where Mobile__c LIKE:getConMobile];
               popupcontactName=lstcon[0].Name;incomingcallerId=lstcon[0].Id;
           }
           Catch(Exception e){
               popupcontactName=callingInformation.Calling_From__c;
               mainformblock=false;
               globalsearchblock=true;
               
           }
      }    
}

 
 // SOSL for searching account,contacts and Cases
    
    public list<list<sObject>> soslResults {
        get {
            if(getConMobile != null && getConMobile != '') {
                soslResults = [FIND :getConMobile IN ALL FIELDS RETURNING  Contact(name,Contact_Mobile__c),Account(name,phone)];
            }
            return soslResults;
        }
        set;
    }
    
    public class searchResultRow{
        public string sObjectTypeName {get;set;}
        public sObject record {get;set;}
        
        public searchResultRow(sObject pObject) {
            record = pObject;
            sObjectTypeName = pObject.getSObjectType().getDescribe().getLabel();
        }
    }   
    
    public list<searchResultRow> searchResults {
        
        get {
            searchResults = new list<searchResultRow>();
            if(soslResults != null) {
             
                //Loop through the list of list of sObjects from our sosl query
                for(list<sObject> objectList : soslResults) {
                    for(sObject obj : objectList) {
                        searchResults.add(new searchResultRow(obj));
                    }
                }
            }
            else if(soslResults == null){ 
            }
            return searchResults;
        }
        set;
    }
    

 public void lyncInboundCall(String userName,String calfrom,String callstatus) {
    
      
      StreamingObject__c topic = new StreamingObject__c();
      topic.Name = userName;
      topic.Calling_From__c = calfrom;
      topic.Lync_Notifications__c =callstatus;
      insert topic;
 }
 
 
 public void CreateOutgoingRecord(){
        AllCallsInfo__c alCalInfo=new AllCallsInfo__c(); 
        alCalInfo.Call_From__c=[Select LyncId__c From User where id=:UserInfo.getUserId()].LyncId__c;
        alCalInfo.Call_Type__c=String.valueOf(MttlLyncEnums.LyncCallTypes.Outgoing);
        alCalInfo.User_Agent__c=[Select Name,LyncId__c From User where id=:UserInfo.getUserId()].Name;
        alCalInfo.Call_To__c=getConMobile;
        //insert alCalInfo;
 
 }
 
 
}