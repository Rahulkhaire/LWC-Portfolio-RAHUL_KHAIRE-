import { LightningElement, api } from 'lwc';
export default class ProjectModal extends LightningElement {
    @api project = {};
    close() { this.dispatchEvent(new CustomEvent('close')); }
    stop(e) { e.stopPropagation(); }
}
