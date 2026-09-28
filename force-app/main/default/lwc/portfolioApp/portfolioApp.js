import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
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
const NAV = ['Home', 'About', 'Skills', 'Projects', 'Experience', 'Certifications', 'Trailhead', 'Education', 'Contact'];

export default class PortfolioApp extends NavigationMixin(LightningElement) {
    label = { TITLE, INTRO };
    nav = NAV.map((n) => ({ id: n.toLowerCase(), label: n }));
    data = { projects: [], skills: [], experience: [], certifications: [], education: [], achievements: {} };
    activeSkill = 0;
    selectedProject = null;
    isLightTheme = false;
    form = { name: '', email: '', phone: '', subject: '', message: '' };
    sending = false;
    animationTimer;
    counters = { badges: 0, superbadges: 0, points: 0, trails: 0, projects: 0, interns: 0 };
    aboutTimeline = [
        { id: 't1', when: '2022 → 2026', what: 'B.Tech AI & Data Science', where: 'Maharashtra Institute of Technology' },
        { id: 't2', when: 'Feb 2025 → Jun 2025', what: 'Salesforce Intern', where: 'Cendance Systems Inc.' },
        { id: 't3', when: 'Jan 2026 → May 2026', what: 'Salesforce AI Intern', where: 'Pinnacle Technology' }
    ];
    aboutTags = ['Apex', 'LWC', 'Agentforce', 'CRM Automation', 'Integrations', 'AI & Data Science'];

    @wire(getPortfolioData)
    wired({ data, error }) {
        if (data) {
            this.data = data;
            this.animate(data.achievements);
        } else if (error) {
            this.toast('Error', ERR, 'error');
        }
    }

    // ---- getters ----
    get skillTabs() {
        return this.data.skills.map((s, i) => ({ ...s, idx: i, cls: 'tab' + (i === this.activeSkill ? ' active' : '') }));
    }
    get activeSkillItems() { return this.data.skills[this.activeSkill]?.items || []; }
    get certs() {
        return this.data.certifications.map((c) => ({ ...c, noUrl: !c.url, hasDate: !!c.date }));
    }
    get ranks() { return this.data.achievements?.ranks || []; }
    get projects() {
        return this.data.projects.map((p) => ({ ...p, noDemo: !p.demoUrl }));
    }
    get counterDisplay() {
        const c = this.counters;
        return {
            badges: c.badges + '+', points: c.points.toLocaleString('en-IN') + '+', supers: c.superbadges, trails: c.trails,
            projects: c.projects, interns: c.interns
        };
    }
    get resumeUrl() { return RESUME; }
    get themeClass() { return `root${this.isLightTheme ? ' light-theme' : ''}`; }
    get themeToggleText() { return this.isLightTheme ? 'Black theme' : 'White theme'; }
    get themeToggleLabel() { return `Switch to ${this.isLightTheme ? 'black' : 'white'} theme`; }
    get themeIcon() { return this.isLightTheme ? '◐' : '☼'; }

    // ---- animation ----
    animate(a) {
        const target = { badges: a.badges, superbadges: a.superbadges, points: a.points, trails: a.trails, projects: 3, interns: 2 };
        if (this.animationTimer) clearInterval(this.animationTimer);
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            this.counters = target;
            return;
        }
        const steps = 50;
        let n = 0;
        this.animationTimer = setInterval(() => {
            n++;
            const k = n / steps;
            const next = {};
            Object.keys(target).forEach((key) => { next[key] = Math.round(target[key] * k); });
            this.counters = next;
            if (n >= steps) {
                clearInterval(this.animationTimer);
                this.animationTimer = undefined;
            }
        }, 30);
    }

    disconnectedCallback() {
        if (this.animationTimer) clearInterval(this.animationTimer);
        this.animationTimer = undefined;
    }

    // ---- handlers ----
    toggleTheme() { this.isLightTheme = !this.isLightTheme; }

    scrollTo(e) {
        const el = this.template.querySelector(`[data-section="${e.currentTarget.dataset.id}"]`);
        if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    openUrl(e) {
        const url = e.currentTarget.dataset.url;
        if (url) this[NavigationMixin.Navigate]({ type: 'standard__webPage', attributes: { url } });
    }
    openGithub() { this.go(GITHUB); }
    openLinkedIn() { this.go(LINKEDIN); }
    openTrailhead() { this.go(TRAILHEAD); }
    downloadResume() { this.go(RESUME); }
    go(url) { this[NavigationMixin.Navigate]({ type: 'standard__webPage', attributes: { url } }); }
    pickSkill(e) { this.activeSkill = Number(e.currentTarget.dataset.idx); }
    openProject(e) { this.selectedProject = this.data.projects.find((p) => p.id === e.currentTarget.dataset.id); }
    closeProject() { this.selectedProject = null; }
    onField(e) { this.form = { ...this.form, [e.target.name]: e.target.value }; }

    async submit() {
        const inputs = [...this.template.querySelectorAll('.cf')];
        const valid = inputs.reduce((ok, i) => i.reportValidity() && ok, true);
        if (!valid) return;
        this.sending = true;
        try {
            await submitContact({ ...this.form });
            this.toast('Success', OK, 'success');
            this.form = { name: '', email: '', phone: '', subject: '', message: '' };
        } catch (e) {
            this.toast('Error', e?.body?.message || ERR, 'error');
        } finally {
            this.sending = false;
        }
    }
    toast(title, message, variant) { this.dispatchEvent(new ShowToastEvent({ title, message, variant })); }
}
