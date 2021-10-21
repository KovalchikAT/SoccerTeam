public with sharing class MatchTriggerHendler {
    public static void updatePreviousMatchDateTime(List<Match__c> matchList) {
        for (Match__c tmp : matchList) {
            tmp.Previous_Match_Between_Teams_Datetime__c= SoccerDAO.previousMatchDatetimeSet(tmp);
        }
    }
}
