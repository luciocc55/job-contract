pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract JobPlatformData {
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

    Job[] public jobs;
    //Settings
    uint256 jobCount;
}


contract JobContract is Ownable, JobPlatformData {
    using SafeMath for uint256;
    
    modifier onlyApplicant (address _applicantAddress, uint256 _jobIndex) {
        bool isApplicant;
        uint256 i = 0;
        Job storage p = jobs[_jobIndex];
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
    
    modifier onlyOpen (uint256 _jobIndex) {
        require(jobs[_jobIndex].jobStatus == 0, "Job must be open for you to apply...");
        _;
    }
    
    modifier notClosed (uint256 _jobIndex) {
        require(jobs[_jobIndex].jobStatus != 2, "Job cannot be closed for you to edit it...");
        _;
    }
    
    function getJobCount() external view returns(uint256) { 
        return jobCount;
    }

    function getApplicant(uint256 _jobIndex, uint256 _applicantIndex) external view returns(
        address addr,
        string memory experienceDescription,
        string memory contact,
        string memory rate
    ) {
        Job storage p = jobs[_jobIndex];
        Applicant memory applicant = p.applicants[_applicantIndex];
        return (applicant.addr, applicant.experienceDescription, applicant.contact, applicant.rate);
    }

    function getJob(uint256 _jobIndex) external view returns(
        string memory description,
        string memory title,
        uint256 creationTimestamp,
        uint256 jobStatus,
        address selectedApplicant,
        uint256 applicantCount 
        ) { 
        Job memory p = jobs[_jobIndex];
        return (p.description, p.title, p.creationTimestamp, p.jobStatus, p.selectedApplicant, p.applicantCount);
    }

    function getApplicantCount(uint256 _jobIndex) external view returns(uint256) { 
        return jobs[_jobIndex].applicantCount;
    }

    function editJob(
        uint256 _jobIndex, 
        string memory _title,
        string memory _description,
        address _selectedApplicant,
        uint256 _jobStatus
    ) external onlyOwner notClosed(_jobIndex) {
        jobs[_jobIndex].description = _description;
        jobs[_jobIndex].title = _title;
        jobs[_jobIndex].jobStatus = _jobStatus;
        jobs[_jobIndex].selectedApplicant = _selectedApplicant;
    }
    
    function proposeJob(string memory _title, string memory _description ) external {
        Job memory newJob = Job({
            creationTimestamp: block.timestamp,
            title: _title,
            description: _description,
            jobStatus: 0,
            selectedApplicant: address(0),
            applicantCount: 0
        });
        jobs.push(newJob);
        jobCount++;
    }
    
    function applyJob(
        uint256 _jobIndex, 
        string memory _experienceDescription,
        string memory _contact, 
        string memory _rate 
    ) external onlyOpen(_jobIndex) {
        Applicant memory newApplicant = Applicant({
            addr: msg.sender,
            experienceDescription: _experienceDescription,
            contact: _contact,
            rate: _rate
        });
        Job storage p = jobs[_jobIndex];
        p.applicants[p.applicantCount] = newApplicant;
        p.applicantCount++;
    }

    function chooseApplicant(
        uint256 _jobIndex, 
        address _applicantAddress 
    ) external onlyOwner onlyOpen(_jobIndex) onlyApplicant(_applicantAddress, _jobIndex) {
        jobs[_jobIndex].selectedApplicant = _applicantAddress;
        jobs[_jobIndex].jobStatus = 1; //1 is the value for a on course job   Subject to review
    }

    function closeJob(uint256 _jobIndex ) external onlyOwner onlyOpen(_jobIndex) {
        jobs[_jobIndex].jobStatus = 2; //2 is the value for a closed job   Subject to review
    }

}