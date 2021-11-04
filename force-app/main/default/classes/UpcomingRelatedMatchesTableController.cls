public with sharing class UpcomingRelatedMatchesTableController {
    @AuraEnabled(cacheable=true)
    public static List<Match__c> getUpcomingRelatedMatches(String recordId) {
        return [SELECT Id, Home_Team__r.Name, Visitors__r.Name, Days_Left__c
                FROM  Match__c
                WHERE Start_Datetime__c>=TODAY and (Home_Team__c=:recordId or Visitors__c=:recordId) 
                ORDER BY Days_Left__c ASC 
                LIMIT 10];
    }
}