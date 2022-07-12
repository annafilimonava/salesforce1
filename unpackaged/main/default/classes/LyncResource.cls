@RestResource(urlMapping='/Lync/*')
global with sharing class LyncResource { 
  Static String dis=''; 
  @HttpPost
    global static String doPost(String user, String detail,String action,String lyncUser) {
          
           System.debug('------------111---------------'+user+'---22--detail----'+detail+'----action---'+action+'----lyncUser----'+lyncUser);
           User u=[select Name,id,LyncId__c From User where Username=:user];
            System.debug('------------111---------------');
           if(action==String.valueOf(MttlLyncEnums.LyncNotifications.StateChanged)){
                
           system.debug('user:......:'+user+'.....'+detail+'.....'+action+'......'+lyncUser);
           //Inserting record into LyncUserLoginMaster
           LyncUserLoginMaster__c lyncLoginMaster = new LyncUserLoginMaster__c();
           lyncLoginMaster.SFUserName__c=user;
           lyncLoginMaster.Name=lyncUser;
           lyncLoginMaster.LoggedInState__c=detail;           
           lyncLoginMaster.StateChangedOn__c=system.Now();
           lyncLoginMaster.StateChangedAt__c=String.valueOf(system.Now().format('hh:mm:ss'));
           insert lyncLoginMaster;
           
           }
           else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.OnHold)){
           
              id currentuser=userinfo.getUserId();
            
                map<id,StreamingObject__c> lststrobj=new map<id,StreamingObject__c>();            
                for(StreamingObject__c sForceObj: [SELECT name, id,SetupOwnerid FROM StreamingObject__c where SetupOwnerid=:u.id]){
                    lststrobj.put(sForceObj.SetupOwnerid, sForceObj);
                }
                
              
                if(lststrobj.keyset().size()>0){
                    system.debug('INside:......:');
                    if(lststrobj.containsKey(u.id)){
                       
                        lststrobj.get(u.id).Lync_Notifications__c =action;
                        Update lststrobj.get(u.id);
                        
                    }                  
                }
               
             
            
           }
           else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Transferring)){
           
              id currentuser=userinfo.getUserId();
          
                map<id,StreamingObject__c> lststrobj=new map<id,StreamingObject__c>();            
                for(StreamingObject__c sForceObj: [SELECT name, id,SetupOwnerid FROM StreamingObject__c where SetupOwnerid=:u.id]){
                    lststrobj.put(sForceObj.SetupOwnerid, sForceObj);
                }
                
              
                if(lststrobj.keyset().size()>0){
                    system.debug('INside:......:');
                    if(lststrobj.containsKey(u.id)){
                      
                        lststrobj.get(u.id).Lync_Notifications__c =action;
                        Update lststrobj.get(u.id);
                        
                    }                  
                }
               
             
            
           }
           
           else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.StatusChanged)){
            for(StatusLocaleSetting__c sav:[Select Name,Value__c FROM StatusLocaleSetting__c]){
                if(sav.Name==detail){
                  detail=sav.Value__c;
                }
            }
            String uid=u.id;
            id currentuser=userinfo.getUserId();
                map<id,OutgoingStreamingObject__c> lststrobj=new map<id,OutgoingStreamingObject__c>();            
                for(OutgoingStreamingObject__c sForceObj: [SELECT name, id,SetupOwnerid FROM OutgoingStreamingObject__c where SetupOwnerid=:uid]){
                    lststrobj.put(sForceObj.SetupOwnerid, sForceObj);
                }
                
                boolean recBoolOpt = true;
                if(lststrobj.keyset().size()>0){
                    system.debug('INside:......:');
                    if(lststrobj.containsKey(uid)){
                        //lststrobj.get(user).Name =currentuser;
                        lststrobj.get(uid).Call_Status__c=action;
                        lststrobj.get(uid).User_Status__c=detail;
                        Update lststrobj.get(uid);
                        recBoolOpt = false;
                    }                  
                }
                if(recBoolOpt){
                    OutgoingStreamingObject__c topic = new OutgoingStreamingObject__c();
                    topic.SetupOwnerid=uid;
                    topic.Name = uid;
                    topic.Call_Status__c=action;
                    topic.User_Status__c=detail;
                    insert topic;
                    system.debug('NewRec:......:'+topic.id);
                }
       
       
       //end

       //Insert record into LyncUserStatusMaster
       // System.debug('------LyncUserStatusMaster......'+callstatus+'----'+lyncUser+'--------'+user+'--------');
       LyncUserStatusMaster__c lyncUsrStatusMaster = new LyncUserStatusMaster__c();
       lyncUsrStatusMaster.SFUserName__c=user;
       lyncUsrStatusMaster.Name= lyncUser;
       lyncUsrStatusMaster.StatusChangedAt__c=String.valueOf(system.Now().format('hh:mm:ss'));
       lyncUsrStatusMaster.StatusChangedOn__c=system.Now();
       lyncUsrStatusMaster.Status__c=detail;
       insert lyncUsrStatusMaster;
       System.debug('------LyncUserStatusMaster inserted......');
            
           
          
           } 
           else{
            
              String callerfrom;
              String callerto;
              String calltype;
              String[] arrycallers=detail.split(',');
               System.debug('-----------arrycallers1111111111111-------------------------------'+arrycallers);
              String[] arrycallerfrom=arrycallers[0].split(':');
               System.debug('-----------arrycallerfrom2222222222-------------------------------'+arrycallerfrom);
              callerfrom=arrycallerfrom[1];
               System.debug('-----------callerfrom-------------------------------'+callerfrom);
              String[] arrycallerto=arrycallers[1].split(':');
               System.debug('-----------arrycallerto-------------------------------'+arrycallerto);
              callerto=arrycallerto[1];
               System.debug('-----------callerto-------------------------------'+callerto);
              calltype=arrycallers[2];
              System.debug('-----------calltype-------------------------------'+calltype);
              
              //Code for transferred calls
              system.debug('arrycallers.size():......:' + arrycallers.size());
              boolean IsTransferred = false;
              if(arrycallers.size()==4){
              IsTransferred = true;
              }
              
              //-----------------
              id currentuser=userinfo.getUserId();
              //system.debug('currentuser:......:' + currentuser);
                map<id,StreamingObject__c> lststrobj=new map<id,StreamingObject__c>();            
                for(StreamingObject__c sForceObj: [SELECT name, id,SetupOwnerid FROM StreamingObject__c where SetupOwnerid=:u.id]){
                    lststrobj.put(sForceObj.SetupOwnerid, sForceObj);
                }
                
                /*Start: Restricting Incoming calls if the user is already in a call*/
                boolean skippushtopicupdate=false;
                OutgoingStreamingObject__c  ougsto=[SELECT name, id,SetupOwnerid,User_Status__c FROM OutgoingStreamingObject__c where SetupOwnerid=:u.id];
                String struserstatus='In a call';
                 System.debug('----------------------action------------'+action+'---------'+ougsto.User_Status__c);
                if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Notified) && ougsto.User_Status__c==struserstatus){
                   System.debug('----------------------skip pushtopic1------------');
                   //return 'success';
                   skippushtopicupdate=true;
                }
                else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Disconnected) && ougsto.User_Status__c==struserstatus && calltype=='Notified'){
                //user,callerfrom,callerto,calltype,action
                
                   System.debug('-----------skip pushtopic2------------------------');
                  skippushtopicupdate=true;
                 /* List<AllCallsInfo__c> lit=[SELECT Id,Name,Call_From__c,Call_Type__c,User_Agent__c,End_of_the_call__c,createddate FROM AllCallsInfo__c  where   Call_Type__c='Notified'  AND createddate =Today AND Call_From__c=:callerfrom AND Call_To__c=:callerto AND  User_Agent__c=:user ORDER By Createddate DESC];
                  
                  System.debug('-----query-----------'+lit);
                  System.debug('-----query-size------'+lit.size());
                  if(lit.size()>0){
                      System.debug('-----------success123------------------------');
                  skippushtopicupdate=true;
                  }*/
                }
               /* end :Restricting Incoming calls if the user is already in a call*/
              if(!skippushtopicupdate){
              
              
                boolean recBoolOpt = true;
                if(lststrobj.keyset().size()>0){
                    system.debug('INside:......:');
                    if(lststrobj.containsKey(u.id)){
                        //lststrobj.get(user).Name =currentuser;
                        lststrobj.get(u.id).Calling_From__c =callerfrom;
                        lststrobj.get(u.id).Call_To__c=callerto;
                        lststrobj.get(u.id).Lync_Notifications__c =action;
                        if(u.LyncId__c==callerfrom){
                          lststrobj.get(u.id).External_No__c=callerto;
                        }
                        else if(u.LyncId__c==callerto){
                          lststrobj.get(u.id).External_No__c=callerfrom;
                        }
                        Update lststrobj.get(u.id);
                        recBoolOpt = false;
                    }                  
                }
                if(recBoolOpt){
                    StreamingObject__c topic = new StreamingObject__c();
                    topic.SetupOwnerid=u.id;
                    topic.Name = u.id;
                    topic.Calling_From__c =callerfrom;
                    System.debug('==============call to=================================================================='+callerto);
                    topic.Call_To__c=callerto;
                    topic.Lync_Notifications__c =action;
                    if(u.LyncId__c==callerfrom){
                          topic.External_No__c=callerto;
                        }
                        else if(u.LyncId__c==callerto){
                          topic.External_No__c=callerfrom;
                        }
                    insert topic;
                    system.debug('NewRec:......:'+topic.id);
                }
              }
              //-------------------
             
            // Create call record   
            if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Notified)){            
               insertCallRecord(user,callerfrom,callerto,calltype,action);
            }
            else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Connecting)){            
               insertCallRecord(user,callerfrom,callerto,calltype,action);
            }
            else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Connected)){ 
            
               //This is invoked for transferred calls
               if(calltype==String.valueOf(MttlLyncEnums.LyncCallTypes.Transferred)){ 
               string calType = String.valueOf(MttlLyncEnums.LyncCallTypes.Incoming);
                  insertCallRecord(user,callerfrom,callerto,calType,action);
               }          
               else{                 
                 updateCallRecord(user,callerfrom,callerto,calltype,action,IsTransferred); 
               }                 
                
            }
            else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Disconnected)){ 
               
               //This is invoked for transferred calls
               if(calltype==String.valueOf(MttlLyncEnums.LyncCallTypes.Transferred)){ 
               string calType = String.valueOf(MttlLyncEnums.LyncCallTypes.Incoming);
                  updateCallRecord(user,callerfrom,callerto,calType,action,IsTransferred);
               }            
               else{
               updateCallRecord(user,callerfrom,callerto,calltype,action,IsTransferred);
               }
              
            }
           
           
         }
         
         return 'success';
    }
    
    //Incoming call 
    //create missed call
    private static void insertCallRecord(String user, String calfrm,String calto,String caltype,String action){
       User u=[select Name,id From User where Username=:user];
       system.debug('In insert :'+ caltype +'-----'+user+'-----'+action);
        AllCallsInfo__c alCalInfo=new AllCallsInfo__c(); 
        alCalInfo.Call_From__c=calfrm;
        alCalInfo.Call_Type__c=caltype;
        alCalInfo.User_Agent__c=user;
        alCalInfo.Ownerid=u.id;
        if(calto.contains(';')){
            alCalInfo.Call_To__c='Invalid Number';
        }
        else{
            alCalInfo.Call_To__c=calto;
        }
        if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Connected)){ 
            alCalInfo.Start_of_the_call__c=System.now();
        }
        insert alCalInfo;
        
        
                        
    }
    
     // update missed call to incoming 
    private static void updateCallRecord(String user,String calfrm,String calto,String calType,String action,boolean IsTransferred){
        system.debug('In updateCallRecord...');
        system.debug('...'+calfrm+'....'+calType+'....'+action+'....'+IsTransferred);
        string updateCalType='';
        if(calType == String.valueOf(MttlLyncEnums.LyncCallTypes.Incoming) && action == String.valueOf(MttlLyncEnums.LyncNotifications.Connected))
        {
            updateCalType = String.valueOf(MttlLyncEnums.LyncCallTypes.Notified);
        }
        else if(calType==String.valueOf(MttlLyncEnums.LyncCallTypes.Transferred)) //For transferred calls we need to look for Incoming call type as we are inserting those calls as 'Incoming'
        {
            updateCalType = String.valueOf(MttlLyncEnums.LyncCallTypes.Incoming);
        }
        else
        {
            updateCalType = calType;
        }
        
        AllCallsInfo__c alCalInfo;
        if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Connected))
        {
            alCalInfo=[SELECT Id,Name,Call_From__c,Call_Type__c,User_Agent__c,createddate FROM AllCallsInfo__c  where Call_From__c=:calfrm AND Call_To__c=:calto AND Call_Type__c=:updateCalType AND User_Agent__c=:user ORDER By Createddate DESC limit 1];
                //alCalInfo.Call_Type__c=String.valueOf(MttlLyncEnums.LyncCallTypes.Incoming);
                alCalInfo.Call_Type__c=calType;
                alCalInfo.Start_of_the_call__c=System.now();
        }
        else if(action==String.valueOf(MttlLyncEnums.LyncNotifications.Disconnected))
        {        
              alCalInfo=[SELECT Id,Name,Call_From__c,Call_Type__c,Start_of_the_call__c,User_Agent__c,createddate FROM AllCallsInfo__c  where Call_From__c=:calfrm AND Call_To__c=:calto AND Call_Type__c=:updateCalType AND User_Agent__c=:user ORDER By Createddate DESC limit 1];
              system.debug('****'+alCalInfo+'*******');
              if(IsTransferred){
              alCalInfo.Call_Type__c=String.valueOf(MttlLyncEnums.LyncCallTypes.Transferred);
              }
              else{              
              alCalInfo.Call_Type__c=calType;
              }
              
              system.debug('****'+alCalInfo.Call_From__c+'****'+alCalInfo.Call_To__c+'****'+alCalInfo.Start_of_the_call__c+'**************');
              if(alCalInfo.Start_of_the_call__c!=null){
              alCalInfo.End_of_the_call__c=System.now();
              time difftime = GetElapsedTime(alCalInfo.End_of_the_call__c.time(),alCalInfo.Start_of_the_call__c.time());
              string diff = GetTime(difftime);
              alCalInfo.CallDuration__c= diff;
              }
                
            /* List < StreamingObject__c > delStrObj = [Select Id, createdbyId,Name FROM StreamingObject__c where Name=:user];
               if(delStrObj.size()>0){
                 delete delStrObj;
               }*/
        }
        
        update alCalInfo;
                        
    }
    
    private static string GetTime(Time difftime){
    
        integer hh = integer.ValueOf(difftime.hour());
        integer mm = integer.ValueOf(difftime.minute());
        integer ss = integer.ValueOf(difftime.second());
        integer temphh=0;
        integer tempmm=0;
        if(ss==0){
        tempmm=60-mm;
        }
        else{
        tempmm=60-(mm+1);
        ss=60-ss;
        }
        
        if(mm==0){
        temphh = 24-hh;
        }
        else{
        temphh = 24-(hh+1);
        }
         hh=temphh;
         mm=tempmm;
        
        return hh+'h : '+mm+'m : '+ss+'s';
    }
    
    private static Time GetElapsedTime(Time startTime, Time endTime){
    if(startTime == null || endTime == null)
        return Time.newInstance(0, 0, 0, 0);

    Integer elapsedHours = endTime.hour() - startTime.hour();
    Integer elapsedMinutes = endTime.minute() - startTime.minute();
    Integer elapsedSeconds = endTime.second() - startTime.second();
    Integer elapsedMiliseconds = endTime.millisecond() - startTime.millisecond();

    return Time.newInstance(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMiliseconds);
    }
    
    //Outgoing Call
    
   
  
}