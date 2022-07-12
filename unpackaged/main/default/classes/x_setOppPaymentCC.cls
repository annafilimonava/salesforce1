public class x_setOppPaymentCC {
@InvocableMethod(label='Set Payment Card Charge' description='Set Payment Card Charge')

	public static void setPayCardCharge(list<id> listOppId)
    {
    	for(Id oppId :listOppId)
        {
        	//get Opportunity record using id from process
            Opportunity opp = [SELECT Id, Owning_Country__c, Payment_Card_Charge__c
                                   	FROM Opportunity 
                                   	WHERE Id = :oppId
                                  	LIMIT 1];
                
            //get payment charge id
            List<Payment_Card_Charge__c> lstPCC = new List<Payment_Card_Charge__c>();    
            lstPCC = [ SELECT Id, Owning_Country__c
                       FROM Payment_Card_Charge__c
                       WHERE Owning_Country__c = :opp.Owning_Country__c
                       LIMIT 1];
            
            //check if opportunity payment charge is set - update it
            if (lstPCC.size() > 0){   
                Payment_Card_Charge__c pcc = lstPCC.get(0);
                String paymentCardChargeId = pcc.Id;
                if (opp.Payment_Card_Charge__c != paymentCardChargeId){
                    opp.Payment_Card_Charge__c = paymentCardChargeId;
                    update opp;                    
                }
            }
        }
    }  
}