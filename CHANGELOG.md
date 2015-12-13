#CHANGELOG

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