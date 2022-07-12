global class Tax_Free_Form_Search_Ctrl {
    public list<Tax_Free_Form__c> SFRecordsList { get; set; }
    public string searchField {get;set;}
    public string searchTerm {get;set;}
    public Boolean sfdcSearchTable {get;set;}
    public Boolean fintraxSearchTable {get;set;}
    public integer sfsearchsize {get;set;}
    public integer fintraxsearchsize {get;set;}
    public list<TFFFintraxObj> FinRecordlist {set;get;}
    public string tfid;
    public string selectedTFFids {get;set;}
    Public Tax_Free_Form_Search_Ctrl (ApexPages.StandardController controller){
        sfdcSearchTable = false;
        fintraxSearchTable = false;
        SFRecordsList = new list<Tax_Free_Form__c>();
        FinRecordlist = new list<TFFFintraxObj>();
        fintraxsearchsize = 1;
        Tax_Free_Form__c tff  =  (Tax_Free_Form__c) controller.getRecord();
        tfid= tff.id;
    }
    Map<string, Fintrax_TFF_Search_Fields__c> FintraxTFFSeachfields= Fintrax_TFF_Search_Fields__c.getAll();
    //List<Fintrax_TFF_Search_Fields__c> FintraxTFFSeachfields= [SELECT Order__c, Name FROM Fintrax_TFF_Search_Fields__c order by Order__c];
    public List<SelectOption> getFieldOptions() {
        List<SelectOption> fieldOptions= new List<SelectOption>();
        for(Fintrax_TFF_Search_Fields__c s: [SELECT Order__c, Name FROM Fintrax_TFF_Search_Fields__c order by Order__c]){
            fieldOptions.add(new SelectOption(s.Name,s.Name));
        }
        return fieldOptions;
    }
    Public void sfSearch(){
        System.debug('searchTerm.....'+searchTerm);
        System.debug('searchField.....'+searchField);
        String sfdcQueryString ;
        sfdcQueryString ='select Id,Name,Sales_Amount__c,Refund_Amount__c,Retailer_ID__c,Tourist__r.firstname,Tourist__r.name,Tourist_Passport_Number__c,'+
            'Tourist_Premier_Pass_Id__c,Tourist_First_Name__c,Tourist_Last_Name__c,Latest_Payment_Status__c,Tourist_Email_Address__c,'+
            ' Credit_Card_Number__c,Account_shop__r.Name,Purchase_Date__c from Tax_Free_Form__c Where Id!=null ';
        if(!String.isBlank(searchTerm))  
            sfdcQueryString +='And '+FintraxTFFSeachfields.get(searchField).SF_Field_API_Name__c+' like \'%' + searchTerm + '%\'';    
        System.debug('sfdcQueryString.....'+sfdcQueryString);
        SFRecordsList = database.Query(sfdcQueryString); 
        sfsearchsize = SFRecordsList.size();
        
        System.debug('SFRecordslist size.....'+sfsearchsize );
        if(SFRecordsList.size() > 0){
            sfdcSearchTable = true;
            
            System.debug('sfdcSearchTable.....'+sfdcSearchTable);
        }else{
            sfdcSearchTable = false;
            
        }
    }
    public void fintrax_API_Search() {
        Fintrax_API_Endpoint_URLs__c FAE = Fintrax_API_Endpoint_URLs__c.getOrgDefaults();
        String EndpointURL = FAE.Search_EndPoint_URL__c+FintraxTFFSeachfields.get(searchField).Fintrax_Field_API_Name__c+'/'+searchTerm+'/';
        System.debug('@@@@@@EndpointURL@@@@@'+EndpointURL);
        list<TFFFintraxObj> TFFsearchresultlist = new list<TFFFintraxObj>();
        FinRecordlist = new list<TFFFintraxObj>();
        HttpResponse res = new HttpResponse();
        res  = FintraxWebServiceHelper.fetchHttpResponse(EndpointURL);
        System.debug('@@@@@resTest'+res);
        if (res!=null) {
            
            TFFsearchresultlist = TFFFintraxObj.jsonparse(res.getBody());
            system.debug('TFFsearchresultlist---'+TFFsearchresultlist);
            system.debug('TFFsearchresultlist--size---'+TFFsearchresultlist.size());
            if(TFFsearchresultlist.size()<=20 && TFFsearchresultlist.size()>0 ){
                FinRecordlist.addall(TFFsearchresultlist);
                fintraxsearchsize = FinRecordlist.size(); // to hold fintrax serch size , can remove after api connection 
                fintraxSearchTable = true;
            }
            else fintraxSearchTable = false;
            fintraxsearchsize = TFFsearchresultlist.size();
        }
        
        else {
            fintraxsearchsize = TFFsearchresultlist.size();
            fintraxSearchTable = false;
        }
    }
    
    public   pagereference  fintrax_API_Sync() {
        Tax_Free_Form__c TFF = new Tax_Free_Form__c(); 
        string Tffid = [select id,name from Tax_Free_Form__c where id =:tfid].name;
        Fintrax_API_Endpoint_URLs__c FAE = Fintrax_API_Endpoint_URLs__c.getOrgDefaults();
        String EndpointURL = FAE.Sync_Endpoint_URL__c+TFFid+'/';
        list<TFFFintraxObj> TFFsyncrec = new list<TFFFintraxObj>();
        HttpResponse res = new HttpResponse();
        res  = FintraxWebServiceHelper.fetchHttpResponse(EndpointURL);
        if (res !=null) {
            
            TFFsyncrec =TFFFintraxObj.jsonparse(res.getBody());
            if(TFFsyncrec.size()>0){
                
                map<string,account> accountmap = new map<string,account>();
                account insertTac = new account();
                Tax_Free_Form__c tffrecord = new Tax_Free_Form__c(); 
                string Recordtypeid = [select Id from RecordType where (Name='Tourist') and (SobjectType='Account')].id;
                
                for(account a:[select id,Account_ID__c,PersonEmail from account where Account_ID__c =: TFFsyncrec[0].RetailerId   Or PersonEmail!=null]){
                    if(a.Account_ID__c!=null) accountmap.put(a.Account_ID__c,a);
                    
                }
                tffrecord = [select id ,Name,Tourist__c from Tax_Free_Form__c where Name = : TFFid];
                Schema.SObjectField ExtID_Field = Tax_Free_Form__c.Fields.ExternalId_Tax_Free_Form_Id__c;
                Schema.SObjectField ExtEmail_Field = account.Fields.Person_Email_External__c;
                try{
                    if(tffrecord.Tourist__c==null && ((String.isNotBlank(TFFsyncrec[0].TouristFirstName))||
                                                      (String.isNotBlank(TFFsyncrec[0].TouristLastName) )) ){
                                                          
                                                          insertTac.firstname =  TFFsyncrec[0].TouristFirstName;
                                                          //Tac.lastname = 'last';
                                                          insertTac.lastname =  ((TFFsyncrec[0].TouristLastName!=''&&TFFsyncrec[0].TouristLastName!=null)?TFFsyncrec[0].TouristLastName:TFFsyncrec[0].TouristFirstName);
                                                          insertTac.PersonMailingStreet = TFFsyncrec[0].TouristAddress;
                                                          insertTac.PersonEmail = TFFsyncrec[0].TouristEmailAddress;
                                                          insertTac.Person_Email_External__c = TFFsyncrec[0].TouristEmailAddress;
                                                          insertTac.PersonBirthdate = (TFFsyncrec[0].TouristDateOfBirth!=null?date.valueof(TFFsyncrec[0].TouristDateOfBirth):null);
                                                          insertTac.PersonMobilePhone = TFFsyncrec[0].TouristPhoneNumber;
                                                          insertTac.PersonMailingPostalCode = TFFsyncrec[0].TouristPostalCode;
                                                          insertTac.Owning_Country__c = TFFsyncrec[0].CountryOfPurchase ;
                                                          insertTac.RecordTypeId = Recordtypeid;
                                                          insertTac.Passport_Number__c = TFFsyncrec[0].TouristPassportNumber ;
                                                          insertTac.Premier_Pass_ID__c = TFFsyncrec[0].TouristPremierPassId ;
                                                          insertTac.External_Passport_Number__c = TFFsyncrec[0].TouristPassportNumber ;
                                                          insertTac.External_Premier_Pass_ID__c = TFFsyncrec[0].TouristPremierPassId ;
                                                          insert insertTac;
                                                      }else if((String.isNotBlank(TFFsyncrec[0].TouristFirstName))||
                                                               (String.isNotBlank(TFFsyncrec[0].TouristLastName) )){
                                                                   account updateTac = new account();
                                                                   updateTac.id = tffrecord.Tourist__c;
                                                                   updateTac.firstname =  TFFsyncrec[0].TouristFirstName;
                                                                   //Tac.lastname = 'last';
                                                                   updateTac.lastname =  ((TFFsyncrec[0].TouristLastName!=''&&TFFsyncrec[0].TouristLastName!=null)?TFFsyncrec[0].TouristLastName:TFFsyncrec[0].TouristFirstName);
                                                                   updateTac.PersonMailingStreet = TFFsyncrec[0].TouristAddress;
                                                                   updateTac.PersonEmail = TFFsyncrec[0].TouristEmailAddress;
                                                                   updateTac.Person_Email_External__c = TFFsyncrec[0].TouristEmailAddress;
                                                                   updateTac.PersonBirthdate = (TFFsyncrec[0].TouristDateOfBirth!=null?date.valueof(TFFsyncrec[0].TouristDateOfBirth):null);
                                                                   updateTac.PersonMobilePhone = TFFsyncrec[0].TouristPhoneNumber;
                                                                   updateTac.PersonMailingPostalCode = TFFsyncrec[0].TouristPostalCode;
                                                                   updateTac.Owning_Country__c = TFFsyncrec[0].CountryOfPurchase ;
                                                                   updateTac.RecordTypeId = Recordtypeid;
                                                                   updateTac.Passport_Number__c = TFFsyncrec[0].TouristPassportNumber ;
                                                                   updateTac.Premier_Pass_ID__c = TFFsyncrec[0].TouristPremierPassId ;
                                                                   updateTac.External_Passport_Number__c = TFFsyncrec[0].TouristPassportNumber ;
                                                                   updateTac.External_Premier_Pass_ID__c = TFFsyncrec[0].TouristPremierPassId ; 
                                                                   update updateTac;
                                                               }
                    
                    
                    tff.Name = TFFsyncrec[0].TaxFreeFormId;
                    tff.ExternalId_Tax_Free_Form_Id__c = TFFsyncrec[0].TaxFreeFormId;
                    tff.Latest_Payment_Status__c = TFFsyncrec[0].LatestPaymentStatus;
                    tff.Retailer_Id__c = TFFsyncrec[0].RetailerId;
                    if(accountmap.containsKey(TFFsyncrec[0].RetailerId))tff.Account_Shop__c = accountmap.get(TFFsyncrec[0].RetailerId).id;
                    else tff.Account_Shop__c = Label.DefaultRetailerAccount;
                    tff.Vendor_Number__c = TFFsyncrec[0].VendorNumber ;
                    tff.Country_Of_Purchase__c = TFFsyncrec[0].CountryOfPurchase ;
                    tff.Sales_Amount__c = (TFFsyncrec[0].SalesAmount!=null?decimal.valueof(TFFsyncrec[0].SalesAmount):0);
                    tff.Sales_Currency__c = TFFsyncrec[0].SalesCurrency;
                    tff.Refund_Amount__c = (TFFsyncrec[0].RefundAmount!=null?decimal.valueof(TFFsyncrec[0].RefundAmount):0);
                    tff.Refund_Currency__c = TFFsyncrec[0].RefundCurrency;
                    
                    tff.P2_Entry_Date__c = (TFFsyncrec[0].P2EntryDate!=null?date.valueOf(TFFsyncrec[0].P2EntryDate):Null);
                    tff.Qualified_Date__c = (TFFsyncrec[0].QualifiedDate!=null?date.valueOf(TFFsyncrec[0].QualifiedDate):Null);
                    tff.Purchase_Date__c = (TFFsyncrec[0].PurchaseDate!=null?date.valueOf(TFFsyncrec[0].PurchaseDate):Null);
                    tff.Customs_Date_Stamp__c = (TFFsyncrec[0].CustomsDateStamp!=null?date.valueOf(TFFsyncrec[0].CustomsDateStamp):Null);
                    tff.Refund_Date__c = (TFFsyncrec[0].RefundDate!=null?date.valueOf(TFFsyncrec[0].RefundDate):Null);
                    tff.Refund_Method__c = TFFsyncrec[0].RefundMethod;
                    tff.Cheque_Number__c = TFFsyncrec[0].ChequeNumber;
                    tff.Masked_Card_Number__c = TFFsyncrec[0].MaskedCardNumber;
                    tff.Credit_Card_Number__c = TFFsyncrec[0].MaskedCardNumber;
                    tff.Alipay_Id__c = TFFsyncrec[0].AlipayId;
                    tff.Bank_Account_Number__c = TFFsyncrec[0].BankAccountNumber;
                    tff.Exit_Point__c = (TFFsyncrec[0].ExitPoint!=null?integer.valueof(TFFsyncrec[0].ExitPoint):NULL);
                    tff.Priority__c = TFFsyncrec[0].Priority;
                    tff.Tourist_Premier_Pass_Id__c = TFFsyncrec[0].TouristPremierPassId;
                    tff.Tourist_Passport_Number__c = TFFsyncrec[0].TouristPassportNumber;
                    tff.Tourist_Passport_Issuing_Country__c =  TFFsyncrec[0].TouristPassportIssuingCountry;
                    tff.Tourist_Email_Address__c = TFFsyncrec[0].TouristEmailAddress;
                    tff.Tourist_Final_Destination__c = TFFsyncrec[0].TouristFinalDestination;
                    tff.Last_Sync__c = system.now();
                    if(tffrecord.Tourist__c!=null) 
                        tff.Tourist__c = tffrecord.Tourist__c;
                    else  tff.Tourist__c = insertTac.id;
                    
                    
                    database.upsert(tff,ExtID_Field,false);}
                catch(exception ex){
                    system.debug('Exception happened while updating  data in salesforce: ' + ex);
                    Debug_Log_Track__c dl = new Debug_Log_Track__c();
                    dl.Apex_class_name__c = 'Tax_Free_Form_Search_Ctrl';
                    dl.LineNumber__c = ex.getLineNumber();
                    dl.Message__c = ex.getMessage();
                    dl.StackTrace__c = ex.getStackTraceString();
                    dl.Type__c = ex.getTypeName();
                    insert dl;
                    
                }
                
            }
            
        }
        PageReference TffPage = new ApexPages.StandardController(tff).view();
        TffPage.setRedirect(true);
        return TffPage;
    }
    Public void insertDataInSf(){
        Schema.SObjectField ExtID_Field = Tax_Free_Form__c.Fields.ExternalId_Tax_Free_Form_Id__c;
        Schema.SObjectField ExtEmail_Field = account.Fields.Person_Email_External__c;
        Schema.SObjectField ExtPassport_Field = account.Fields.External_Passport_Number__c;
        Schema.SObjectField ExtPremier_Pass_Field = account.Fields.External_Premier_Pass_ID__c;
        string Recordtypeid = [select Id from RecordType where (Name='Tourist') and (SobjectType='Account')].id;
        list<Tax_Free_Form__c> upsertTFFlist = new list<Tax_Free_Form__c>();
        Map<string ,account> TaccinsertEmail_map = new Map<string ,account>();
        Map<string ,account> TaccinsertPassport_map = new Map<string ,account>();
        Map<string ,account> Taccinsertpremierpass_map = new Map<string ,account>();
        Map<string ,account> Taccinsertname_map = new Map<string ,account>();
        map<String,account> Taccmap = new map<String,account>();
        map<string,account> accountmap = new map<string,account>();
        set<string> setRetailerIds = new set<string>();
        for(string tfid:selectedTFFids.split(',')){
            for(TFFFintraxObj tfobj:FinRecordlist){
                if(tfobj.RetailerId != null)setRetailerIds.add(tfobj.RetailerId);
            }
        }
        for(account a:[select id,Account_ID__c,PersonEmail from account where Account_ID__c IN: setRetailerIds Or PersonEmail!=null]){
            if(a.Account_ID__c!=null) accountmap.put(a.Account_ID__c,a);
            if(a.PersonEmail != null) Taccmap.put(a.PersonEmail,a);
        }
        
        system.debug('---Taccmap--'+Taccmap);
        for(string tfid:selectedTFFids.split(',')){
            for(TFFFintraxObj tfobj:FinRecordlist){
                if(tfid==tfobj.TaxFreeFormId){
                    // if(!Taccmap.containsKey(tfobj.TouristEmailAddress)){
                    if((String.isNotBlank(tfobj.TouristFirstName))||
                       (String.isNotBlank(tfobj.TouristLastName) )){
                           account Tac = new account();
                           Tac.firstname =  tfobj.TouristFirstName;
                           //Tac.lastname = 'last';
                           Tac.lastname =  ((tfobj.TouristLastName!=''&&tfobj.TouristLastName!=null)?tfobj.TouristLastName:tfobj.TouristFirstName);
                           Tac.PersonMailingStreet = tfobj.TouristAddress;
                           tac.PersonEmail = tfobj.TouristEmailAddress;
                           Tac.Person_Email_External__c = tfobj.TouristEmailAddress;
                           tac.PersonBirthdate = (tfobj.TouristDateOfBirth!=null?date.valueof(tfobj.TouristDateOfBirth):null);
                           tac.PersonMobilePhone = tfobj.TouristPhoneNumber;
                           tac.PersonMailingPostalCode = tfobj.TouristPostalCode;
                           tac.Owning_Country__c = tfobj.CountryOfPurchase ;
                           tac.Passport_Number__c = tfobj.TouristPassportNumber ;
                           tac.Premier_Pass_ID__c = tfobj.TouristPremierPassId ;
                           tac.External_Passport_Number__c = tfobj.TouristPassportNumber ;
                           tac.External_Premier_Pass_ID__c = tfobj.TouristPremierPassId ;
                           tac.RecordTypeId = Recordtypeid;
                           system.debug('----tacc---'+tac);
                           if(tac.PersonEmail!=null&&tac.PersonEmail!= '')
                               TaccinsertEmail_map.put(tac.PersonEmail,tac);
                           else if(tac.Passport_Number__c!=null&&tac.Passport_Number__c!='')
                               TaccinsertPassport_map.put(tac.Passport_Number__c,tac);
                           else if( tac.Premier_Pass_ID__c!=null &&  tac.Premier_Pass_ID__c!='') 
                               Taccinsertpremierpass_map.put(tac.Premier_Pass_ID__c,tac);
                           else if(tac.LastName !=null && tac.LastName!='' )
                               Taccinsertname_map.put(tac.LastName+tac.FirstName,tac);
                       }
                    
                    
                    Tax_Free_Form__c TFF = new Tax_Free_Form__c();
                    tff.Name = tfobj.TaxFreeFormId;
                    tff.ExternalId_Tax_Free_Form_Id__c = tfobj.TaxFreeFormId;
                    tff.Latest_Payment_Status__c = tfobj.LatestPaymentStatus;
                    tff.Retailer_Id__c = tfobj.RetailerId;
                    if(accountmap.containsKey(tfobj.RetailerId))tff.Account_Shop__c = accountmap.get(tfobj.RetailerId).id;
                    else tff.Account_Shop__c = Label.DefaultRetailerAccount;
                    tff.Vendor_Number__c = tfobj.VendorNumber ;
                    tff.Country_Of_Purchase__c = tfobj.CountryOfPurchase ;
                    tff.Sales_Amount__c = (tfobj.SalesAmount!=null?decimal.valueof(tfobj.SalesAmount):0);
                    tff.Sales_Currency__c = tfobj.SalesCurrency;
                    tff.Refund_Amount__c = (tfobj.RefundAmount!=null?decimal.valueof(tfobj.RefundAmount):0);
                    tff.Refund_Currency__c = tfobj.RefundCurrency;
                    
                    tff.P2_Entry_Date__c = (tfobj.P2EntryDate!=null?date.valueOf(tfobj.P2EntryDate):Null);
                    tff.Qualified_Date__c = (tfobj.QualifiedDate!=null?date.valueOf(tfobj.QualifiedDate):Null);
                    tff.Purchase_Date__c = (tfobj.PurchaseDate!=null?date.valueOf(tfobj.PurchaseDate):Null);
                    tff.Customs_Date_Stamp__c = (tfobj.CustomsDateStamp!=null?date.valueOf(tfobj.CustomsDateStamp):Null);
                    tff.Refund_Date__c = (tfobj.RefundDate!=null?date.valueOf(tfobj.RefundDate):Null);
                    tff.Refund_Method__c = tfobj.RefundMethod;
                    tff.Cheque_Number__c = tfobj.ChequeNumber;
                    tff.Masked_Card_Number__c = tfobj.MaskedCardNumber;
                    tff.Credit_Card_Number__c = tfobj.MaskedCardNumber;
                    tff.Alipay_Id__c = tfobj.AlipayId;
                    tff.Bank_Account_Number__c = tfobj.BankAccountNumber;
                    tff.Exit_Point__c = (tfobj.ExitPoint!=null?integer.valueof(tfobj.ExitPoint):NULL);
                    tff.Priority__c = tfobj.Priority;
                    tff.Tourist_First_Name__c = tfobj.TouristFirstName;
                    tff.Tourist_Last_Name__c = ((tfobj.TouristLastName!=''&&tfobj.TouristLastName!=null)?tfobj.TouristLastName:tfobj.TouristFirstName);
                    tff.Tourist_Premier_Pass_Id__c = tfobj.TouristPremierPassId;
                    tff.Tourist_Passport_Number__c = tfobj.TouristPassportNumber;
                    tff.Tourist_Passport_Issuing_Country__c =  tfobj.TouristPassportIssuingCountry;
                    tff.Tourist_Email_Address__c = tfobj.TouristEmailAddress;
                    tff.Tourist_Final_Destination__c = tfobj.TouristFinalDestination;
                    tff.Last_Sync__c = system.now();
                    upsertTFFlist.add(tff);
                    
                    
                }
            }
            
        }
        system.debug('---TaccinsertEmail_map--'+TaccinsertEmail_map);
        system.debug('---TaccinsertPassport_map--'+TaccinsertPassport_map);
        system.debug('---Taccinsertpremierpass_map--'+Taccinsertpremierpass_map);
        system.debug('---Taccinsertname_map'+Taccinsertname_map);
        try{
            if(!TaccinsertEmail_map.isEmpty()){
                system.debug('---TaccinsertEmail_map.isEmpty()--'+TaccinsertEmail_map.isEmpty());
                database.upsert(TaccinsertEmail_map.values(),ExtEmail_Field,false);
            }
            
            else if(!TaccinsertPassport_map.isEmpty()){
                system.debug('---TaccinsertPassport_map.isEmpty()--'+TaccinsertPassport_map.isEmpty());
                database.upsert(TaccinsertPassport_map.values(),ExtPassport_Field,false);
            }
            
            else if(!Taccinsertpremierpass_map.isEmpty()){
                system.debug('---Taccinsertpremierpass_map.isEmpty()--'+Taccinsertpremierpass_map.isEmpty());
                database.upsert(Taccinsertpremierpass_map.values(),ExtPremier_Pass_Field,false);
            }
            else if(!Taccinsertname_map.isEmpty()){
                system.debug('---Taccinsertname_map.isEmpty()--'+Taccinsertname_map.isEmpty());
                database.insert(Taccinsertname_map.values(),false);
            }
            
            for(Tax_Free_Form__c tf :upsertTFFlist){
                if(tf.Tourist_Email_Address__c!=null&&tf.Tourist_Email_Address__c!=''&&TaccinsertEmail_map.containsKey(tf.Tourist_Email_Address__c))
                    tf.Tourist__c = TaccinsertEmail_map.get(tf.Tourist_Email_Address__c).id;
                else if(tf.Tourist_Passport_Number__c!=null&&tf.Tourist_Passport_Number__c!=''&&TaccinsertPassport_map.containsKey(tf.Tourist_Passport_Number__c))
                    tf.Tourist__c = TaccinsertPassport_map.get(tf.Tourist_Passport_Number__c).id;
                else if(tf.Tourist_Premier_Pass_Id__c!=null&&tf.Tourist_Premier_Pass_Id__c!=''&&Taccinsertpremierpass_map.containsKey(tf.Tourist_Premier_Pass_Id__c))
                    tf.Tourist__c = Taccinsertpremierpass_map.get(tf.Tourist_Premier_Pass_Id__c).id;
                else if(tf.Tourist_Last_Name__c !=null && tf.Tourist_Last_Name__c!='' && Taccinsertname_map.containsKey(tf.Tourist_Last_Name__c+tf.Tourist_First_Name__c)){
                    //system.debug('enter in name');
                    tf.Tourist__c = Taccinsertname_map.get(tf.Tourist_Last_Name__c+tf.Tourist_First_Name__c).id;
                }
            }
            system.debug('upsertTFFlist'+upsertTFFlist);
            database.upsert(upsertTFFlist,ExtID_Field,false);
            sfSearch();   
            
        }
        Catch(exception ex){
            system.debug('Exception happened while inserting data in salesforce: ' + ex);
            Debug_Log_Track__c dl = new Debug_Log_Track__c();
            dl.Apex_class_name__c = 'Tax_Free_Form_Search_Ctrl';
            dl.LineNumber__c = ex.getLineNumber();
            dl.Message__c = ex.getMessage();
            dl.StackTrace__c = ex.getStackTraceString();
            dl.Type__c = ex.getTypeName();
            insert dl;
        }
        
    }
    
    
}