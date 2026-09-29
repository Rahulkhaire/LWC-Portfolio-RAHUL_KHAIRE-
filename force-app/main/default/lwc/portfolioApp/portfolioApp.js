import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPortfolioData from '@salesforce/apex/PortfolioController.getPortfolioData';
import submitContact from '@salesforce/apex/PortfolioController.submitContact';
import RESUME from '@salesforce/resourceUrl/Rahul_Resume';
import TITLE from '@salesforce/label/c.Portfolio_Title';
import INTRO from '@salesforce/label/c.Portfolio_Intro';
import OK from '@salesforce/label/c.Portfolio_Contact_Success';
import ERR from '@salesforce/label/c.Portfolio_Contact_Error';

const GITHUB = 'https://github.com/Rahulkhaire';
const LINKEDIN = 'https://www.linkedin.com/in/rahul-khaire-9306b2273';
const TRAILHEAD = 'https://www.salesforce.com/trailblazer/rahul-khaire';
const EMAIL = 'rahul.khaire@mit.asia';
const NAV = [
    { id: 'home', label: 'Home' },
    { id: 'about', label: 'About' },
    { id: 'salesforce-development', label: 'Salesforce' },
    { id: 'skills', label: 'Skills' },
    { id: 'technical-highlights', label: 'Technical Highlights' },
    { id: 'experience', label: 'Experience' },
    { id: 'projects', label: 'Projects' },
    { id: 'certifications', label: 'Certifications' },
    { id: 'achievements', label: 'Achievements' },
    { id: 'trailhead', label: 'Trailhead' },
    { id: 'education', label: 'Education' },
    { id: 'contact', label: 'Contact' }
];
const SALESFORCE_SPECIALIZATIONS = [
    { name: 'Apex', icon: '⚡', summary: 'Server-side business logic, service classes and callouts.', evidence: 'Listed in the medical inventory and WhatsApp integration project stacks.', useCase: 'Coordinate application rules and external service communication.' },
    { name: 'Lightning Web Components', icon: '▣', summary: 'Reusable, responsive interfaces built for Salesforce.', evidence: 'Used in the portfolio and listed across the Salesforce project work.', useCase: 'Give users focused experiences for CRM workflows.' },
    { name: 'Triggers', icon: '↻', summary: 'Record automation coordinated with Apex logic.', evidence: 'Triggers are included in the stated Salesforce development skill set.', useCase: 'React consistently to record changes while keeping logic bulk-aware.' },
    { name: 'Flows', icon: '⌁', summary: 'Declarative automation for repeatable business processes.', evidence: 'Flows are included in the medical inventory project technology list.', useCase: 'Automate operational steps and alerts.' },
    { name: 'OmniStudio', icon: '◇', summary: 'Salesforce industry tools included in the platform skill set.', evidence: 'Listed as a Salesforce Platform skill; no specific project example is published.', useCase: 'Use guided digital workflows when the implementation calls for it.' },
    { name: 'Integrations', icon: '⇄', summary: 'REST APIs and external service connections.', evidence: 'Project stack names Razorpay, Google Maps, IDFY and WhatsApp Cloud API.', useCase: 'Connect payment, location, identity and customer messaging services.' },
    { name: 'Security', icon: '◈', summary: 'Sharing, permissions and field access considerations.', evidence: 'The portfolio contact form uses user-mode Apex DML and restrictive record sharing.', useCase: 'Protect submitted contact data and enforce platform permissions.' },
    { name: 'Data Modeling', icon: '▤', summary: 'Organize CRM records to support operational workflows.', evidence: 'The featured medical project covers medicine inventory, orders and shipments.', useCase: 'Represent inventory and transfer workflows in Salesforce records.' },
    { name: 'Agentforce', icon: '✳', summary: 'Salesforce AI and agent capabilities included in the skills profile.', evidence: 'Agentforce appears in the portfolio skill set and Trailhead achievements.', useCase: 'Explore agent-supported service and automation experiences.' }
];
const TECHNICAL_HIGHLIGHTS = [
    { name: 'Apex & Triggers', example: 'Apex and triggers are included in the Salesforce development profile and project stack.' },
    { name: 'Lightning Web Components', example: 'LWC is used to deliver the portfolio experience and is listed in the Salesforce projects.' },
    { name: 'Salesforce Integrations', example: 'The medical inventory project lists Razorpay, Google Maps, IDFY and WhatsApp Cloud API.' },
    { name: 'OmniStudio', example: 'Included in the Salesforce Platform skills profile; project details are not published.' },
    { name: 'Flows & Automation', example: 'Flows support the stated medical inventory, notifications and operational automation scope.' },
    { name: 'SOQL & Data Modeling', example: 'SOQL is part of the stated development skills; inventory, order and shipment workflows are featured.' },
    { name: 'Agentforce', example: 'Agentforce is listed in the skills profile and Trailhead achievements.' },
    { name: 'REST APIs', example: 'Apex REST and external API integrations feature in the WhatsApp and medical solution descriptions.' }
];

export default class PortfolioApp extends LightningElement {
    label = { TITLE, INTRO };
    nav = NAV;
    data = { projects: [], skills: [], experience: [], certifications: [], education: [], achievements: {} };
    activeSkill = 0;
    selectedProject = null;
    projectTrigger;
    isLightTheme = false;
    loadError = false;
    loading = true;
    menuOpen = false;
    honeypot = '';
    form = { name: '', email: '', phone: '', subject: '', message: '' };
    sending = false;
    salesforceSpecializations = SALESFORCE_SPECIALIZATIONS;
    technicalHighlights = TECHNICAL_HIGHLIGHTS;

    @wire(getPortfolioData)
    wired({ data, error }) {
        if (data) {
            this.data = data;
            this.loadError = false;
            this.loading = false;
            if (this.activeSkill >= data.skills.length) this.activeSkill = 0;
        } else if (error) {
            this.loadError = true;
            this.loading = false;
            // Keep implementation details out of the visitor-facing error message.
            console.error('Portfolio data failed to load:', error);
        }
    }

    get skillTabs() {
        return this.data.skills.map((skill, index) => ({
            ...skill,
            idx: index,
            cls: `tab${index === this.activeSkill ? ' active' : ''}`,
            selected: index === this.activeSkill
        }));
    }

    get activeSkillItems() {
        const category = this.data.skills[this.activeSkill];
        return (category?.items || []).map((name) => ({ name, description: category.description }));
    }

    get certs() {
        return this.data.certifications.map((certification) => ({
            ...certification,
            hasDate: Boolean(certification.date),
            hasUrl: Boolean(certification.url)
        }));
    }

    get ranks() { return this.data.achievements?.ranks || []; }

    get projects() {
        return this.data.projects.map((project) => ({
            ...project,
            hasGithub: Boolean(project.githubUrl),
            hasDemo: Boolean(project.demoUrl),
            hasCaseStudy: Boolean(project.caseStudyUrl)
        }));
    }

    get counterDisplay() {
        const achievements = this.data.achievements || {};
        return {
            badges: `${achievements.badges || 0}+`,
            supers: `${achievements.superbadges || 0}+`,
            points: Number(achievements.points || 0).toLocaleString('en-IN'),
            trails: achievements.trails || 0,
            projects: this.data.projects.length,
            interns: this.data.experience.length
        };
    }

    get resumeUrl() { return RESUME; }
    get githubUrl() { return GITHUB; }
    get linkedInUrl() { return LINKEDIN; }
    get trailheadUrl() { return TRAILHEAD; }
    get emailUrl() { return `mailto:${EMAIL}`; }
    get themeClass() { return `root${this.isLightTheme ? ' light-theme' : ''}`; }
    get themeToggleText() { return this.isLightTheme ? 'Dark theme' : 'Light theme'; }
    get themeToggleLabel() { return `Switch to ${this.isLightTheme ? 'dark' : 'light'} theme`; }
    get themeIcon() { return this.isLightTheme ? '◐' : '☼'; }
    get navigationClass() { return `nav-links${this.menuOpen ? ' menu-open' : ''}`; }
    get menuLabel() { return this.menuOpen ? 'Close navigation menu' : 'Open navigation menu'; }
    get menuIcon() { return this.menuOpen ? '×' : '☰'; }
    get sendButtonLabel() { return this.sending ? 'Sending…' : 'Send Message'; }

    toggleTheme() { this.isLightTheme = !this.isLightTheme; }
    toggleMenu() { this.menuOpen = !this.menuOpen; }

    scrollTo(event) {
        const section = this.template.querySelector(`[data-section="${event.currentTarget.dataset.id}"]`);
        if (!section) return;
        const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        section.scrollIntoView({ behavior: reduceMotion ? 'auto' : 'smooth', block: 'start' });
        this.menuOpen = false;
    }

    pickSkill(event) { this.activeSkill = Number(event.currentTarget.dataset.idx); }
    openProject(event) {
        this.projectTrigger = event.currentTarget;
        this.selectedProject = this.data.projects.find((project) => project.id === event.currentTarget.dataset.id);
    }
    closeProject() {
        this.selectedProject = null;
        window.requestAnimationFrame(() => this.projectTrigger?.focus());
    }
    onField(event) { this.form = { ...this.form, [event.target.name]: event.target.value }; }
    onHoneypotChange(event) { this.honeypot = event.target.value; }

    async submit() {
        const inputs = [...this.template.querySelectorAll('.cf')];
        const valid = inputs.reduce((allValid, input) => input.reportValidity() && allValid, true);
        if (!valid || this.sending) return;

        this.sending = true;
        try {
            await submitContact({ ...this.form, website: this.honeypot });
            this.toast('Message sent', OK, 'success');
            this.form = { name: '', email: '', phone: '', subject: '', message: '' };
            this.honeypot = '';
        } catch (error) {
            this.toast('Unable to send message', error?.body?.message || ERR, 'error');
        } finally {
            this.sending = false;
        }
    }

    toast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
