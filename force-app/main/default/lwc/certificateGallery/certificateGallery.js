import { LightningElement } from 'lwc';
import CERTIFICATE_ASSETS from '@salesforce/resourceUrl/PortfolioCertificates';

const CERTIFICATE_RECORDS = [
    {
        id: 'salesforce-ai-associate',
        name: 'AI Associate',
        issuer: 'Salesforce',
        recipient: 'Khaire Rahul Vasant',
        date: 'February 22, 2025',
        type: 'Certification',
        category: 'Salesforce',
        description: 'Salesforce Certified AI Associate credential. The certificate image shows credential ID 5801035.',
        file: 'salesforce-ai-associate.jpeg',
        credentialId: '5801035',
        featured: true
    },
    {
        id: 'agentforce-class',
        name: 'Build Your First Agent with Agentforce — SAI002',
        issuer: 'Salesforce Trailhead Academy',
        recipient: 'Rahul Khaire',
        date: 'April 17, 2025',
        type: 'Class Completion Certificate',
        category: 'Salesforce',
        description: 'Trailhead Academy class completion certificate. The printed reference is identified as an attendance ID.',
        file: 'agentforce-class.jpeg',
        referenceLabel: 'Attendance ID',
        referenceId: 'a8bRf0000001iGjJAI',
        featured: true
    },
    {
        id: 'prompt-builder-class',
        name: 'Get Started with Prompt Builder — SAI006',
        issuer: 'Salesforce Trailhead Academy',
        recipient: 'Rahul Khaire',
        date: 'April 17, 2025',
        type: 'Class Completion Certificate',
        category: 'Salesforce',
        description: 'Trailhead Academy class completion certificate. The printed reference is identified as an attendance ID.',
        file: 'prompt-builder-class.jpeg',
        referenceLabel: 'Attendance ID',
        referenceId: 'a8bRf0000001iLZIAI',
        featured: true
    },
    {
        id: 'copado-robotic-testing',
        name: 'Copado Certified — Copado Robotic Testing',
        issuer: 'Copado',
        recipient: 'Rahul Khaire',
        date: 'June 23, 2026',
        type: 'Certification',
        category: 'Development',
        description: 'Copado certificate headed “Copado Robotic Testing”; its body describes a Copado Salesforce DevOps certification.',
        file: 'copado-robotic-testing.jpeg',
        credentialId: '071177',
        featured: false
    },
    {
        id: 'copado-ai',
        name: 'Copado Certified — Copado AI',
        issuer: 'Copado',
        recipient: 'Rahul Khaire',
        date: 'March 23, 2026',
        type: 'Certification',
        category: 'AI / Data',
        description: 'The certificate is headed “Copado AI” and states Copado Salesforce DevOps certification.',
        file: 'copado-ai.png',
        credentialId: '062459',
        featured: false
    },
    {
        id: 'oracle-ai-foundations',
        name: 'Oracle Cloud Infrastructure 2024 Certified AI Foundations Associate',
        issuer: 'Oracle University',
        recipient: 'Rahul Khaire',
        date: '',
        type: 'Certification',
        category: 'Cloud',
        description: 'Oracle Certified Foundations Associate credential for Oracle Cloud Infrastructure 2024 AI Foundations.',
        file: 'oracle-ai-foundations.jpeg',
        featured: false
    },
    {
        id: 'google-cloud-computing',
        name: 'Google Cloud Computing Fundamentals & Generative AI',
        issuer: 'Google Developer Student Clubs — Maharashtra Institute of Technology',
        recipient: 'Rahul Khaire',
        date: '',
        type: 'Certificate of Appreciation',
        category: 'Cloud',
        description: 'Certificate of appreciation for completing Google Cloud Study Jam training in Cloud Computing Fundamentals and Generative AI.',
        file: 'google-cloud-fundamentals.jpeg',
        featured: false
    },
    {
        id: 'google-genai-study-jams',
        name: 'Google GenAI Study Jams',
        issuer: 'Google Developer Student Clubs — Maharashtra Institute of Technology',
        recipient: 'Rahul Khaire',
        date: '',
        type: 'Certificate of Appreciation',
        category: 'AI / Data',
        description: 'The certificate lists Prompt Design in Vertex AI, GenAI apps with Gemini and Streamlit, and GenAI registries.',
        file: 'google-genai-study-jams.jpeg',
        featured: false
    },
    {
        id: 'cendance-internship',
        name: 'Internship Completion Certificate',
        issuer: 'Cendance Systems Inc.',
        recipient: 'Rahul Khaire',
        date: '',
        period: 'February–May 2025',
        type: 'Internship Completion Certificate',
        category: 'Development',
        description: 'Certificate states completion of a four-month internship focused on Salesforce CRM implementation, optimization and business process solutions.',
        file: 'cendance-internship.jpeg',
        featured: false
    },
    {
        id: 'pinnacle-internship',
        name: 'Internship Completion Letter',
        issuer: 'Pinnacle Technologies',
        recipient: 'Rahul Vasant Khaire',
        date: 'April 30, 2026',
        type: 'Internship Completion Letter',
        category: 'Development',
        description: 'Letter describes a Salesforce Developer internship and mentions frontend customization, backend logic, API integrations and deployment processes.',
        file: 'pinnacle-internship.png',
        featured: false
    }
];

const CATEGORY_ORDER = ['Salesforce', 'Cloud', 'AI / Data', 'Development'];

export default class CertificateGallery extends LightningElement {
    activeCategory = 'All';
    selectedCertificate = null;
    isZoomed = false;
    previouslyFocusedElement;
    hasFocusedLightbox = false;
    previousBodyOverflow = '';

    get categories() {
        const presentCategories = new Set(CERTIFICATE_RECORDS.map((certificate) => certificate.category));
        return [
            { name: 'All', value: 'All', selected: this.activeCategory === 'All', buttonClass: `filter-button${this.activeCategory === 'All' ? ' active' : ''}` },
            ...CATEGORY_ORDER.filter((category) => presentCategories.has(category)).map((category) => ({
                name: category,
                value: category,
                selected: this.activeCategory === category,
                buttonClass: `filter-button${this.activeCategory === category ? ' active' : ''}`
            }))
        ];
    }

    get certificates() {
        return CERTIFICATE_RECORDS
            .filter((certificate) => this.activeCategory === 'All' || certificate.category === this.activeCategory)
            .map((certificate) => ({
                ...certificate,
                imageUrl: `${CERTIFICATE_ASSETS}/${certificate.file}`,
                hasDate: Boolean(certificate.date),
                hasPeriod: Boolean(certificate.period),
                hasCredentialId: Boolean(certificate.credentialId),
                hasReference: Boolean(certificate.referenceId),
                hasCredentialUrl: Boolean(certificate.credentialUrl),
                cardClass: `certificate-card${certificate.featured ? ' featured-certificate' : ''}`,
                imageAlt: `${certificate.recipient} — ${certificate.name} certificate from ${certificate.issuer}`,
                viewLabel: `View ${certificate.name} from ${certificate.issuer}`
            }));
    }

    get certificateCount() { return CERTIFICATE_RECORDS.length; }
    get hasResults() { return this.certificates.length > 0; }
    get selectedImageClass() { return `lightbox-image${this.isZoomed ? ' zoomed' : ''}`; }
    get zoomLabel() { return this.isZoomed ? 'Fit certificate to screen' : 'Zoom certificate'; }
    get zoomText() { return this.isZoomed ? 'Fit to screen' : 'Zoom'; }
    get hasSelection() { return Boolean(this.selectedCertificate); }

    handleCategory(event) { this.activeCategory = event.currentTarget.dataset.category; }
    showPrevious() { this.scrollCertificates(-1); }
    showNext() { this.scrollCertificates(1); }

    scrollCertificates(direction) {
        const track = this.template.querySelector('.certificate-grid');
        if (!track) return;
        const firstCard = track.querySelector('.certificate-card');
        const cardWidth = firstCard?.getBoundingClientRect().width || track.clientWidth * 0.8;
        const gap = Number.parseFloat(window.getComputedStyle(track).columnGap) || 16;
        const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        track.scrollBy({ left: direction * (cardWidth + gap), behavior: reduceMotion ? 'auto' : 'smooth' });
    }

    openCertificate(event) {
        const certificate = CERTIFICATE_RECORDS.find((item) => item.id === event.currentTarget.dataset.id);
        if (!certificate) return;

        this.previouslyFocusedElement = event.currentTarget;
        this.selectedCertificate = {
            ...certificate,
            imageUrl: `${CERTIFICATE_ASSETS}/${certificate.file}`,
            imageAlt: `${certificate.recipient} — ${certificate.name} certificate from ${certificate.issuer}`
        };
        this.isZoomed = false;
        this.previousBodyOverflow = document.body.style.overflow;
        document.body.style.overflow = 'hidden';
    }

    closeCertificate() {
        this.selectedCertificate = null;
        this.isZoomed = false;
        this.hasFocusedLightbox = false;
        document.body.style.overflow = this.previousBodyOverflow;
        window.requestAnimationFrame(() => this.previouslyFocusedElement?.focus());
    }

    toggleZoom() { this.isZoomed = !this.isZoomed; }

    handleBackdropClick(event) {
        if (event.target === event.currentTarget) this.closeCertificate();
    }

    stopPropagation(event) { event.stopPropagation(); }

    handleKeydown = (event) => {
        if (!this.selectedCertificate) return;
        if (event.key === 'Escape') {
            event.preventDefault();
            this.closeCertificate();
        } else if (event.key.toLowerCase() === 'z') {
            this.toggleZoom();
        } else if (event.key === 'Tab') {
            const controls = [...this.template.querySelectorAll('.lightbox-control')];
            if (!controls.length) return;
            const first = controls[0];
            const last = controls[controls.length - 1];
            const active = this.template.activeElement;
            if (event.shiftKey && (active === first || !this.template.contains(active))) {
                event.preventDefault();
                last.focus();
            } else if (!event.shiftKey && (active === last || !this.template.contains(active))) {
                event.preventDefault();
                first.focus();
            }
        }
    };

    connectedCallback() { window.addEventListener('keydown', this.handleKeydown); }

    disconnectedCallback() {
        window.removeEventListener('keydown', this.handleKeydown);
        document.body.style.overflow = this.previousBodyOverflow;
    }

    renderedCallback() {
        if (!this.selectedCertificate || this.hasFocusedLightbox) return;
        const closeButton = this.template.querySelector('.lightbox-close');
        if (closeButton) {
            closeButton.focus();
            this.hasFocusedLightbox = true;
        }
    }
}
