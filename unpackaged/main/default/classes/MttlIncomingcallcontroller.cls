public with sharing class MttlIncomingcallcontroller{ 
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
 Public boolean accountblock{get;set;}
 
 public MttlIncomingcallcontroller() {
     accountblock = true;
      lstusr=[Select Name,LyncId__c FROM User];
      system.debug('==================lstusr======================'+lstusr);
      callingInformation = [Select Id, createdbyId,Name, Calling_From__c,SetupOwnerid  FROM StreamingObject__c where SetupOwnerid=:userinfo.getUserId()];
      system.debug('========================================'+callingInformation);
      accountList = [Select id, Name, Phone, Account_Phone_Number__c, (Select Name, Email, MobilePhone, title, Phone, AccountId, Account.Name, Mobile__c, Contact_Mobile__c From Contacts) From Account where Account_Phone_Number__c = :callingInformation.Calling_From__c limit 1];
      system.debug('==================accountList======================'+accountList);
      mainformblock=true;
      globalsearchblock=false;
      if (accountList.size() == 0) { 
      accountblock=false;       
           try{
               lstcon = [Select Id,Name, Email, MobilePhone, title, Phone, AccountId, Account.Name, Mobile__c,(SELECT id,casenumber, subject, priority, description FROM cases) Contact_Mobile__c From Contact where Contact_Mobile__c =:callingInformation.Calling_From__c];
               system.debug('===============lstcon=================================='+lstcon);
               popupcontactName=lstcon[0].Name;
               incomingcallerId=lstcon[0].Id;
               system.debug('===========try block====popupcontactName=================================='+popupcontactName);
               system.debug('===========try block====incomingcallerId=================================='+incomingcallerId);
           }
           Catch(Exception e){
               popupcontactName=callingInformation.Calling_From__c;
               mainformblock=false;
               globalsearchblock=true;
               system.debug('===========catch block====popupcontactName=================================='+popupcontactName);
              
           }
          /*  lstcon = [Select Id,Name, Email, MobilePhone, title, Phone, AccountId, Account.Name, Mobile__c,(SELECT id,casenumber, subject, priority, description FROM cases) Contact_Mobile__c From Contact where Mobile__c =: callingInformation.Calling_From__c];
               system.debug('@@@@ lstcon@@@@@'+lstcon);
               popupcontactName=lstcon[0].Name;
               incomingcallerId=lstcon[0].Id;
                      
           if(lstcon.size()==0){
               popupcontactName=callingInformation.Calling_From__c;
               mainformblock=false;
               globalsearchblock=true;
            }   */
      }    
}
 // SOSL for searching account,contacts and Cases
    public list<list<sObject>> soslResults {
        get {
            if(callingInformation.Calling_From__c != null && callingInformation.Calling_From__c != '') {
                soslResults = [FIND :callingInformation.Calling_From__c IN ALL FIELDS RETURNING   Account(name,phone),Contact(name,Contact_Mobile__c),case(subject,casenumber)];
                system.debug('===========soslResults=================================='+soslResults);
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
            system.debug('========searchResultRow===sObjectTypeName=================================='+sObjectTypeName);
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
    

 /*public void lyncInboundCall(String userName,String calfrom,String callstatus) {
    
      
      StreamingObject__c topic = new StreamingObject__c();
      topic.Name = userName;
      topic.Calling_From__c = calfrom;
      topic.Lync_Notifications__c =callstatus;
      //topic.Call_Status__c=callstatus;
      insert topic;
 }*/
 
 
}