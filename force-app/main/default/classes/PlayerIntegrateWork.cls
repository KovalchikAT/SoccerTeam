@RestResource(urlMapping='/Cases/*')
global with sharing class PlayerIntegrateWork {
    
    global static void deletePlayerFromExternalBase (Id playerId){
        String endPoint ='https://avenga-school.herokuapp.com';
    
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint+'/'+playerId);
        req.setMethod('DELETE');
        HttpResponse resp;
        try {
            resp = http.send(req);

            System.debug(resp.toString());
            System.debug('Status Code'+resp.getStatusCode());
        } catch (System.CalloutException e) {
            System.debug('A HTTP callout exception has occurred: ' + e.getMessage());
        }
        


        if(resp.getStatusCode()==200){
            try {
                delete new Player__c(id=playerId);
            } catch (DmlException e) {
                System.debug('A DML delete exception has occurred: ' + e.getMessage());
            }
        }else  System.debug('A HTTP response isnt 200');
        
   }
}
