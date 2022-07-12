Public with sharing class MttlGlobalSearchController{
 Public List<contact> conList{get;set;}
 Public List<account> accList{get;set;}
 Public List<Case> caseList{get;set;}
 Public String searchStr{get;set;}
 
   Public MttlGlobalSearchController(){
   }
  
  Public void soslSearchMethod(){
  try{
   conList = New List<contact>();
   accList = New List<account>();
   caseList= New List<Case>();
   if(searchStr.length() > 2){
   String searchStr1 = '*'+searchStr+'*';
   String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name,type,phone,Industry,rating),Contact(name,email,mobilephone,Account.Name,title),Opportunity(name,StageName),Case(casenumber,subject,description,Contact.Name,Account.Name,status,priority)';
   List<List <sObject>> searchList = search.query(searchQuery);
   accList = ((List<Account>)searchList[0]);
   conList  = ((List<contact>)searchList[1]);
   caseList=((List<Case>)searchList[3]);
  
   if(accList.size() == 0 && conList.size() == 0 && caseList.size()==0){
       apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sory, no results returned with matching string..'));
       return;
   }
   }
   else{
   apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
   return;
   }
   }
   catch(exception ex){}
  }
}