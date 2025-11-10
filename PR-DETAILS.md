## Description

Transportation compliance platform managing CDL medical certifications with FMCSA compliance, examiner verification, exam scheduling, and health record maintenance.

## Key Features

### Driver Registry
- CDL number tracking
- Certification status management
- Expiration monitoring
- Medical restrictions documentation
- Last exam date tracking

### Medical Examiner Management
- National Registry verification
- License tracking
- Credential expiry monitoring
- Exam history statistics
- Active status management

### Examination System
- Exam scheduling with locations
- Blood pressure recording
- Vision and hearing test results
- Medical conditions documentation
- Medication tracking
- Pass/fail determination

### Certificate Issuance
- Automated certificate generation
- 1-24 month certification periods
- Restriction management
- Variance and waiver support
- Status tracking (active, expired, suspended, revoked)

### Compliance Features
- FMCSA Part 391 adherence
- Examiner credential verification
- Automatic expiration tracking
- Audit trail maintenance
- Regulatory reporting support

## Contract Functions

### Read-Only
- `get-driver`: Driver information and status
- `get-examiner`: Examiner credentials
- `get-examination`: Exam results
- `get-certificate`: Certificate details
- `is-driver-certified`: Certification validity check
- `is-examiner-active`: Examiner status verification

### Public
- `register-driver`: Add new commercial drivers
- `register-examiner`: Add certified medical examiners
- `schedule-exam`: Create exam appointments
- `complete-exam`: Document examination results
- `issue-certificate`: Generate medical certificates
- `suspend-certification`: Suspend driver certification
- `deactivate-examiner`: Deactivate medical examiner

## Workflow

1. Register driver with CDL information
2. Register certified medical examiner
3. Schedule medical examination
4. Complete exam with health assessment
5. Issue certificate if exam passed
6. Track expiration and schedule renewals
7. Suspend or revoke if needed

## Compliance

- FMCSA Part 391 medical certification standards
- National Registry of Certified Medical Examiners
- DOT physical examination requirements
- Certificate period regulations (1-24 months)
- Variance and waiver management

## Security

- Admin-only examiner registration
- HIPAA-compliant data structure
- Immutable exam records
- Access control enforcement
- Secure health information storage

## Testing

Validated with `clarinet check` - all syntax verification passed.

## Dependencies

- Clarinet CLI
- Stacks blockchain
- Node.js environment
