@isTest 
public with sharing class SoccerServiceTest {

    @testSetup static void setup() {
        // Create common test Teams
        List<Team__c> testTeam = new List<Team__c>();
        for(Integer i=0;i<2;i++) {
            testTeam.add(new Team__c(Name ='Team_'+i, Total_Active_Players__c =13));
        }
        insert testTeam;

        // Create common test Players
        List<Player__c> testPlayer = new List<Player__c>();
        Integer k=0;
        for (Integer j=0;j<testTeam.size();j++) {
            for(Integer i=0;i<=12;i++) {
                testPlayer.add(new Player__c(Name ='Player_'+k, Email__c ='Player_'+k+'@ukr.net', IsActive__c =True, Team__c=testTeam.get(j).id));
                k++;
            } 
        }             
        upsert testPlayer;

        // Create common test Match
        List<Match__c> testMatch = new List<Match__c>();
        Integer n=0, m=1;
        for(Integer i=0;i<3;i++) {
            testMatch.add(new Match__c(Name ='TestMatch_'+i, Start_DateTime__c =DateTime.now()+i, Home_Team__c =testTeam.get(n).Id, Visitors__c =testTeam.get(m).Id, Score__c ='00:00'));
            n = n<testTeam.size() ? n++ : 0;
            m = m<testTeam.size() ? m++ : 0;
        }
        upsert testMatch; 
        
        system.debug(System.LoggingLevel.DEBUG, testTeam);
        system.debug(System.LoggingLevel.DEBUG, testPlayer);
        system.debug(System.LoggingLevel.DEBUG, testMatch);            
    }


    @isTest public static void createPlayer(){
        
        List<Player__c> playerList= new List<Player__c>([SELECT id, name, email__c, isActive__c, Team__c FROM Player__c]);
        Integer i =0;
        Map<SObjectField, Object> extraValues =new Map<SObjectField, Object>{Schema.sObjectType.Player__c.fields.getMap().get('IsActive__c')=> (Math.mod(i,2) == 0 ? true : false)};
        Integer old = ([SELECT id FROM Player__c]).size();
        
        Test.startTest();
        SoccerService.createPlayer('Player_'+playerList.size(), 'Player_'+playerList.size()+'@ukr.net', extraValues);
        Test.stopTest();
        
        Integer ret = ([SELECT id FROM Player__c]).size();
        
        System.assertEquals(old+1, ret,'createPlayer valid');
    }
    @isTest public static void arangeMatch(){
        List<Team__c> teamList= new List<Team__c>([SELECT id FROM Team__c]);
        Id home = teamList.get(0).Id;
        Id visit = teamList.get(1).Id;
        Datetime t = Datetime.now();
        
        Integer old = ([SELECT id FROM Match__c]).size();

        Test.startTest();
        SoccerService.arangeMatch(t,home,visit);
        Test.stopTest();

        Integer ret = ([SELECT id FROM Match__c]).size();
        
        System.assertEquals(old+1, ret,'arangeMatch valid');
    }
/*  @isTest public static void setScoreToMatches(){
       List<SoccerService.ScoreHelper> scores= new List<SoccerService.ScoreHelper>();
       scores.add(new SoccerService.ScoreHelper((Id)'a0B090000029AQgEAM',1,1));
       scores.add(SoccerService.ScoreHelper((Id)'a0B090000029AQWEA2',1,2));

       SoccerService.setScoreToMatches(scores);
    }*/
    @isTest public static void deactivatePlayers(){
        List<Id> playersIds= new List<Id>();
        for (PLayer__c tmp : [SELECT id FROM Player__c LIMIT 2]) {
            playersIds.add(tmp.id);
        }
        Integer old = ([SELECT id FROM Player__c WHERE isActive__c = true]).size();

        Test.startTest();
        SoccerService.deactivatePlayers(playersIds);
        Test.stopTest();

        Integer ret = ([SELECT id FROM Player__c WHERE isActive__c = true]).size();
        
        System.assertEquals(old-2, ret,'deactivatePlayers valid');
    }/* */
}
