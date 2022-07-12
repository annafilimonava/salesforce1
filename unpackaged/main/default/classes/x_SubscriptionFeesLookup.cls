/**
 * @description       : 
 * @author            : Mickey K
 * @group             : 
 * @last modified on  : 04-27-2022
 * @last modified by  : Florin Galea
**/

public class x_SubscriptionFeesLookup {

    
    public static final String productCANDC = 'CLICK AND COLLECT';
    public static final String productOMS = 'OMS';
    public static final String productSMARTPOS = 'SMART POS';
    public static final String productDIGITALCOMMERCE = 'DIGITAL COMMERCE';
    public static final String productSUPPORT = 'SUPPORT';
    public static final String productGMV = 'GMV';
    public static final String EURO = 'EUR';
    public static final Decimal sPOSMaxLimit = 830;
    public static final Decimal gmvMaxLimit = 175000000;

    public static Boolean CLICKANDCOLLECT = FALSE;
    public static Decimal dClickAndCollect = 0.0;
    public static Boolean OMS = FALSE;
    public static Decimal dOMS = 0.0;
    public static Boolean SMARTPOS = FALSE;
    public static Decimal dSmartPOS = 0.0;    
    public static Boolean DIGITALCOMMERCE = FALSE;
    public static Decimal dDigitalCommerce = 0.0;
    public static Decimal dGMV = 0.0;
    public static Decimal dPackageTotal = 0.0;
    public static Decimal dPCIProxyTotal = 0.0;
    public static Decimal dPaymentGatewayTotal = 0.0;

    public static Decimal dSupport = 0.0;

    
    @InvocableMethod(label='Subscription Fees Lookup' description='Subscription Fees Lookup')
    public static void setTotals(list<id> listofSubFeesId)
    {

        // List of Subscription Fees to update
        List<Subscription_Fees__c> lstSubFeeRecords = new List<Subscription_Fees__c>();
        // List of Add Ons to update
        List<Add_On__c> lstAddOnRecords = new List<Add_On__c>();
        
        //get Subscription Fee record using the Add_On__c record id
        List<Subscription_Fees__c> lstSubFees = [SELECT Id, Click_Collect__c, Digital_Commerce__c, Smart_POS__c, OMS__c, Support_Level__c, Predicted_GMV_Value__c, Predicted_GMV__c, PCI_Proxy__c, Payment_Gateway__c
                                   		FROM Subscription_Fees__c 
                                   		WHERE Id In:listofSubFeesId];

        //get Add_On__c record using id from Subscription_Fees__c
        Add_On__c addOn = [SELECT Name, Id, CurrencyIsoCode, Subscription_Fees__c, Number_Of_Associates__c, SPOS_Price__c, 
                                     Per_DC_Implementation__c, Per_Website__c, Per_Independently_Managed_Brand__c, PCI_Proxy_Total_Cost__c, Payment_Gateway_Total_Cost__c,
                           			 Additional_Domain_Name__c,	Webfront__c, Distance_Selling_Checkout__c, StoreFront_APIs_For_Other_Channels__c //Digital_Commerce_Options__c,
                           FROM Add_On__c 
                           WHERE Subscription_Fees__c = :lstSubFees[0].Id
                           LIMIT 1];


        //lookup Software Subscription Matrix from the custom metadata type 'Software Subscription Lookup'
        List<Software_Subscription_Lookup__mdt> lstSSLookup = [SELECT Id, Product__c, Options__c, Min__c, Max__c, Rate__c, Amount__c
                                                      			FROM Software_Subscription_Lookup__mdt];

        //get the currency conversion rate from user entered currency
        Decimal conversionrate = [SELECT Id, IsoCode, ConversionRate FROM CurrencyType WHERE IsoCode = :addOn.CurrencyIsoCode LIMIT 1].ConversionRate;
        
        //get the Subscription_Fees__c record that was passed from the process builder
        for(Subscription_Fees__c subFees :lstSubFees){
            
	        //click and collect check
            if (subFees.Click_Collect__c == true){
                    CLICKANDCOLLECT = TRUE;
                    //get click and collect amount
                    dClickAndCollect = clickAndCollect(lstSSLookup, subFees, addOn, conversionrate);
                    //update total C&C price
                    addOn.Click_Collect_Total_Price__c = dClickAndCollect;
            }
    
            //OMS check
            if (subFees.OMS__c == true){
                    OMS = TRUE;
                    //get click and collect amount
                    dOMS = oms(lstSSLookup, subFees, addOn, conversionrate);
                    //update total oms price
                    addOn.OMS_Total_Price__c = dOMS;
            }
            
            //smart POS check
            if (subFees.Smart_POS__c == true){
                    SMARTPOS = TRUE;
                    //get smart POS amount
                    dSmartPOS = smartPOS(lstSSLookup, subFees, addOn, conversionrate);
                    //update total Smart pos proce
                    addOn.Smart_POS_Total_Price__c = dSmartPOS;
            }
            
            //digital commerce check
            if (subFees.Digital_Commerce__c == true){
                    DIGITALCOMMERCE = TRUE;
                    //get digital commerce amount
                    dDigitalCommerce = digitalCommerce(lstSSLookup, subFees, addOn, conversionrate);
                    //update total digital commerce proce
                    addOn.Digital_Commerce_Option_Price__c = dDigitalCommerce;
            }
            
            //calcuate support - add packages to bundle to calculate support rpice
            Decimal bundle = dClickAndCollect + dOMS + dSmartPOS + dDigitalCommerce;
	        dSupport = support(lstSSLookup, bundle, subFees, addOn, conversionrate);
            subFees.Support_Level_Price__c = dSupport;

            //calculate GMV
            dGMV = gmv(lstSSLookup, subFees, addOn, conversionrate);
            subFees.Predicted_GMV_Price__c = dGMV;
                        
            //add PCI Proxy and Gateway Totals
     		if(subFees.PCI_Proxy__c){
                dPCIProxyTotal = addOn.PCI_Proxy_Total_Cost__c;
            } else {
                dPCIProxyTotal = 0.0;
            }
            if(subFees.Payment_Gateway__c){
     		    dPaymentGatewayTotal = addOn.Payment_Gateway_Total_Cost__c;
            } else {
                dPaymentGatewayTotal = 0.0;
            }


            //sum the values together
            dPackageTotal = dClickAndCollect + dOMS + dSmartPOS + dDigitalCommerce + dSupport + dGMV + dPCIProxyTotal + dPaymentGatewayTotal;

            subFees.Total_Price__c = dPackageTotal;           
            
            //set up list of Subscription Fees to update
            lstSubFeeRecords.add(subFees);
            //set up list of Add Ons to update
            lstAddOnRecords.add(addOn);
        }
        
        //update the records
        update lstSubFeeRecords;
        update lstAddOnRecords;
    }
    //Methods
    
    //convert amounts to EURO so that metadata lookups work - values in EURO there
    public static Decimal convertCurrency(String curr, Decimal value, Decimal conversionrate){
        Decimal convertedVolume;
        
		//do currency conversion here
        if (curr != EURO){
        	convertedVolume = value / conversionrate;
        }else{
        	//EUR (*1)
            convertedVolume = value; 
        }

        return convertedVolume;
    }
    
    //calculate click and collect
    public static Decimal clickAndCollect(List<Software_Subscription_Lookup__mdt> lstMetaLookup, Subscription_Fees__c subFees, Add_On__c addOn, Decimal conversionrate) {
        Decimal amount = 0.0;
        
        for(Software_Subscription_Lookup__mdt metaSS : lstMetaLookup) {
            if (metaSS.Product__c == productCANDC) 
            {
                amount = convertCurrency(addOn.CurrencyIsoCode, metaSS.Amount__c, conversionrate);
            }
        }
        
        return amount;
    }
        
    //calculate OMS
    public static Decimal oms(List<Software_Subscription_Lookup__mdt> lstMetaLookup, Subscription_Fees__c subFees, Add_On__c addOn, Decimal conversionrate) {
        Decimal amount = 0.0;
        
        for(Software_Subscription_Lookup__mdt metaSS : lstMetaLookup) {
            if (metaSS.Product__c == productOMS) 
            {
                amount = convertCurrency(addOn.CurrencyIsoCode, metaSS.Amount__c, conversionrate);
            }
        }
        
        return amount;
    }

    //calculate smart POS
    public static Decimal smartPOS(List<Software_Subscription_Lookup__mdt> lstMetaLookup, Subscription_Fees__c subFees, Add_On__c addOn, Decimal conversionrate) {
        Decimal amount = 0.0;
        Boolean metadataFound = false;
        Decimal numAssociates = addOn.Number_Of_Associates__c;
        
        for(Software_Subscription_Lookup__mdt metaSS : lstMetaLookup) {
            if (
               	(metaSS.Product__c == productSMARTPOS) && 
               	(metaSS.min__c <= numAssociates )  &&
               	(metaSS.max__c >= numAssociates ) 
               ){
                    
                amount = convertCurrency(addOn.CurrencyIsoCode, metaSS.Amount__c, conversionrate);
                metadataFound = true;
            }
        }

        if (!metadataFound){
            if (numAssociates > sPOSMaxLimit){
                //use the user entered value since number of associates exceeds 831
                amount = convertCurrency(addOn.CurrencyIsoCode, addOn.SPOS_Price__c, conversionrate);               
            }
        }
        
        return amount;
    }
    
    //calculate digital commerce - to do
    public static Decimal digitalCommerce(List<Software_Subscription_Lookup__mdt> lstMetaLookup, Subscription_Fees__c subFees, Add_On__c addOn, Decimal conversionrate) {
        Decimal amount = 0.0;
        Decimal amt = 0.0;
        Decimal amt1 = 0.0;
        Decimal amt2 = 0.0;
        Decimal amt3 = 0.0;
        Decimal numDC = 0.0;
        Decimal amtDC1 = 0.0;
        Decimal amtDC2 = 0.0;
        Decimal amtTotal = 0.0;
        
        for(Software_Subscription_Lookup__mdt metaSS : lstMetaLookup) {
            
            //calculate 1 v 2 (18K) based on checkbox on sub fees
            //then check for addons using the other 4 checkboxes
            //


            //digital commerce has been selected on the sub fees record, so we need to apply the initial cost
            
            if ((addOn.Per_Independently_Managed_Brand__c != null) && (addOn.Per_Independently_Managed_Brand__c > 0)){
                //handle if = 'Digital Commerce' - 1st 'base' amount
                if ((metaSS.Product__c == productDIGITALCOMMERCE) && 
                    (metaSS.Options__c == 'Base'))	
                {
                    numDC = addOn.Per_Independently_Managed_Brand__c;
                    amtDC1 = metaSS.Amount__c;
                }
                
                //handle if = 'Digital Commerce' - 2nd and extra amounts
                if ((metaSS.Product__c == productDIGITALCOMMERCE) && 
                    (metaSS.Options__c == 'Recurring'))	
                {
                    numDC = addOn.Per_Independently_Managed_Brand__c;
                    amtDC2 = metaSS.Amount__c * (numDC - 1);
                } 
            }
            
			//Additional_Domain_Name__c
            if ((addOn.Per_DC_Implementation__c != null) &&(addOn.Per_Website__c != null)){

                if (metaSS.Product__c == productDIGITALCOMMERCE && 
                      (addOn.Additional_Domain_Name__c == TRUE &&
                      metaSS.Options__c == 'Additional Domain Name') 
                   )
                {
                    amt3 = metaSS.Amount__c * addOn.Per_DC_Implementation__c * addOn.Per_Website__c;
                }
            }     

            //Webfront__c
            if ((addOn.Per_DC_Implementation__c != null) &&(addOn.Per_Website__c != null)){

                if (metaSS.Product__c == productDIGITALCOMMERCE && 
                    ((addOn.Webfront__c == TRUE &&
                      metaSS.Options__c == 'Webfront')
                    )
                   )
                {
                    amt1 = metaSS.Amount__c * addOn.Per_DC_Implementation__c * addOn.Per_Website__c;
                }
            }        
            
            //StoreFront_APIs_For_Other_Channels__c            
            if (addOn.Per_DC_Implementation__c != null){
                if (metaSS.Product__c == productDIGITALCOMMERCE && 
                    (
                      (addOn.StoreFront_APIs_For_Other_Channels__c == TRUE &&
                      metaSS.Options__c == 'StoreFront APIs For Other Channels') 
                      
                    )
                   )
                {
                    amt = metaSS.Amount__c * addOn.Per_DC_Implementation__c ;
                } 

                //Distance_Selling_Checkout__c
                if (metaSS.Product__c == productDIGITALCOMMERCE && 
                    (
                      (addOn.Distance_Selling_Checkout__c == TRUE &&
                      metaSS.Options__c == 'Distance Selling Checkout')
                    )
                   )
                {
                    amt2 = metaSS.Amount__c * addOn.Per_DC_Implementation__c ;
                }       

            }
            amtTotal = amt + amt1 + amt2 + amt3 + amtDC1 + amtDC2;                                    
            amount = convertCurrency(addOn.CurrencyIsoCode, amtTotal, conversionrate);
        }
        
        return amount;
    }
    
    //calculate SUPPORT
    public static Decimal support(List<Software_Subscription_Lookup__mdt> lstMetaLookup, Decimal bundle, Subscription_Fees__c subFees, Add_On__c addOn, Decimal conversionrate) {
        Decimal amount = 0.0;
        Decimal rate = 0.0;
        Decimal price = 0.0;
        
        //get the support percentage rate and the tier price
        for(Software_Subscription_Lookup__mdt metaSS : lstMetaLookup) {
            if ((metaSS.Product__c == productSUPPORT) && 
               	(metaSS.Options__c == subFees.Support_Level__c ))
            {
                
                rate = metaSS.Rate__c;
                price = metaSS.Amount__c;
                                
            }
        }
        
        //calcuate the support total        
        Decimal amt = ((bundle * rate) / 100) + price ; 
		amount = convertCurrency(addOn.CurrencyIsoCode, amt, conversionrate);

        return amount;
    }  
    
    //calculate GMV
    public static Decimal gmv(List<Software_Subscription_Lookup__mdt> lstMetaLookup, Subscription_Fees__c subFees, Add_On__c addOn, Decimal conversionrate) {
        Decimal amount = 0.0;
        Boolean metadataFound = false;
        Decimal predictedGMV = subFees.Predicted_GMV_Value__c;
        
        for(Software_Subscription_Lookup__mdt metaSS : lstMetaLookup) {
            if ((metaSS.Product__c == productGMV) && 
               	(metaSS.min__c <= predictedGMV )  &&
               	(metaSS.max__c >= predictedGMV ) )
            {
                    
                amount = convertCurrency(addOn.CurrencyIsoCode, metaSS.Amount__c, conversionrate);
                metadataFound = true;
            }
        }
        
        if (!metadataFound){
            if (predictedGMV > gmvMaxLimit){
                //use the user entered value since number of associates exceeds 175,000,000
                amount = convertCurrency(addOn.CurrencyIsoCode, subFees.Predicted_GMV__c, conversionrate);               
            }
        }

        return amount;
    }    

}