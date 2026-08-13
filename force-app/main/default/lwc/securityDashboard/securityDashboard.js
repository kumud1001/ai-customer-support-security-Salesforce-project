import { LightningElement, wire } from 'lwc';
import getSecurityAlerts from '@salesforce/apex/SecurityAlertController.getSecurityAlerts';
import createSecurityAlert from '@salesforce/apex/SecurityAlertController.createSecurityAlert';
import updateAlertStatus from '@salesforce/apex/SecurityAlertController.updateAlertStatus';
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

    filterSeverity = 'ALL';

get filterSeverityOptions() {
    return [
        { label: 'All Severities', value: 'ALL' },
        { label: 'LOW', value: 'LOW' },
        { label: 'MEDIUM', value: 'MEDIUM' },
        { label: 'HIGH', value: 'HIGH' },
        { label: 'CRITICAL', value: 'CRITICAL' }
    ];
}

handleFilterSeverity(event) {
    this.filterSeverity = event.detail.value;
}

filterThreatType = 'ALL';

get filterThreatTypeOptions() {
    const threatTypes = new Set(
        this.alerts
            .map(alert => alert.Threat_Type__c)
            .filter(type => type)
    );

    return [
        { label: 'All Threat Types', value: 'ALL' },
        ...Array.from(threatTypes).map(type => ({
            label: type,
            value: type
        }))
    ];
}

handleFilterThreatType(event) {
    this.filterThreatType = event.detail.value;
}

get filteredAlerts() {
    return this.alerts.filter(alert => {

        const severityMatch =
            this.filterSeverity === 'ALL' ||
            alert.Severity__c === this.filterSeverity;

        const statusMatch =
            this.filterStatus === 'ALL' ||
            alert.Status__c === this.filterStatus;

        const threatTypeMatch =
            this.filterThreatType === 'ALL' ||
            alert.Threat_Type__c === this.filterThreatType;

        return severityMatch && statusMatch && threatTypeMatch;
    });
}
filterStatus = 'ALL';

get filterStatusOptions() {
    return [
        { label: 'All Statuses', value: 'ALL' },
        { label: 'New', value: 'New' },
        { label: 'Investigating', value: 'Investigating' },
        { label: 'Resolved', value: 'Resolved' },
        { label: 'Closed', value: 'Closed' }
    ];
}

handleFilterStatus(event) {
    this.filterStatus = event.detail.value;
}
    statusOptions = [
        { label: 'New', value: 'New' },
        { label: 'Investigating', value: 'Investigating' },
        { label: 'Resolved', value: 'Resolved' }
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
    description = '';
    recommendation = '';

    // Status update fields
    selectedAlertId = '';
    selectedStatus = '';

    // rest of your code...

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
    get alertOptions() {
    return this.alerts.map(alert => ({
        label: `${alert.Threat_Type__c} - ${alert.Source_IP__c}`,
        value: alert.Id
    }));
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
      handleClearFilters() {
    this.filterSeverity = 'ALL';
    this.filterStatus = 'ALL';
    this.filterThreatType = 'ALL';
      }
    handleAttackType(event) {
        this.attackType = event.target.value;
    }
    handleDescription(event) {
    this.description = event.target.value;
}

    handleRecommendation(event) {
    this.recommendation = event.target.value;
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
                description: this.description,
                recommendation: this.recommendation
            });

            console.log('Security Alert created:', result);

            await refreshApex(this.wiredAlertsResult);

            this.incidentName = '';
            this.threatType = '';
            this.riskScore = null;
            this.sourceIp = '';
            this.severity = '';
            this.attackType = '';
            this.description = '';
            this.recommendation = '';

        } catch (error) {

            console.error('Error creating Security Alert:', error);
            this.error = error;

        } finally {

            this.isLoading = false;
        }
    }
    async handleRefresh() {
    this.isLoading = true;
    this.error = undefined;

    try {
        await refreshApex(this.wiredAlertsResult);
    } catch (error) {
        console.error('Error refreshing alerts:', error);
        this.error = error;
    } finally {
        this.isLoading = false;
    }
}

    handleStatusChange(event) {
        this.selectedStatus = event.target.value;
    }

    handleAlertSelection(event) {
        this.selectedAlertId = event.detail.value;
    }

    async handleUpdateStatus() {

        if (!this.selectedAlertId || !this.selectedStatus) {
            return;
        }

        this.isLoading = true;
        this.error = undefined;

        try {

            await updateAlertStatus({
                alertId: this.selectedAlertId,
                newStatus: this.selectedStatus
            });

            await refreshApex(this.wiredAlertsResult);

            this.selectedAlertId = '';
            this.selectedStatus = '';

        } catch (error) {

            console.error('Error updating alert status:', error);
            this.error = error;

        } finally {

            this.isLoading = false;
        }
    }
}