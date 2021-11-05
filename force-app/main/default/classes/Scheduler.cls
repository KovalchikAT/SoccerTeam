global class Scheduler implements Schedulable {
    public static String sched = '0 00 00 1 * ?';  //Every month start
    public Integer base=50; // base value of bonus for player
    global static String schedulerStart() {
        Scheduler SC = new Scheduler(); 
        return System.schedule('Bonus accured', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        PlayerBonusBatch b1 = new PlayerBonusBatch(SoccerDAO.getTeamWins([SELECT id, score__c, Home_Team__c, Visitors__c FROM Match__c WHERE Start_Datetime__c=LAST_MONTH]),base);
        ID batchId = Database.executeBatch(b1);           
    }
}