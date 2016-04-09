#CHANGELOG

## [0.3.0] - 2016-04-09

### Added

- Multiple email notification recipients
- Email notification for login failures

### Fixed

- Japanese translations. #26 thanks @anton-sergeev
- Calendar icon not showing when Redmine is installed in a sub-URI. #26 thanks @anton-sergeev

## [0.2.4] - 2016-03-19

### Fixed

- Compatibility with Redmine 3.2.1. #27 thanks @GitRms and Marco Senn
- Migrations rollback. thanks Marco Senn

### Changed

- Improved logging

## [0.2.3] - 2016-01-30

### Fixed

- Compatibility with Redmine 3.2.x. #22 thanks @topkool

### Added

- Chinese translations. Thanks @dreampet
- Partial Turkish translations. Thanks @giraypultar

## [0.2.2] - 2015-12-13

### Fixed

- Error when no JavaScript runtime is installed. #19 thanks @Catlon
- Error when filtering on user columns. #17 thanks @mmaker86

## [0.2.1] - 2015-10-25

### Added

- German translations

## [0.2.0] - 2015-10-10

### Added

- Redmine 3.x compatibility. Thanks AlexStein
- More logging options: None, Success, Failure, Success and Failure
- WiceGrid listing of Audit records
- API auditing
- Logging URL and Method. (Makes sense mostly for API logging)
- Japanese translations. Thanks kotashiratsuka
- Correct copyright attribution

### Changed

- Switched to MIT-like license
- Improved code organization
- Changed ip_address field length from 255 to 39 (IPv6 length)