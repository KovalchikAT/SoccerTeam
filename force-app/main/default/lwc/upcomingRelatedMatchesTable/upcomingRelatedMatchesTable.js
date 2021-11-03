import { LightningElement, track, wire, api } from 'lwc';
import getUpcomingRelatedMatches from 
'@salesforce/apex/UpcomingRelatedMatchesTableController.getUpcomingRelatedMatches';

export default class UpcomingRelatedMatchesTable extends LightningElement {
    @api recordId;
    @track matchs;
    @track columns = [
        { label: 'days before the match', fieldName: 'Days_Left__c', type: 'Integer'},
        { label: 'Home Team', fieldName: 'Home_Team__r.Name', type: 'text' },
        { label: 'Visitors', fieldName: 'Visitors__r.Name', type: 'text'}
    ];

    @wire(getUpcomingRelatedMatches, {recordId: '$recordId'}) 
    WireContactRecords({error, data}){
        if(data){
            this.matchs = data.map(
                record => Object.assign(
                        { "Home_Team__r.Name": record.Home_Team__r.Name, "Visitors__r.Name": record.Visitors__r.Name}, record));;
            this.error = undefined;
        }else{
            this.error = error;
            this.matchs = undefined;
        }
    }
}