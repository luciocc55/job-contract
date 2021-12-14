pragma solidity 0.6.12;
import "./ApplicantStruct.sol";

struct Job {
    string description;
    string title;
    uint256 creationTimestamp;
    uint256 jobStatus;
    address selectedApplicant; //Address of the person chosen for the job
    mapping(uint => Applicant) applicants;
    uint applicantCount;
}
