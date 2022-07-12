public with sharing class MttlFooterOutgoingCallController{
    private String soql {get;set;}
    public boolean contactBlock{set;get;}
    public List<Contact> contactList{set;get;}
    Public list<user> lstusr{get;set;}
    public boolean rightbodyBlock{set;get;}
    public boolean defaultrightbodyBlock{set;get;}
    public List<Task> activityList{set;get;}
    public boolean block1{set;get;}
    public boolean block2{set;get;}
    public boolean block3{set;get;}
    Public boolean block4{get;set;}
    public boolean acceptbtn{set;get;}
    public boolean cancelbtn{set;get;}
    public boolean endcallbtn{set;get;}
    Public List<account> acc;
    Public list<Contact> lstcon;
     Public list<AllCallsInfo__c > usercallsInfo{set;get;}
     Public list<AllCallsInfo__c > callsInfo{set;get;}
    Public string extsearchname{get;set;}
    public List<String> recentviewedcontacts{set;get;}

    Public void displayBlock(){}
    
     public MttlFooterOutgoingCallController() {
     try{
      st=[SELECT Call_Status__c,Name,User_Status__c FROM OutgoingStreamingObject__c where SetupOwnerid = : UserInfo.getUserId()];
      }
      catch(Exception e){
      }
        block1=true;
       block2=false;
       block3=false;
       block4 =false;
       acceptbtn=false;
       cancelbtn=false;
       endcallbtn=false;
       callsInfo = new list<AllCallsInfo__c >();
       recentviewedcontacts=new List<String>();
      
       if(Test.isRunningTest() == false)
        {   
           String myQuery = 'SELECT Id FROM RecentlyViewed WHERE Type = \'Contact\' ORDER BY LastViewedDate DESC';
            for(SObject s: Database.query(myQuery)){
               recentviewedcontacts.add(s.Id);
            }
      
       contactList=[select Id,Name,MobilePhone,Phone FROM Contact WHERE MobilePhone!= Null AND id IN:recentviewedcontacts  ORDER BY  LastViewedDate DESC limit 100];
         }
       
       lstusr=new list<user>([SELECT id,name,MobilePhone,LyncId__c FROM User]);
       activityList=[SELECT Priority,Status,Subject,What.Name,Who.Name,Createddate FROM Task where OwnerId=:Userinfo.getUserId() ORDER By Createddate DESC];
       usercallsInfo=[SELECT CallDuration__c,Call_Category__c,Call_From__c,Call_To__c,Call_Type__c,Created_Date__c,End_of_the_call__c,Start_of_the_call__c,User_Agent__c,OwnerId,Createddate FROM AllCallsInfo__c where OwnerId=:Userinfo.getUserId() AND Createddate=TODAY ORDER By Createddate DESC];
       soql = 'select firstname, lastname, Id,Name,MobilePhone,Phone from contact where name != null';
       //runQuery();
       if(extsearchname != null){
           Externalnumsearch();
       }
    }
    
    public Contact selCon{set;get;}
    public void displayContact(){     
      block1=false;
      block2=true;
      block3=false;
      block4 = false;
      acceptbtn=true;
      cancelbtn=true;
      endcallbtn=false;
     
      selCon=[select Id,Name,MobilePhone,Phone FROM Contact WHERE id=:Apexpages.currentPage().getParameters().get('conId')];  
    }
    
     public void ConnectingBlock(){     
      contactBlock=true;
      rightbodyBlock=true;
      defaultrightbodyBlock=false;
      block1=false;
      block2=false;
      block3=true;
      block4 = false;
      
      acceptbtn=false;
      cancelbtn=true;
      st=[SELECT Call_Status__c,Name,User_Status__c FROM OutgoingStreamingObject__c where SetupOwnerid = : UserInfo.getUserId() LIMIT 1];    
      if(st.Call_Status__c=='Connected'){
        endcallbtn=true;
      }
    }
    
    public void cancelOnGoingcall(){     
       block1=true;
       block2=false;
       block3=false;
      block4 = false;
        }
    public void ConnectedBlock(){     
      contactBlock=true;
      rightbodyBlock=true;
      defaultrightbodyBlock=false;
      block1=false;
      block2=false;
      block4 = false;
      acceptbtn=false;
      cancelbtn=false;
      endcallbtn=true;
      selCon=[select Id,Name,MobilePhone,Phone FROM Contact WHERE id=:Apexpages.currentPage().getParameters().get('conId')];  
    }
    
    // External Block
    Public void externalcontact(){
       block1=false;
       block2=false;
       block3=false;
       block4 = true;
       contactBlock=false;
       rightbodyBlock=false;
       defaultrightbodyBlock=false;
    }
    // External block end 
    Public void externalcontactend(){
       block1=true;
       block2=false;
       block3=false;
       block4 = false; 
    }
    
    // Contact End call
    Public void contactend(){
       block1=true;
       block2=false;
       block3=false;
       block4 = false; 
    }
    public string callnotes{set;get;}
    
    public void addNotes(){
       block1=true;
       block2=false;
       block3=false;
       block4 = false; 
     Task t=new Task();
     t.whoId=selCon.id;
     t.subject='Out Going Call';
     t.ownerId=Userinfo.getUserId();
     t.Priority='high';
     t.status='Completed';
     t.Description=callnotes;
     insert t;
     system.debug('@@@@insert Task!@@@'+t);
     defaultrightbodyBlock=true;
     rightbodyBlock=false;
     System.debug('----------------------------------'+callnotes);
    }
    // search
    
    public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql { get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
 
  
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
      contactList= Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
    } catch (Exception e) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String cName = Apexpages.currentPage().getParameters().get('Name');
     
    soql = 'select firstname, lastname, Id,Name,MobilePhone,Phone from contact where name != null ';
    
    if (!cName.equals(''))
      soql += ' and name LIKE \''+String.escapeSingleQuotes(cName)+'%\' limit 1000';  
     
    // run the query again
    runQuery();
 
    return null;
  }

    
    
    //end
    public String userstatus{set;get;}
    Public OutgoingStreamingObject__c st{set;get;}
    //public void outgoingCalls(String userStatus,String callstatus,String user){
      public void outgoingCalls(String user,String userStatus,String callstatus){ 
       List<OutgoingStreamingObject__c> delStrObj = [SELECT Call_Status__c,Name,User_Status__c FROM OutgoingStreamingObject__c where SetupOwnerid = : UserInfo.getUserId()];
      if(delStrObj.size()>0){
      delete delStrObj;
      }
       OutgoingStreamingObject__c obj=new OutgoingStreamingObject__c();
       obj.Name=user;
       obj.Call_Status__c=callstatus;
       obj.User_Status__c=userStatus;
       insert obj;
       st=[SELECT Call_Status__c,Name,User_Status__c FROM OutgoingStreamingObject__c where SetupOwnerid = : UserInfo.getUserId()];
       
       
    }
    
    public void updateUserStatus(){
                String uid=userinfo.getUserId();
              
                map<id,OutgoingStreamingObject__c> lststrobj=new map<id,OutgoingStreamingObject__c>();            
                for(OutgoingStreamingObject__c sForceObj: [SELECT name, id,SetupOwnerid FROM OutgoingStreamingObject__c where SetupOwnerid=:uid]){
                    lststrobj.put(sForceObj.SetupOwnerid, sForceObj);
                }
                
                boolean recBoolOpt = true;
                if(lststrobj.keyset().size()>0){
                    system.debug('INside:......:');
                    if(lststrobj.containsKey(uid)){
                        //lststrobj.get(user).Name =currentuser;
                        //lststrobj.get(uid).Call_Status__c=callstatus;
                        lststrobj.get(uid).User_Status__c=Apexpages.currentpage().getparameters().get('userstatus');
                        Update lststrobj.get(uid);
                        recBoolOpt = false;
                    }                  
                }
                if(recBoolOpt){
                    OutgoingStreamingObject__c topic = new OutgoingStreamingObject__c();
                    topic.SetupOwnerid=uid;
                    topic.Name = uid;
                    topic.User_Status__c=Apexpages.currentpage().getparameters().get('userstatus');
                    insert topic;
                    system.debug('NewRec:......:'+topic.id);
                }
  
    }
    
 
    
    // External Number Search
    Public void Externalnumsearch(){
       block1=false;
       block2=false;
       block3=false;
       block4 = true; 
        string extrphno =apexpages.currentpage().getparameters().get('extrphno');
        acc = [Select id, Name From Account where Account_Phone_Number__c = :extrphno LIMIT 1];
            if(acc.size() != 0){
                extsearchname=acc[0].Name;
            }
            else if(acc.size() == 0 || acc.size() == null) {        
                try{
                    lstcon = [Select Id,Name,Contact_Mobile__c From Contact where Contact_Mobile__c= :extrphno LIMIT 1];
                    extsearchname=lstcon[0].Name;
                }
                Catch(Exception e){extsearchname='Un-Known';
                }
            }
    
    }
    
     // Add notes for external Number
    public void addNotesexternalnumber(){
     block2=false;
     block1=true;
     block3=false;
     block4 = false; 
     Task t1=new Task();
     t1.whoId=lstcon[0].id;
     system.debug('@@@@@t1.whoId'+t1.whoId);
     t1.subject='Out Going Call';
     t1.ownerId=Userinfo.getUserId();
     t1.Priority='high';
     t1.status='Completed';
     t1.Description=callnotes;
     insert t1;
     system.debug('@@@@insert Task1@!@@@'+t1);
     defaultrightbodyBlock=true;
     rightbodyBlock=false;
     System.debug('----------------------------------'+callnotes);
    }
    public string contkey{get;set;}
    public void filterContacts(){
      
      string s1 = '%'+contkey+'%';
      //String[] filters = new String[]{s1};
     
      system.debug('helll--------------------------------------------'+s1);
      system.debug('helll before--------------------------------------------'+contactList.size() );
      if(contkey.length()>0){
   
          contactList = [select name from contact where name like :s1 and MobilePhone != Null limit 1000];
      }
      else{
         if(Test.isRunningTest() == false)
        {   
           String myQuery = 'SELECT Id FROM RecentlyViewed WHERE Type = \'Contact\' ORDER BY LastViewedDate DESC';
            for(SObject s: Database.query(myQuery)){
               recentviewedcontacts.add(s.Id);
            }
      
            contactList=[select Id,Name,MobilePhone,Phone FROM Contact WHERE MobilePhone!= Null AND id IN:recentviewedcontacts  ORDER BY  LastViewedDate DESC limit 100];
         }
      }
      system.debug('helll after--------------------------------------------'+contactList.size() );
    }  
}