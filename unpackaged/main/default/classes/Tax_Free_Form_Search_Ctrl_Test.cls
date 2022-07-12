@isTest
public class Tax_Free_Form_Search_Ctrl_Test {
    
    static testMethod void Tax_Free_Form_Search_Ctrl_TestMtd(){
      
        
        List<Fintrax_TFF_Search_Fields__c> ftsf = new List<Fintrax_TFF_Search_Fields__c>();
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Tax Free Form Id',Order__c = 1,Fintrax_Field_API_Name__c = 'taxfreeformId',SF_Field_API_Name__c = 'Name'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Credit Card Number',Order__c = 2,Fintrax_Field_API_Name__c = 'creditcard',SF_Field_API_Name__c = 'Credit_Card_Number__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Email',Order__c = 3,Fintrax_Field_API_Name__c = 'email',SF_Field_API_Name__c = 'Tourist_Email_Address__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Passport Number',Order__c = 4,Fintrax_Field_API_Name__c = 'passportnumber',SF_Field_API_Name__c = 'Tourist_Passport_Number__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Premier Pass Id',Order__c = 5,Fintrax_Field_API_Name__c = 'premierpassid',SF_Field_API_Name__c = 'Tourist_Premier_Pass_Id__c'));
        insert ftsf;
        
        Fintrax_API_Endpoint_URLs__c faEndPoint = new Fintrax_API_Endpoint_URLs__c(Search_EndPoint_URL__c = 'https://apidev.fintrax.com:4856/v2/api/vouchers/crmsearch/',Sync_Endpoint_URL__c = 'https://apidev.fintrax.com:4856/v2/api/vouchers/crmsearch/taxfreeformid/');
        insert faEndPoint;
        
        Fintrax_API_Auth_Details__c authDetails = new Fintrax_API_Auth_Details__c();
        authDetails.audience__c = 'https://apitest.fintrax.com';
        authDetails.Client_Id__c = 'TdzYlWcyJbAieXGM3Jy6gjR15vlmsc0j';
        authDetails.client_secret__c = 'NtV8idcfzWxoOZ_-38zfdWRnmCV9chOLjSPzqbnO3sKaGFPBvvhhj-CUB_EqVxqP';
        authDetails.grant_type__c = 'client_credentials';
        authDetails.End_Point_Url__c = 'https://fintrax-test.auth0.com/oauth/token';
        insert authDetails;
        
        
        Tax_Free_Form__c tffLst = new Tax_Free_Form__c();
        tffLst.Name = '15478952522233';
        insert tffLst;
        
        Id personRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'Test Account';
        acc.LastName = 'Test Account';
        acc.RecordTypeId = personRecId;
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new FintraxWebServiceCalloutMock());
      
          test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(tffLst);
        Tax_Free_Form_Search_Ctrl tffSc = new Tax_Free_Form_Search_Ctrl(sc);
       
        tffSc.searchTerm = '15478952522233';
        tffSc.searchField = 'Tax Free Form Id';
        tffSc.getFieldOptions();
        tffSc.sfSearch();
        tffSc.fintrax_API_Search();
        tffSc.fintrax_API_Sync();
         tffSc.selectedTFFids = '04010111491029581552';
        tffSc.insertDataInSf();
         test.stopTest();
         
         
    
        
      
    }
    static testMethod void Tax_Free_Form_Search_Ctrl_TestMtd2() {
        
        List<Fintrax_TFF_Search_Fields__c> ftsf = new List<Fintrax_TFF_Search_Fields__c>();
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Tax Free Form Id',Order__c = 1,Fintrax_Field_API_Name__c = 'taxfreeformId',SF_Field_API_Name__c = 'Name'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Credit Card Number',Order__c = 2,Fintrax_Field_API_Name__c = 'creditcard',SF_Field_API_Name__c = 'Credit_Card_Number__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Email',Order__c = 3,Fintrax_Field_API_Name__c = 'email',SF_Field_API_Name__c = 'Tourist_Email_Address__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Passport Number',Order__c = 4,Fintrax_Field_API_Name__c = 'passportnumber',SF_Field_API_Name__c = 'Tourist_Passport_Number__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Premier Pass Id',Order__c = 5,Fintrax_Field_API_Name__c = 'premierpassid',SF_Field_API_Name__c = 'Tourist_Premier_Pass_Id__c'));
        insert ftsf;
        
        Fintrax_API_Endpoint_URLs__c faEndPoint = new Fintrax_API_Endpoint_URLs__c(Search_EndPoint_URL__c = 'https://apidev.fintrax.com:4856/v2/api/vouchers/crmsearch/',Sync_Endpoint_URL__c = 'https://apidev.fintrax.com:4856/v2/api/vouchers/crmsearch/taxfreeformid/');
        insert faEndPoint;
        
        Fintrax_API_Auth_Details__c authDetails = new Fintrax_API_Auth_Details__c();
        authDetails.audience__c = 'https://apitest.fintrax.com';
        authDetails.Client_Id__c = 'TdzYlWcyJbAieXGM3Jy6gjR15vlmsc0j';
        authDetails.client_secret__c = 'NtV8idcfzWxoOZ_-38zfdWRnmCV9chOLjSPzqbnO3sKaGFPBvvhhj-CUB_EqVxqP';
        authDetails.grant_type__c = 'client_credentials';
        authDetails.End_Point_Url__c = 'https://fintrax-test.auth0.com/oauth/token';
        insert authDetails;
        
        
       
        
        Id personRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tourist').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'Test Account';
        acc.LastName = 'Test Account';
        acc.RecordTypeId = personRecId;
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        Tax_Free_Form__c tffLst = new Tax_Free_Form__c();
        tffLst.Name = '04010111491029581552';
        tfflst.Tourist__c = acc.id;
        insert tffLst;
        
        Test.setMock(HttpCalloutMock.class, new FintraxWebServiceCalloutMock());
      
          test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(tffLst);
        Tax_Free_Form_Search_Ctrl tffSc = new Tax_Free_Form_Search_Ctrl(sc);
       
        tffSc.searchTerm = '15478952522233';
        tffSc.searchField = 'Tax Free Form Id';
        tffSc.getFieldOptions();
        tffSc.sfSearch();
        tffSc.fintrax_API_Search();
        tffSc.fintrax_API_Sync();
         tffSc.selectedTFFids = '04010111491029581552';
        tffSc.insertDataInSf();
         test.stopTest(); 
    }
    
    static testMethod void Tax_Free_Form_Search_Ctrl_TestMtd3() {
        
        List<Fintrax_TFF_Search_Fields__c> ftsf = new List<Fintrax_TFF_Search_Fields__c>();
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Tax Free Form Id',Order__c = 1,Fintrax_Field_API_Name__c = 'taxfreeformId',SF_Field_API_Name__c = 'Name'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Credit Card Number',Order__c = 2,Fintrax_Field_API_Name__c = 'creditcard',SF_Field_API_Name__c = 'Credit_Card_Number__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Email',Order__c = 3,Fintrax_Field_API_Name__c = 'email',SF_Field_API_Name__c = 'Tourist_Email_Address__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Passport Number',Order__c = 4,Fintrax_Field_API_Name__c = 'passportnumber',SF_Field_API_Name__c = 'Tourist_Passport_Number__c'));
        ftsf.add(new Fintrax_TFF_Search_Fields__c(Name = 'Premier Pass Id',Order__c = 5,Fintrax_Field_API_Name__c = 'premierpassid',SF_Field_API_Name__c = 'Tourist_Premier_Pass_Id__c'));
        insert ftsf;
        
        Fintrax_API_Endpoint_URLs__c faEndPoint = new Fintrax_API_Endpoint_URLs__c(Search_EndPoint_URL__c = 'https://apidev.fintrax.com:4856/v2/api/vouchers/crmsearch/',Sync_Endpoint_URL__c = 'https://apidev.fintrax.com:4856/v2/api/vouchers/crmsearch/taxfreeformid/');
        insert faEndPoint;
        
        Fintrax_API_Auth_Details__c authDetails = new Fintrax_API_Auth_Details__c();
        authDetails.audience__c = 'https://apitest.fintrax.com';
        authDetails.Client_Id__c = 'TdzYlWcyJbAieXGM3Jy6gjR15vlmsc0j';
        authDetails.client_secret__c = 'NtV8idcfzWxoOZ_-38zfdWRnmCV9chOLjSPzqbnO3sKaGFPBvvhhj-CUB_EqVxqP';
        authDetails.grant_type__c = 'client_credentials';
        authDetails.End_Point_Url__c = 'https://fintrax-test.auth0.com/oauth/token';
        insert authDetails;
        
        
       
        
        Id personRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tourist').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'Test Account';
        acc.LastName = 'Test Account';
        acc.RecordTypeId = personRecId;
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        Tax_Free_Form__c tffLst = new Tax_Free_Form__c();
        tffLst.Name = '04010111491029581552';
        tfflst.Tourist__c = acc.id;
        insert tffLst;
        
        Test.setMock(HttpCalloutMock.class, new FintraxWebServiceCalloutMock2());
      
          test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(tffLst);
        Tax_Free_Form_Search_Ctrl tffSc = new Tax_Free_Form_Search_Ctrl(sc);
       
        tffSc.searchTerm = '15478952522233';
        tffSc.searchField = 'Tax Free Form Id';
        tffSc.getFieldOptions();
        tffSc.sfSearch();
        tffSc.fintrax_API_Search();
        tffSc.fintrax_API_Sync();
         tffSc.selectedTFFids = '04010111491029581552';
        tffSc.insertDataInSf();
         test.stopTest(); 
    } 
}