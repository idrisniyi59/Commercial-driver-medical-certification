;; Commercial Driver Medical Certification Coordinator
;; Schedule medical exams, track certification expiration, verify examiner credentials, maintain driver health records, and ensure compliance

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u103))
(define-constant err-expired (err u105))
(define-constant err-not-certified (err u106))

;; Data Variables
(define-data-var driver-id-nonce uint u0)
(define-data-var examiner-id-nonce uint u0)
(define-data-var exam-id-nonce uint u0)
(define-data-var cert-id-nonce uint u0)

;; Certification Status
(define-constant cert-active u1)
(define-constant cert-expired u2)
(define-constant cert-suspended u3)
(define-constant cert-revoked u4)

;; Exam Status
(define-constant exam-scheduled u0)
(define-constant exam-completed u1)
(define-constant exam-passed u2)
(define-constant exam-failed u3)

;; Data Maps

;; Driver Registry
(define-map drivers
    { driver-id: uint }
    {
        cdl-number: (string-ascii 50),
        name: (string-ascii 100),
        date-of-birth: uint,
        current-cert-status: uint,
        current-cert-expiry: uint,
        last-exam-date: uint,
        restrictions: (string-ascii 200),
        registered-at: uint
    }
)

;; Medical Examiner Registry
(define-map examiners
    { examiner-id: uint }
    {
        name: (string-ascii 100),
        national-registry-number: (string-ascii 50),
        license-number: (string-ascii 50),
        credential-expiry: uint,
        active: bool,
        total-exams-conducted: uint,
        registered-at: uint
    }
)

;; Medical Examinations
(define-map examinations
    { exam-id: uint }
    {
        driver-id: uint,
        examiner-id: uint,
        scheduled-date: uint,
        exam-date: uint,
        status: uint,
        blood-pressure-systolic: uint,
        blood-pressure-diastolic: uint,
        vision-acuity: (string-ascii 20),
        hearing-test-passed: bool,
        medical-conditions: (string-ascii 300),
        medications: (string-ascii 300),
        notes: (string-ascii 300)
    }
)

;; Medical Certificates
(define-map certificates
    { cert-id: uint }
    {
        driver-id: uint,
        exam-id: uint,
        examiner-id: uint,
        issue-date: uint,
        expiry-date: uint,
        cert-period-months: uint,
        status: uint,
        restrictions: (string-ascii 200),
        variance-granted: bool,
        variance-details: (string-ascii 200)
    }
)

;; Exam Scheduling
(define-map exam-schedule
    { driver-id: uint, scheduled-date: uint }
    {
        examiner-id: uint,
        location: (string-ascii 150),
        confirmed: bool
    }
)

;; Read-only functions

;; Get driver information
(define-read-only (get-driver (driver-id uint))
    (ok (map-get? drivers { driver-id: driver-id }))
)

;; Get examiner information
(define-read-only (get-examiner (examiner-id uint))
    (ok (map-get? examiners { examiner-id: examiner-id }))
)

;; Get examination record
(define-read-only (get-examination (exam-id uint))
    (ok (map-get? examinations { exam-id: exam-id }))
)

;; Get certificate
(define-read-only (get-certificate (cert-id uint))
    (ok (map-get? certificates { cert-id: cert-id }))
)

;; Check if driver certification is valid
(define-read-only (is-driver-certified (driver-id uint))
    (match (map-get? drivers { driver-id: driver-id })
        driver-data (ok (and
            (is-eq (get current-cert-status driver-data) cert-active)
            (> (get current-cert-expiry driver-data) block-height)
        ))
        (err err-not-found)
    )
)

;; Check if examiner is active
(define-read-only (is-examiner-active (examiner-id uint))
    (match (map-get? examiners { examiner-id: examiner-id })
        examiner-data (ok (and
            (get active examiner-data)
            (> (get credential-expiry examiner-data) block-height)
        ))
        (err err-not-found)
    )
)

;; Public functions

;; Register driver
(define-public (register-driver
    (cdl-number (string-ascii 50))
    (name (string-ascii 100))
    (date-of-birth uint))
    (let
        (
            (new-driver-id (+ (var-get driver-id-nonce) u1))
        )
        (map-set drivers
            { driver-id: new-driver-id }
            {
                cdl-number: cdl-number,
                name: name,
                date-of-birth: date-of-birth,
                current-cert-status: cert-expired,
                current-cert-expiry: u0,
                last-exam-date: u0,
                restrictions: "",
                registered-at: block-height
            }
        )
        (var-set driver-id-nonce new-driver-id)
        (ok new-driver-id)
    )
)

;; Register medical examiner
(define-public (register-examiner
    (name (string-ascii 100))
    (national-registry-number (string-ascii 50))
    (license-number (string-ascii 50))
    (credential-expiry uint))
    (let
        (
            (new-examiner-id (+ (var-get examiner-id-nonce) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-set examiners
            { examiner-id: new-examiner-id }
            {
                name: name,
                national-registry-number: national-registry-number,
                license-number: license-number,
                credential-expiry: credential-expiry,
                active: true,
                total-exams-conducted: u0,
                registered-at: block-height
            }
        )
        (var-set examiner-id-nonce new-examiner-id)
        (ok new-examiner-id)
    )
)

;; Schedule medical exam
(define-public (schedule-exam
    (driver-id uint)
    (examiner-id uint)
    (scheduled-date uint)
    (location (string-ascii 150)))
    (let
        (
            (new-exam-id (+ (var-get exam-id-nonce) u1))
        )
        (asserts! (is-some (map-get? drivers { driver-id: driver-id })) err-not-found)
        (asserts! (is-some (map-get? examiners { examiner-id: examiner-id })) err-not-found)
        
        (map-set examinations
            { exam-id: new-exam-id }
            {
                driver-id: driver-id,
                examiner-id: examiner-id,
                scheduled-date: scheduled-date,
                exam-date: u0,
                status: exam-scheduled,
                blood-pressure-systolic: u0,
                blood-pressure-diastolic: u0,
                vision-acuity: "",
                hearing-test-passed: false,
                medical-conditions: "",
                medications: "",
                notes: ""
            }
        )
        
        (map-set exam-schedule
            { driver-id: driver-id, scheduled-date: scheduled-date }
            {
                examiner-id: examiner-id,
                location: location,
                confirmed: false
            }
        )
        
        (var-set exam-id-nonce new-exam-id)
        (ok new-exam-id)
    )
)

;; Complete medical exam
(define-public (complete-exam
    (exam-id uint)
    (blood-pressure-systolic uint)
    (blood-pressure-diastolic uint)
    (vision-acuity (string-ascii 20))
    (hearing-test-passed bool)
    (medical-conditions (string-ascii 300))
    (medications (string-ascii 300))
    (passed bool)
    (notes (string-ascii 300)))
    (let
        (
            (exam-data (unwrap! (map-get? examinations { exam-id: exam-id }) err-not-found))
            (examiner-data (unwrap! (map-get? examiners { examiner-id: (get examiner-id exam-data) }) err-not-found))
            (driver-data (unwrap! (map-get? drivers { driver-id: (get driver-id exam-data) }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        
        ;; Update exam record
        (map-set examinations
            { exam-id: exam-id }
            (merge exam-data {
                exam-date: block-height,
                status: (if passed exam-passed exam-failed),
                blood-pressure-systolic: blood-pressure-systolic,
                blood-pressure-diastolic: blood-pressure-diastolic,
                vision-acuity: vision-acuity,
                hearing-test-passed: hearing-test-passed,
                medical-conditions: medical-conditions,
                medications: medications,
                notes: notes
            })
        )
        
        ;; Update examiner stats
        (map-set examiners
            { examiner-id: (get examiner-id exam-data) }
            (merge examiner-data {
                total-exams-conducted: (+ (get total-exams-conducted examiner-data) u1)
            })
        )
        
        ;; Update driver record
        (map-set drivers
            { driver-id: (get driver-id exam-data) }
            (merge driver-data {
                last-exam-date: block-height
            })
        )
        
        (ok true)
    )
)

;; Issue medical certificate
(define-public (issue-certificate
    (exam-id uint)
    (cert-period-months uint)
    (restrictions (string-ascii 200))
    (variance-granted bool)
    (variance-details (string-ascii 200)))
    (let
        (
            (exam-data (unwrap! (map-get? examinations { exam-id: exam-id }) err-not-found))
            (driver-data (unwrap! (map-get? drivers { driver-id: (get driver-id exam-data) }) err-not-found))
            (new-cert-id (+ (var-get cert-id-nonce) u1))
            (expiry-date (+ block-height (* cert-period-months u720)))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (is-eq (get status exam-data) exam-passed) err-unauthorized)
        
        ;; Create certificate
        (map-set certificates
            { cert-id: new-cert-id }
            {
                driver-id: (get driver-id exam-data),
                exam-id: exam-id,
                examiner-id: (get examiner-id exam-data),
                issue-date: block-height,
                expiry-date: expiry-date,
                cert-period-months: cert-period-months,
                status: cert-active,
                restrictions: restrictions,
                variance-granted: variance-granted,
                variance-details: variance-details
            }
        )
        
        ;; Update driver record
        (map-set drivers
            { driver-id: (get driver-id exam-data) }
            (merge driver-data {
                current-cert-status: cert-active,
                current-cert-expiry: expiry-date,
                restrictions: restrictions
            })
        )
        
        (var-set cert-id-nonce new-cert-id)
        (ok new-cert-id)
    )
)

;; Suspend certification
(define-public (suspend-certification (driver-id uint))
    (let
        (
            (driver-data (unwrap! (map-get? drivers { driver-id: driver-id }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set drivers
            { driver-id: driver-id }
            (merge driver-data { current-cert-status: cert-suspended })
        ))
    )
)

;; Deactivate examiner
(define-public (deactivate-examiner (examiner-id uint))
    (let
        (
            (examiner-data (unwrap! (map-get? examiners { examiner-id: examiner-id }) err-not-found))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (ok (map-set examiners
            { examiner-id: examiner-id }
            (merge examiner-data { active: false })
        ))
    )
)

