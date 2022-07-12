@isTest
global class FintraxWebServiceCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
          HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
         if( request.getEndpoint().equals('https://fintrax-test.auth0.com/oauth/token')){
           
        response.setBody('{"access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik1EQkNORUV6TkRRM1F6WTRNRFUzTkRoRE1UbENPVEZHT0RkRk1FTkROVVpCTVRkR09FRkZOZyJ9.eyJpc3MiOiJodHRwczovL2ZpbnRyYXgtdGVzdC5hdXRoMC5jb20vIiwic3ViIjoiVGR6WWxXY3lKYkFpZVhHTTNKeTZnalIxNXZsbXNjMGpAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vYXBpdGVzdC5maW50cmF4LmNvbSIsImV4cCI6MTUwNjY2MjA5MCwiaWF0IjoxNTA2NTc1NjkwLCJzY29wZSI6InJlYWQ6dm91Y2hlcnMtc2VhcmNoIn0.j19Clo9Xfs7QDpwcxb-aJ5lsezRAsQFRC-fr3uULLVF8bOSCOsG3t_JzxHtKT8XRQS3Os-B5sw9wucrUs7RfKSCjwMes56pa-5RERSDmAFd7hUf20eZRsORojHnamBP9dpHvy11yr02kdGTLJvD2kt1IRODJcNB7y7_EEJCbpg-D7JaGjCSaaNOg7DlMijEofeoDlhsSOHgdIy0tNe5mh_xF9csG0q7Dbm-zE6ZBRkxkYgAlD-_oonmZfrgoBSRVqTAAK-59FN8OYqKOoSpUy0fsynS10wIrdCfFzeQrLpH2ruHt1lvnmncv0QTGMJxevwdJNLcDBI7iZiha3JZX-Q","expires_in": 86400,"scope": "read:vouchers-search","token_type": "Bearer"}');
        response.setStatusCode(200);
       
         }
        else { 
        response.setBody('[{"LatestPaymentStatus": "Issued", "TaxFreeFormId": "04010111491029581552", "RetailerId": "111491", "VendorNumber": "111491", "CountryOfPurchase": "Austria","SalesAmount": 200, "SalesCurrency": "EUR","RefundAmount": null,"RefundCurrency": "EUR", "ErrorCodes": ["" ],'+
       '"P2EntryDate": null, "QualifiedDate": null, "PurchaseDate": "2017-06-29T00:00:00", "CustomsDateStamp": null, "RefundDate": "2017-06-29T16:00:41", "RefundMethod": "CAD-Cheque", "ChequeNumber": "", "MaskedCardNumber": null,"AlipayId": null,"BankAccountNumber": null,'+
       '"ExitPoint": null, "Priority": null, "TouristPremierPassId": "888012317185850", "TouristPassportNumber": "IRL2017ABC08", "TouristPassportIssuingCountry": "", "TouristLastName": "Jones",'+
       '"TouristFirstName": "Thomes", "TouristEmailAddress": "aa1531@tester.com","TouristDateOfBirth": "1960-11-02T00:00:00", "TouristFinalDestination": "SAUDI ARABIA", "TouristPhoneNumber": "", "TouristAddress": "HhhhtEnd Citysaudi arabia","TouristPostalCode": ""}]'
                        );}
        response.setStatusCode(200);
        return response;  
       
    }
}