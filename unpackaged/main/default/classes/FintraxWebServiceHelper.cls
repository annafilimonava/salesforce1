public class FintraxWebServiceHelper {
 
  public static string getAccessToken (){
      list<Debug_Log_Track__c> debuglist = new list<Debug_Log_Track__c>();
        Fintrax_API_Auth_Details__c fad = Fintrax_API_Auth_Details__c.getOrgDefaults();
        String requestBody =  '{"client_id":"'+fad.Client_Id__c+'",'
            +'"client_secret":"'+fad.client_secret__C+'",'
            +'"audience":"'+fad.audience__C+'",'          
            +'"grant_type":"'+fad.grant_type__C+'"}';
        String endPointURL = fad.End_Point_Url__c;  
          
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setEndpoint(endPointURL);
        if(requestBody != null){
          req.setBody(requestBody);
        }
        req.setTimeout(120000);

        try {
            res = http.send(req);
            System.debug('res...test'+res);
        } catch (exception ex) {
            system.debug('Exception happened while Fetching the data from Fintrax: ' + ex);
            Debug_Log_Track__c dl = new Debug_Log_Track__c();
            dl.Apex_class_name__c = 'FintraxWebServiceHelper';
            dl.LineNumber__c = ex.getLineNumber();
            dl.Message__c = ex.getMessage();
            dl.StackTrace__c = ex.getStackTraceString();
            dl.Type__c = ex.getTypeName();
            insert dl;
        }
        system.debug('res.getBody(): ' + res.getBody());
        system.debug('res.getStatusCode(): ' + res.getStatusCode());
        if (res.getStatusCode() == 200) {
            System.debug('@@@res@@'+res);
            map<string, object> mapresult = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            System.debug('@@@mapresult@@'+mapresult);
            System.debug('@@@access token@@'+mapresult.get('access_token'));
         return string.valueof(mapresult.get('access_token')) ; 
        }
      else{
          Debug_Log_Track__c dl = new Debug_Log_Track__c();
          dl.Apex_class_name__c = 'FintraxWebServiceHelper';
          dl.Response__c = res.getBody();
          dl.Response_Code__c = res.getStatusCode();
          dl.Request__c = string.valueof(req);
           insert dl;
          
         return null; 
      }
            
        }
        
    public static Httpresponse fetchHttpResponse(String EndpointURL){
        Fintrax_API_Auth_Details__c fad = Fintrax_API_Auth_Details__c.getOrgDefaults();
        string access_token = FintraxWebServiceHelper.getAccessToken();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        system.debug('EndpointURL----'+EndpointURL);
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'bearer '+access_token);
        //req.setHeader('Ocp-Apim-Subscription-Key', fad.ocp_apim_subscription_key__c);
        req.setMethod('GET');
        req.setEndpoint(EndpointURL);
        req.setTimeout(120000);

        try {
            res = http.send(req);
        } catch (exception ex) {
            system.debug('Exception happened while Fetching the data from Fintrax: ' + ex);
             Debug_Log_Track__c dl = new Debug_Log_Track__c();
            dl.Apex_class_name__c = 'FintraxWebServiceHelper';
            dl.LineNumber__c = ex.getLineNumber();
            dl.Message__c = ex.getMessage();
            dl.StackTrace__c = ex.getStackTraceString();
            dl.Type__c = ex.getTypeName();
            insert dl;
        }
        system.debug('res.getBody(): ' + res.getBody());
        system.debug('res.getStatusCode(): ' + res.getStatusCode());
        if (res.getStatusCode() == 200) {
            System.debug('@@@res@@'+res);
         return res ; 
        }
        else{
            Debug_Log_Track__c dl = new Debug_Log_Track__c();
          dl.Apex_class_name__c = 'FintraxWebServiceHelper';
          dl.Response__c = res.getBody();
          dl.Response_Code__c = res.getStatusCode();
          dl.Request__c = string.valueof(req);
           insert dl;
            return null;
        } 
        }
}