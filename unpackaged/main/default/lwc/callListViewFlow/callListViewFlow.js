import { LightningElement } from 'lwc';

export default class CallListViewFlow extends LightningElement {
    
    close() {
        setTimeout(
            function() {
                window.history.back();
            },
            500
        );
    }
}