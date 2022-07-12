public class New_Tourist_Form_Ctrl {
    
    public String ttfId{get;set;}
    public String touristVal;
    public Boolean displayError{get;set;}
    public Account acc{get;set;}
    public String accFstName{get;set;}
    public String accLstName{get;set;}
    public Tax_Free_Form__c tff_Rec{get;set;}
    
    public New_Tourist_Form_Ctrl(ApexPages.StandardController controller){
        ttfId = ApexPages.currentPage().getParameters().get('ttfId');
        if(ttfId != null){
            tff_Rec = [select Tourist__c from Tax_Free_Form__c WHERE Id = :ttfId];
        }
        acc = new Account();
    }
    
    public PageReference saveAcc(){
        PageReference pageRef;
        try{
            Id touristRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Tourist').getRecordTypeId();
            acc.FirstName = accFstName;
            acc.LastName = accLstName;
            acc.RecordTypeId = touristRecordTypeId;
            insert acc;
            Tax_Free_Form__c ttfLst = [SELECT Id, Tourist__c FROM Tax_Free_Form__c WHERE Id = :ttfId];
            ttfLst.Tourist__c = acc.Id;
            update ttfLst;
            pageRef = new PageReference('/'+ttfId);
        }catch(exception ex){
            ApexPages.addMessages(ex);
        }
        return pageRef;
    }
    
    public PageReference cancelAcc(){
        PageReference pageRef = new PageReference('/'+ttfId);
        return pageRef;
    }
    
}