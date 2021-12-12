pragma solidity 0.6.12;
import "@openzeppelin/contracts/math/SafeMath.sol";


contract JobStruct {
    using SafeMath for uint256;

    struct Applicant {
        address addr;
        string experienceDescription;
        string contact;
        string rate;
    }

    struct Job {
        string description;
        string title;
        uint256 creationTimestamp;
        uint256 jobStatus;
        address selectedApplicant; //Address of the person chosen for the job
        mapping(uint => Applicant) applicants;
        uint applicantCount;
    }
}