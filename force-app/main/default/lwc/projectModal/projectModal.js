import { LightningElement, api } from 'lwc';
export default class ProjectModal extends LightningElement {
    @api project = {};
    handleKeydown = (event) => {
        if (event.key === 'Escape') {
            event.preventDefault();
            this.close();
            return;
        }
        if (event.key !== 'Tab') return;

        const focusable = [...this.template.querySelectorAll('button:not([disabled]), a[href], lightning-button:not([disabled])')];
        if (!focusable.length) return;
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        const active = this.template.activeElement;
        if (event.shiftKey && (active === first || !this.template.contains(active))) {
            event.preventDefault();
            last.focus();
        } else if (!event.shiftKey && (active === last || !this.template.contains(active))) {
            event.preventDefault();
            first.focus();
        }
    };
    hasInitialFocus = false;

    connectedCallback() { window.addEventListener('keydown', this.handleKeydown); }
    disconnectedCallback() { window.removeEventListener('keydown', this.handleKeydown); }
    renderedCallback() {
        if (this.hasInitialFocus) return;
        this.template.querySelector('.close-button')?.focus();
        this.hasInitialFocus = true;
    }
    close() { this.dispatchEvent(new CustomEvent('close')); }
    stop(e) { e.stopPropagation(); }
    get hasGithub() { return Boolean(this.project?.githubUrl); }
    get hasDemo() { return Boolean(this.project?.demoUrl); }
    get hasCaseStudy() { return Boolean(this.project?.caseStudyUrl); }
}
