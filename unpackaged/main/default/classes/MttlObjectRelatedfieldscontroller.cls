public class MttlObjectRelatedfieldscontroller{
    public  string searchTxt {get; set;}
    String queryString;
    public void searchrecords() {
        system.debug('selectedObject ---selectedField--------'+selectedObject+'---'+selectedField );
        
        queryString = 'SELECT Id, name';
        
        if (selectedObject!= null && selectedObject!= '')
         {
            queryString += ' from  '+ selectedObject+'';
        }
        
        if ( searchTxt != null && searchTxt!= '')
        
         {
            if (selectedField != null && selectedField != '') {
            
            queryString += ' where ' + selectedField +' = \''+searchTxt+'\'';
            
            system.debug('queryString -----'+queryString );
            
            }
            
        }
         
        system.debug('queryString -----------'+queryString );    
            
        lstQuery= database.query(queryString);
    }

    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();    

   

    Public MttlObjectRelatedfieldscontroller()
    {   
        selectedObject = 'account';
    }  
     public String selectedObject {get; set;}    
    
    public list<sobject >lstQuery{get; set;}      

    public String selectedField {get; set;}
    public List<SelectOption> getObjectNames()
        
    {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<Schema.SObjectType> objectList = gd.Values();
        
        String TestName = '';
     
        List<SelectOption> objNames = new List<SelectOption>();

        for (Schema.SObjectType s: objectList) {
            string Label = s.getDescribe().getLabel();
            string Name = s.getDescribe().getName();
            
            objNames.add(new SelectOption(Name,Label));
            
        }
        objNames.sort();
        return objNames;
    
     }         

     public List<SelectOption> getObjectFields() 
     {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            
            Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
            
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
           
            List<SelectOption> fieldNames = new List<SelectOption>();
            
            for (String fieldName: fieldMap.keySet()) 
            {  
               
                   String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
                 String fieldname1 = fieldMap.get(fieldName).getDescribe().getname();
                  Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                if(fielddataType != Schema.DisplayType.id && fielddataType != Schema.DisplayType.Reference ){
                
                fieldNames.add(new SelectOption(fieldname1,fieldLabel));
                }
            
            }
           fieldNames.sort();
            return fieldNames;
      }       
}