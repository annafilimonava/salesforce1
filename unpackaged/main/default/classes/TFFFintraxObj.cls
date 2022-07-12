public class TFFFintraxObj {
        public String LatestPaymentStatus {set;get;}
        public String TaxFreeFormId {set;get;}
        public String RetailerId {set;get;}
        public String VendorNumber {set;get;}
        public String CountryOfPurchase {set;get;}
        public string SalesAmount {set;get;}
        public String SalesCurrency {set;get;}
        public String RefundAmount {set;get;}
        public String RefundCurrency {set;get;}
        public List<String> ErrorCodes {set;get;}
        public String P2EntryDate {set;get;}
        public String QualifiedDate {set;get;}
        public DateTime PurchaseDate {set;get;}
        public String CustomsDateStamp {set;get;}
        public String RefundDate {set;get;}
        public String RefundMethod {set;get;}
        public String ChequeNumber {set;get;}
        public String MaskedCardNumber {set;get;}
        public String AlipayId {set;get;}
        public String BankAccountNumber {set;get;}
        public String ExitPoint {set;get;}
        public String Priority {set;get;}
        public String TouristPremierPassId {set;get;}
        public String TouristPassportNumber {set;get;}
        public String TouristPassportIssuingCountry {set;get;}
        public String TouristLastName {set;get;}
        public String TouristFirstName {set;get;}
        public String TouristEmailAddress {set;get;}
        public String TouristDateOfBirth {set;get;}
        public String TouristFinalDestination {set;get;}
        public String TouristPhoneNumber {set;get;}
        public String TouristAddress {set;get;}
        public String TouristPostalCode {set;get;}
        public static List<TFFFintraxObj> jsonParse(String json) {
        return (List<TFFFintraxObj>) System.JSON.deserialize(json, List<TFFFintraxObj>.class);
    }
    
}