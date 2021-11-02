trigger MatchAddUpdate on Match__c (before insert, before update) {
    system.debug(System.LoggingLevel.DEBUG, 1);
    for (Match__c tmp : Trigger.new) {
        tmp.Previous_Match_Between_Teams_Datetime__c= SoccerDAO.previousMatchDatetimeSet(tmp);
    }
}