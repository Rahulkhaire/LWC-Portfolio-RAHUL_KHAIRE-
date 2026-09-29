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
const SKILL_CATEGORY_GROUPS = [
    { title: 'Development', icon: '⚡', items: ['Apex', 'LWC', 'SOQL', 'SOSL', 'Triggers', 'Test Classes'] },
    { title: 'Automation', icon: '⌁', items: ['Flows', 'Approval Processes', 'Automation'] },
    { title: 'Platform', icon: '☁', items: ['Sales Cloud', 'Service Cloud', 'Experience Cloud', 'Education Cloud', 'OmniStudio'] },
    { title: 'Integration', icon: '⇄', items: ['REST APIs', 'Postman', 'WhatsApp Cloud API', 'Platform Events'] },
    { title: 'AI', icon: '✳', items: ['Agentforce', 'Prompt Builder', 'Salesforce AI'] }
];
const NAV = [
    { id: 'home', label: 'Home' },
    { id: 'projects', label: 'Projects' },
    { id: 'skills', label: 'Skills' },
    { id: 'experience', label: 'Experience' },
    { id: 'credentials', label: 'Credentials' },
    { id: 'ai-data-cloud', label: 'AI / Cloud' },
    { id: 'contact', label: 'Contact' }
];

export default class PortfolioApp extends LightningElement {
    label = { TITLE, INTRO };
    nav = NAV;
    data = { projects: [], skills: [], experience: [], education: [], achievements: {} };
    selectedProject = null;
    projectTrigger;
    isLightTheme = false;
    loadError = false;
    loading = true;
    menuOpen = false;
    honeypot = '';
    form = { name: '', email: '', message: '' };
    sending = false;

    @wire(getPortfolioData)
    wired({ data, error }) {
        if (data) {
            this.data = data;
            this.loadError = false;
            this.loading = false;
        } else if (error) {
            this.loadError = true;
            this.loading = false;
            // Keep implementation details out of the visitor-facing error message.
            console.error('Portfolio data failed to load:', error);
        }
    }

    get skillGroups() {
        return SKILL_CATEGORY_GROUPS.map((group) => ({
            ...group,
            skills: group.items.map((name) => ({ name }))
        }));
    }

    get projects() {
        return this.data.projects.map((project) => ({
            ...project,
            isSalesforceFeatured: project.category === 'featured-salesforce',
            hasArchitecture: (project.architecture || []).length > 0,
            hasGithub: Boolean(project.githubUrl),
            hasDemo: Boolean(project.demoUrl),
            hasCaseStudy: Boolean(project.caseStudyUrl)
        }));
    }

    get featuredSalesforceProjects() { return this.projects.filter((project) => project.isSalesforceFeatured); }
    get secondaryProjects() { return this.projects.filter((project) => project.category === 'secondary'); }
    get secondarySkillCategories() {
        return this.data.skills
            .filter((skill) => !['Salesforce Development', 'Salesforce Platform', 'Integration'].includes(skill.category))
            .map((skill) => ({
                category: skill.category,
                icon: skill.icon,
                items: skill.items.map((name) => ({ name }))
            }));
    }
    get counterDisplay() {
        const achievements = this.data.achievements || {};
        return {
            badges: achievements.badges || 0,
            supers: achievements.superbadges || 0
        };
    }

    get journeyItems() {
        return this.data.achievements?.journey || [];
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
            await submitContact({
                name: this.form.name,
                email: this.form.email,
                phone: null,
                subject: 'Portfolio inquiry',
                message: this.form.message,
                website: this.honeypot
            });
            this.toast('Message sent', OK, 'success');
            this.form = { name: '', email: '', message: '' };
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
