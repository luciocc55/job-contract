pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./JobStruct.sol";

contract JobContract is Ownable {
    using SafeMath for uint256;
    string public name;
    Job public job;

    constructor (
        string memory _title, 
        string memory _description
    ) public {
        proposeJob(_title, _description);
    }

    modifier onlyApplicant (address _applicantAddress) {
        bool isApplicant;
        uint256 i = 0;
        Job storage p = job;
        while (i <= p.applicantCount) {
            if (p.applicants[i].addr == _applicantAddress) {
                i = p.applicantCount + 1;
                isApplicant = true;
            }
            i++;
        }
        require(isApplicant, "Address must be from an active applicant on the job...");
        _;
    }
    
    modifier onlyOpen () {
        require(job.jobStatus == 0, "Job must be open for you to apply...");
        _;
    }

    function getApplicant(uint256 _applicantIndex) external view returns(
        address addr,
        string memory experienceDescription,
        string memory contact,
        string memory rate
    ) {
        Job storage p = job;
        Applicant memory applicant = p.applicants[_applicantIndex];
        return (applicant.addr, applicant.experienceDescription, applicant.contact, applicant.rate);
    }

    function getJob() external view returns(
        string memory description,
        string memory title,
        uint256 creationTimestamp,
        uint256 jobStatus,
        address selectedApplicant,
        uint256 applicantCount 
        ) { 
        Job memory p = job;
        return (p.description, p.title, p.creationTimestamp, p.jobStatus, p.selectedApplicant, p.applicantCount);
    }

    function getApplicantCount() external view returns(uint256) { 
        return job.applicantCount;
    }

    function editJob( 
        string memory _title,
        string memory _description,
        address _selectedApplicant,
        uint256 _jobStatus
    ) external onlyOwner {
        job.description = _description;
        job.title = _title;
        job.jobStatus = _jobStatus;
        job.selectedApplicant = _selectedApplicant;
    }
    
    function applyJob(
        address _applicantAddress,
        string memory _experienceDescription,
        string memory _contact, 
        string memory _rate 
    ) external onlyOpen() {
        Applicant memory newApplicant = Applicant({
            addr: _applicantAddress,
            experienceDescription: _experienceDescription,
            contact: _contact,
            rate: _rate
        });
        Job storage p = job;
        p.applicants[p.applicantCount] = newApplicant;
        p.applicantCount++;
    }

    function chooseApplicant(
        address _applicantAddress 
    ) external onlyOwner onlyOpen() onlyApplicant(_applicantAddress) {
        job.selectedApplicant = _applicantAddress;
        job.jobStatus = 1; //1 is the value for a on course job   Subject to review
    }

    function destroyJob() external onlyOwner {
        selfdestruct(msg.sender);
    }

    function proposeJob(string memory _title, string memory _description ) internal {
        Job memory newJob = Job({
            creationTimestamp: block.timestamp,
            title: _title,
            description: _description,
            jobStatus: 0,
            selectedApplicant: address(0),
            applicantCount: 0
        });
        job = newJob;
    }

}