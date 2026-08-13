import { LightningElement, wire } from 'lwc';
import getSecurityAlerts from '@salesforce/apex/SecurityAlertController.getSecurityAlerts';
import createSecurityAlert from '@salesforce/apex/SecurityAlertController.createSecurityAlert';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    {
        label: 'Threat Type',
        fieldName: 'Threat_Type__c'
    },
    {
        label: 'Severity',
        fieldName: 'Severity__c'
    },
    {
        label: 'Source IP',
        fieldName: 'Source_IP__c'
    },
    {
        label: 'Risk Score',
        fieldName: 'Risk_Score__c',
        type: 'number'
    },
    {
        label: 'Status',
        fieldName: 'Status__c'
    },
    {
        label: 'Detected At',
        fieldName: 'Detected_At__c',
        type: 'date',
        typeAttributes: {
            year: 'numeric',
            month: 'short',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }
    }
];

export default class SecurityDashboard extends LightningElement {


     severityOptions = [
        { label: 'LOW', value: 'LOW' },
        { label: 'MEDIUM', value: 'MEDIUM' },
        { label: 'HIGH', value: 'HIGH' },
        { label: 'CRITICAL', value: 'CRITICAL' }
    ];


    alerts = [];
    error;
    isLoading = true;
    wiredAlertsResult;

    columns = COLUMNS;

    // Form fields
    incidentName = '';
    threatType = '';
    riskScore = null;
    sourceIp = '';
    severity = '';
    attackType = '';

    @wire(getSecurityAlerts)
    wiredAlerts(result) {

        this.wiredAlertsResult = result;

        const { data, error } = result;

        if (data) {
            this.alerts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.alerts = [];
        }

        this.isLoading = false;
    }

    get totalAlerts() {
        return this.alerts.length;
    }

    get criticalAlerts() {
        return this.alerts.filter(
            alert => alert.Severity__c === 'CRITICAL'
        ).length;
    }

    get highRiskAlerts() {
        return this.alerts.filter(
            alert =>
                alert.Severity__c === 'HIGH' ||
                alert.Severity__c === 'CRITICAL'
        ).length;
    }

    handleIncidentName(event) {
        this.incidentName = event.target.value;
    }

    handleThreatType(event) {
        this.threatType = event.target.value;
    }

    handleRiskScore(event) {
       this.riskScore = Number(event.target.value);
    }

    handleSourceIp(event) {
        this.sourceIp = event.target.value;
    }

    handleSeverity(event) {
        this.severity = event.target.value;
    }

    handleAttackType(event) {
        this.attackType = event.target.value;
    }
async handleCreateAlert() {

    this.isLoading = true;
    this.error = undefined;

    try {

        const result = await createSecurityAlert({
            threatType: this.threatType,
            severity: this.severity,
            sourceIp: this.sourceIp,
            riskScore: Number(this.riskScore),
            description: this.incidentName,
            recommendation: this.attackType
        });

        console.log('Security Alert created:', result);

        await refreshApex(this.wiredAlertsResult);

        this.incidentName = '';
        this.threatType = '';
        this.riskScore = null;
        this.sourceIp = '';
        this.severity = '';
        this.attackType = '';

    } catch (error) {

        console.error('Error creating Security Alert:', error);
        this.error = error;

    } finally {

        this.isLoading = false;
    }
}