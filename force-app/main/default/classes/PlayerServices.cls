public with sharing class PlayerServices {
    public static map<String, List<Player__c>> groupActiveByStatus (List<Player__c> playersList){
        List<Player__c> activePlayerList = new List<Player__c>();
        List<Player__c> inactivePlayerList = new List<Player__c>();
        
        for (Player__c tmp : playersList) {
            if (tmp.isActive__c) {
                activePlayerList.add(tmp);
            } else {
                inactivePlayerList.add(tmp);
            }
        }
        
        Map<String, List<Player__c>> retMap = new Map<String, List<Player__c>>();
        retMap.put('active',activePlayerList);
        retMap.put('inactive',inactivePlayerList);
        system.debug(System.LoggingLevel.DEBUG, retMap);
        return retMap;
    }
}
//PlayerServices.groupActiveByStatus([SELECT id, isActive__c, Name FROM Player__c]);